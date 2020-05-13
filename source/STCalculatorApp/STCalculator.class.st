Class {
	#name : 'STCalculator',
	#superclass : 'Object',
	#instVars : [
		'lastValue',
		'operation',
		'state',
		'display'
	],
	#pools : [
		'CwConstants'
	],
	#category : 'STCalculatorApp'
}

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
STCalculator >> addButtonsTo: aForm [
	"Private - Add the buttons to the calculator. Assume that the buttons
	 will be placed below the display. The button geometry will be managed
	 by placing them inside a CwRowColmn."
	| rowCol |
	rowCol := aForm
		createRowColumn: 'rowCol'
		argBlock: [:w | w
			orientation: XmHORIZONTAL;
			packing: XmPACKCOLUMN;
			numColumns: 5;
			spacing: 10;
			topAttachment: XmATTACHWIDGET;
			topWidget: display;
			topOffset: 5 ].
	rowCol manageChild.
	
	self buttonNames
		do: [:name |
			(rowCol
				createPushButton: name
				argBlock: nil )
					manageChild;
					addCallback: XmNactivateCallback
					receiver: self
					selector: #pressed:clientData:callData:
					clientData: name ].
					
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
STCalculator >> addDisplayTo: aForm [
	"Private - Create and manage a numeric display for the calculator.
	 The display is implemented as a CwText widget. Assume that the
	 display will be at the top of the calculator."
	display := aForm
		createText: 'text'
		argBlock: [:w | w
			topAttachment: XmATTACHFORM;
			leftAttachment: XmATTACHFORM;
			rightAttachment: XmATTACHFORM ].
	display manageChild.
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
STCalculator >> buttonNames [
	"Answer an array of button names, with each being a String."
	^#('7' '8' '9' '/'
			'4' '5' '6' '*'
			'1' '2' '3' '-'
			'0' '.' '+/-' '+'
			'Clr' '=' 'Pi' 'Off')
					
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
STCalculator >> calculateAnswer: aFunction [
	"Private - Calculate teh answer based on lastValue, aFunction,
	 and the current value. Answer a String."
	| answer last current realFunction |
	
	last := lastValue convertToNumber.
	current := display value convertToNumber.
	aFunction = '='
		ifTrue: [ realFunction := operation ]
		ifFalse: [ realFunction := aFunction ].
	
	state = #equals
		ifTrue: [
			answer := current	
				perform: (realFunction asSymbol)
				with: last ]
		ifFalse: [
			answer := last
				perform: (realFunction asSymbol)
				with: current ].
	answer class = Fraction
		ifTrue: [ answer := answer asFloat ].
		^answer printString
					
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
STCalculator >> clear [
	"Private - Clear the display and lastValue."
	display setString: ''. "No space between single quotes"
	lastValue := nil.
					
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
STCalculator >> close [
	"Shut down the calculator. Just for fun, use a pop-up confirmation
	 dialog."
	(CwMessagePrompter
		confirm: 'Really exit?'
		title: 'Confirmation')
			ifTrue: [
				display shell destroyWidget ]
					
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
STCalculator >> doFunction: aFunction [
	"Private - The user has pressed a function button."
	| temp |
	aFunction = '+/-' ifTrue: [ ^self negate ].
	aFunction = 'Clr' ifTrue: [ ^self clear ].
	aFunction = 'Pi' ifTrue: [ ^self pi ].
	aFunction = 'Off' ifTrue: [ ^self close ].
	aFunction = '='
		ifTrue: [
			temp := display value.
			display setString:
				(self calculateAnswer: aFunction).
			state = #equals
				ifFalse: [ lastValue := temp ].
			state := #equals ]
		ifFalse: [
			lastValue = nil
				ifTrue: [
					lastValue := display value.
					operation := aFunction ]
				ifFalse: [
					state = #equals ifFalse: [
						display setString:
							(self calculateAnswer: operation)].
						operation := aFunction.
						lastValue := display value ].
			display
				setSelection: (0 @ (display value size)).
			display
				setHighlight: (0 @ (display value size))
				mode: XmHIGHLIGHTSELECTED.
			state := #function].
			
					
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
STCalculator >> insert: aString [
	"Private - Insert aString on the display, at the insertion cursor.
	 First delete any text that has been selected."
	display
		remove;
		insert: (display cursorPosition)
		value: aString
					
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
STCalculator >> negate [
	"private - The +/- button has been preseed. Chnage the sign of
	 the current number."
	| string newString |
	string := display value.
	string size > 0
		ifTrue: [ string first = $-     "Minus sign"
			ifTrue: [ string size > 1
				ifTrue: [
					newString := string
						copyFrom: 2 to: string size ]
				ifFalse: [ newString := '' ]]
			ifFalse: [ newString := '-' , string ]]
		ifFalse: [newString := '-' ].
	display setString: newString.
display cursorPosition: (display value size).
			
					
]

{ #category : 'Not categorized' }
STCalculator >> open [
	"Open a new instance of STCalculator"
	| shell form |
	shell := CwTopLevelShell
		createApplicationShell: 'Calculator'
		argBlock: nil.
	form := shell
		createForm: 'form'
		argBlock: nil.
	form manageChild.
	self addDisplayTo: form.
	self addButtonsTo: form.
	shell realizeWidget.
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
STCalculator >> pi [
	"The pi button has been pressed. Display its value."
	self insert: (Float pi printString)
			
					
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
STCalculator >> pressed: aWdiget clientData: clientData callData: callData [
	"Private - A Button has been pressed. The button name is clientData,
	 so we can figure out whether to display a character or perform an
	 operation."
	( #('.' '0' '1' '2' '3' '4' '5' '6' '7' '8' '9')
		includes: clientData)
			ifTrue: [ self insert: clientData ]
			ifFalse: [ self doFunction: clientData ].
		display isDestroyed
			ifFalse: [ display setInputFocus ].
					
]
