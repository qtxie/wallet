Red [
	Title:	 "RPC library"
	Author:  "Xie Qingtian, Nenad Rakocevic"
	File: 	 %rpc.red
	Needs:	 View
	Tabs: 	 4
	Rights:  "Copyright (C) 2018 Red Foundation. All rights reserved."
	License: {
		Distributed under the Boost Software License, Version 1.0.
		See https://github.com/red/red/blob/master/BSL-License.txt
	}
]

context [

	headers: compose [
		Content-Type: "application/json"
		Accept: "application/json"
		User-Agent: (
			form reduce [
				{Red Wallet version}
				0.1.0
				{for} system/platform/OS
			]
		)
	]

	body: #(
		jsonrpc: "2.0"
		id: 1
		method: none
		params: none
	)

	set 'rpc-call func [network [url!] method [word!] params [none! block!] /local url][
		body/method: method
		body/params: params
		select json/decode write network compose/only [
			POST
			(headers)
			(to-binary json/encode body)
		] 'result
	]

]
