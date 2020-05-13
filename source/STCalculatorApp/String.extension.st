Extension {
	#name : 'String'
}

{ #category : '*STCalculatorApp',
 #vaCategories : ['Not categorized'] }
String >> convertToNumber [
	"Convert the receiver to a number. Answer either an
	Integer or a Float."
	| subStrings whole decimal exponent |
	subStrings := self subStrings: $. .
	whole := (subStrings at: 1) asNumber.
	subStrings size = 1
		ifTrue: [ ^whole ]
		ifFalse: [
			decimal := subStrings at: 2.
			(decimal includes: $e)
				ifTrue: [
					subStrings := decimal subStrings: $e.
					exponent := (subStrings at: 2) asNumber.
					decimal := subStrings at: 1]
				ifFalse: [
					exponent := 0 ].
			^(whole +
				(decimal asNumber /
				(10 raisedTo: (decimal size))))
				* (10 raisedTo: exponent) asFloat ].
			
					
]
