Red [
	Title:	"Batch payment utils"
	Author: "Xie Qingtian"
	File: 	%batch-payment.red
	Tabs: 	4
	License: {
		Distributed under the Boost Software License, Version 1.0.
		See https://github.com/red/red/blob/master/BSL-License.txt
	}
]

payment-stop?: no
batch-results: make block! 4

sanitize-payments: func [data [block! none!] /local entry c][
	if block? data [
		foreach entry data [
			if find "√×" last entry [
				clear skip tail entry -3
			]
		]
	]
	data
]

do-add-payment: func [face event /local entry][
	entry: rejoin [
		pad payment-name/text 12
		payment-addr/text "        "
		payment-amount/text
	]
	either add-payment-btn/text = "Add" [
		append payment-list/data entry
	][
		poke payment-list/data payment-list/selected entry
	]
	unview
]

do-import-payments: function [face event][
	if f: request-file [
		payment-list/data: sanitize-payments load f
	]
]

do-export-payments: func [face event][
	if f: request-file/save [
		save f sanitize-payments payment-list/data
	]
]

do-check-result: function [face event][
	foreach result batch-results [
		either string? result [
			browse rejoin [explorer result]
		][							;-- error
			tx-error/text: rejoin ["Error! Please try again^/^/" form result]
			view/flags tx-error-dlg 'modal
		]
	]
]

do-batch-payment: func [
	face	[object!]
	event	[event!]
	/local from-addr nonce entry addr to-addr amount result idx
][
	if batch-send-btn/text = "Stop" [
		payment-stop?: yes
		exit
	]
	clear batch-results
	payment-stop?: no
	batch-result-btn/visible?: no
	from-addr: copy/part pick addr-list/data addr-list/selected 42
	nonce: eth/get-nonce network from-addr
	if nonce = -1 [
		view/flags nonce-error-dlg 'modal
		exit
	]

	;-- Edge case: ledger key may locked in this moment
	unless string? ledger/get-address 0 [
		view/flags unlock-dev-dlg 'modal
		exit
	]

	batch-send-btn/text: "Stop"
	idx: 1
	foreach entry payment-list/data [
		payment-list/selected: idx
		process-events
		addr: find entry "0x"
		to-addr: copy/part addr 42
		amount: trim copy skip addr 42
		signed-data: sign-transaction
			from-addr
			to-addr
			batch-gas-price/text
			"21000"
			amount
			nonce

		if payment-stop? [break]

		append entry either all [
			signed-data
			binary? signed-data
		][
			result: eth/call-rpc network 'eth_sendRawTransaction reduce [
				rejoin ["0x" enbase/base signed-data 16]
			]
			append batch-results result
			either string? result [nonce: nonce + 1 "  √"]["  ×"]
		][
			if signed-data = 'token-error [
				view/flags contract-data-dlg 'modal
				break
			]
			"  ×"
		]
		idx: idx + 1
	]
	unless empty? batch-results [batch-result-btn/visible?: yes]
	batch-send-btn/text: "Send"
]

batch-send-dialog: layout [
	title "Batch Payment"
	style lbl:   text  360 middle font [name: font-fixed size: 11]
	text "Account:" batch-addr-from: lbl
	text "Gas Price:"  batch-gas-price: field 48 "21" return

	payment-list: text-list font list-font data [] 600x400 below
	button "Add"	[
		add-payment-dialog/text: "Add payment"
		add-payment-btn/text: "Add"
		view/flags add-payment-dialog 'modal
	]
	button "Edit"	[
		add-payment-dialog/text: "Edit payment"
		entry: pick payment-list/data payment-list/selected
		payment-name/text: copy/part entry find entry #" "
		payment-addr/text: copy/part addr: find entry "0x" 42
		payment-amount/text: trim copy skip addr 42
		add-payment-btn/text: "OK"
		view/flags add-payment-dialog 'modal
	]
	button "Remove" [remove at payment-list/data payment-list/selected]
	button "Import" :do-import-payments
	button "Export" :do-export-payments
	pad 0x165
	batch-result-btn: button "Results" :do-check-result
	batch-send-btn: button "Send"	:do-batch-payment
	do [batch-result-btn/visible?: no]
]

add-payment-dialog: layout [
	style field: field 360 font [name: font-fixed size: 10]
	group-box [
		text "Name:" payment-name: field return
		text "Address:" payment-addr: field return
		text "Amount:" payment-amount: field
	] return
	pad 160x0 add-payment-btn: button "Add" :do-add-payment
	pad 20x0 button "Cancel" [unview]
]