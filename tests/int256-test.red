Red []

#include %../../red/quick-test/quick-test.red
#include %../libs/int256.red

~~~start-file~~~ "uint256"
===start-group=== "modulo"
	--test-- "modulo-1"
		x: to-i256 #{B9F88101560F9040AA7C5E03310B55ED1FE50E9382D61EE96AA3010AD1564E01}
		y: to-i256 #{4ADDDECCAB07F966545C9249CD1C35E25D6F15ED4090E9AC71AA939EBCC89696}
		z: to-i256 #{243CC367FFFF9D7401C3396F96D2EA286506E2B901B44B90874DD9CD57C520D5}
		--assert z  = mod256 x  y
===end-group===

===start-group=== "Divide"
	--test-- "divide-1"
		x: to-i256 #{01}
		y: to-i256 #{00}
		--assert error? try [ div256 x y ]
	--test-- "divide-2"
		x: to-i256 #{00}
		y: to-i256 #{00}
		--assert error? try [ div256 x y ]
	
===end-group===


===start-group=== "Floats"

	--test-- "fl-1"  --assert 0.0 		== i256-to-float to-i256 0
	--test-- "fl-2"  --assert 1.0 		== i256-to-float to-i256 1
	--test-- "fl-3"  --assert 10.0		== i256-to-float to-i256 10
	--test-- "fl-4"  --assert 100.0		== i256-to-float to-i256 100
	--test-- "fl-5"  --assert 10000.0	== i256-to-float to-i256 10000
	--test-- "fl-6"  --assert 100000.0	== i256-to-float to-i256 100000
	--test-- "fl-7"  --assert 1000000.0	== i256-to-float to-i256 1000000
	--test-- "fl-8"  --assert 32767.0	== i256-to-float to-i256 32767
	--test-- "fl-9"  --assert 32768.0	== i256-to-float to-i256 32768
	--test-- "fl-10" --assert 032769.0	== i256-to-float to-i256 32769
	--test-- "fl-11" --assert 65535.0	== i256-to-float to-i256 65535
	--test-- "fl-12" --assert 65536.0	== i256-to-float to-i256 65536
	--test-- "fl-13" --assert 65537.0	== i256-to-float to-i256 65537

	--test-- "fl-14" --assert 1000000.0	  == i256-to-float mul256 (to-i256 1000000)    to-i256 1000000
	--test-- "fl-15" --assert 123456789.0 == i256-to-float mul256 (to-i256 123456789)  to-i256 123456789
	--test-- "fl-16" --assert 123456789.0 == i256-to-float mul256 (to-i256 1000000000) to-i256 123456789


	--test-- "fl-30" --assert 0.0		== i256-to-float to-i256 0.0
	--test-- "fl-31" --assert 1.0		== i256-to-float to-i256 1.0
	--test-- "fl-32" --assert 10.0		== i256-to-float to-i256 10.0
	--test-- "fl-33" --assert 100.0		== i256-to-float to-i256 100.0
	--test-- "fl-34" --assert 10000.0	== i256-to-float to-i256 10000.0
	--test-- "fl-35" --assert 100000.0	== i256-to-float to-i256 100000.0
	--test-- "fl-36" --assert 1000000.0	== i256-to-float to-i256 1000000.0
	--test-- "fl-37" --assert 1e20		== i256-to-float to-i256 1e20

===end-group===

~~~end-file~~~
