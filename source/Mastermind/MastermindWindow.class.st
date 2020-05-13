Class {
	#name : 'MastermindWindow',
	#superclass : 'WidgetApplication',
	#instVars : [
		'gc',
		'drawingArea',
		'board',
		'feedBack',
		'colors',
		'answer',
		'currentSpot',
		'finished',
		'duplicates'
	],
	#pools : [
		'CgConstants'
	],
	#category : 'Mastermind'
}

{ #category : 'Not categorized' }
MastermindWindow >> aboutShow [

	"Creates a pop-up showing the highscore"

	(self isRealized)
		ifTrue: [
			(CwMessagePrompter new
				buttonType: XmOK;
				title: ' Mastermind - About';
				iconType: XmNOICON;
				messageString: 'Use the number keys to place a peg of the corresponding color. ', 
										'Use the backspace to remove the last peg. Press enter to submit ', 
										'guess. Black key pegs represent an exact match and white key pegs ', 
										'represent an inexact match';
				prompt)].
]

{ #category : 'Not categorized' }
MastermindWindow >> backDarkGray [

	"Color Dark Gray - Background"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 102 green: 102 blue: 102).
]

{ #category : 'Not categorized' }
MastermindWindow >> backGray [

	"Color Gray - Background"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 153 green: 153 blue: 153).
]

{ #category : 'Not categorized' }
MastermindWindow >> background: anInteger [

	"Set the background colour to anInteger."

	self gc
		setBackground: anInteger
]

{ #category : 'Not categorized' }
MastermindWindow >> backLightGray [

	"Color Light Gray - Background"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 204 green: 204 blue: 204).
]

{ #category : 'Not categorized' }
MastermindWindow >> black [

	"Color Black - Pegs"
	
	^ shell window getPalette 
		nearestPixelValue: Color black
]

{ #category : 'Not categorized' }
MastermindWindow >> blue [

	"Color Blue - Pegs"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 0 green: 102 blue: 255).
]

{ #category : 'Not categorized' }
MastermindWindow >> colorsBoxX: xVal y: yVal [

	"Draws the box at the bottom for the possible colors"

	| text |
	self 
		createRectX: (xVal + 2) y: (yVal + 2) width: 236 height: 58 color: (self backLightGray);
		createRectX: (xVal + 4) y: (yVal + 4) width: 232 height: 56 color: (self backGray).
	1 to: (colors size) do: [:v |
		text := Array with: (self TextItem: (v printString)).
		self 
			createCircleX: (xVal + 11 + ((v - 1) * 38)) y: (yVal + 8) diameter: 28 color: (colors at: v);
			foreground: self backLightGray;
			drawText: text at: (xVal + 21 + ((v - 1)  * 38))@(yVal + 50).].
		
]

{ #category : 'Not categorized' }
MastermindWindow >> coverX: xVal y: yVal [

	"Create the box at the top which covers the answer"

	| text |
	text := Array with: (self TextItem: '?        ?        ?        ?').
	self 
		createRectX: xVal y: yVal width: 160 height: 40 color: (self backLightGray);
		createRectX: (xVal + 2) y: (yVal) width: 156 height: 38 color: (self backGray);
		foreground: self backLightGray;
		drawText: text at: 55@22.
		
]

{ #category : 'Not categorized' }
MastermindWindow >> createCircleX: xVal y: yVal diameter: dia color: colr [

	"Create a filled circle"
	
	| r |
	r := xVal@yVal extent: dia@dia.
	self
		foreground: colr;
		fillCircle: r.
]

{ #category : 'Not categorized' }
MastermindWindow >> createPulldownMenus [

	"Create the pulldown menu"

	| menu |
	menu := (self addPulldownMenu: 'File') subMenuId.
	self addMenuEntryTo: menu label: 'About' selector: #MenuClick:clientData:callData: clientData: 'About'.
	self addMenuEntryTo: menu label: 'Reset' selector: #MenuClick:clientData:callData: clientData: 'Reset'.
	self addSeparatorTo: menu.
	self
		addMenuEntryTo: menu
		buttonClass: CwToggleButton
		label: 'Duplicates'
		selector: #selector:clientData:callData:
		clientData: self.
]

{ #category : 'Not categorized' }
MastermindWindow >> createRectX: xVal y: yVal width: w height: h color: colr [

	"Create a filled rectangle"
	
	| r |
	r := xVal@yVal extent: w@h.
	self
		foreground: colr;
		fillRect: r.
]

{ #category : 'Not categorized' }
MastermindWindow >> createWorkRegion [

	"Create the receiver's workRegion widget hierarchy."

	| form |
	form := CwForm 
		createManagedWidget: 'drawingArea'
		parent: self mainWindow 
		argBlock: nil.
	form manageChild.
	self workRegion: form.
	
	"Creates the drawing area for the game and adds key press"
	drawingArea := CwDrawingArea
		createWidget: 'drawingArea'  "$NON-NLS$"
		parent: form
		argBlock: [:w | w
			width: 240;
			height: 500].
	drawingArea 
		manageChild;
		addEventHandler: KeyPressMask
		receiver: self
		selector: #keyPress:clientData:event:
		clientData: nil.
]

{ #category : 'Not categorized' }
MastermindWindow >> drawable [

	"Checks if the drawing area is ready to be drawn on"

	self isRealized
		ifTrue: [^self drawingArea window]
		ifFalse: [^self screen rootWindow]
]

{ #category : 'Not categorized' }
MastermindWindow >> drawBackground [

	"Draw the background including the piece holes, feedback squares, and numbers"

	| text |
	self 
		createRectX: 0 y: 0 width: 240 height: 500 color: (self backGray);
		coverX: 40 y: 0;
		colorsBoxX: 0 y: 440.
	"Draw peg holes"
	1 to: 10 do: [:r |
		1 to: 4 do: [:p |
			self 
				pieceSquareX: (40 * p) 
				y: (40 * r)].].
	"Draw feeback holes"
	1 to: 10 do: [:r | self feedbackSquareX: 0 y: (40 * r)].
	"Draw row numbers"
	1 to: 10 do: [:d |
		text := Array with: (self TextItem: (d printString)).
		self 
			foreground: self backLightGray;
			drawText: text at: 210@(464 - (d * 40)).].
	
	
	
]

{ #category : 'Not categorized' }
MastermindWindow >> drawBoard [

	"Draws all the guesses and feedback on the background"

	[1 to: (board size) do: [:y |
		1 to: ((board at: y) size) do: [:x |
			(((board at: y) at: x) > 0) ifTrue: [
				self 
					createCircleX: (47 + ((x - 1) * 40) )
					y: (407 - ((y - 1) * 40)) 
					diameter: 26 
					color: (colors at: ((board at: y) at: x)).].].].] 
		forkAt: Processor userBackgroundPriority.
					
	"Draws feedback pegs"
	1 to: (feedBack size) do: [:h |	
		self feedbackBlockX: 0 y: (440 - (40 * h)) values: (feedBack at: h)].
	"Show answer"
	(finished) ifTrue: [
		self 
			showAnswerX: 40 y: 0;
			messageAtEnd: 'You Win'].
]

{ #category : 'Not categorized' }
MastermindWindow >> drawingArea [

	"Answer the drawing area widget."

	^self workRegion
]

{ #category : 'Not categorized' }
MastermindWindow >> drawText: textItems at: aPoint [

	"Draw the text at the given point"

	self drawable
		drawText: self gc
		x: aPoint x
		y: aPoint y
		items: textItems
]

{ #category : 'Not categorized' }
MastermindWindow >> feedbackBlockX: xVal y: yVal values: list [

	"Draws feedback based on the list of exact and inexact"

	((list size) > 0) ifTrue: [
		self createCircleX: (xVal + 6) y: (yVal + 6) diameter: 11 color: (colors at: (6 - (list at: 1)))].
	((list size) > 1) ifTrue: [
		self createCircleX: (xVal + 23) y: (yVal + 6) diameter: 11 color: (colors at: (6 - (list at: 2)))].
	((list size) > 2) ifTrue: [
		self createCircleX: (xVal + 6) y: (yVal + 23) diameter: 11 color: (colors at: (6 - (list at: 3)))].
	((list size) > 3) ifTrue: [
		self createCircleX: (xVal + 23) y: (yVal + 23) diameter: 11 color: (colors at: (6 - (list at: 4)))].
]

{ #category : 'Not categorized' }
MastermindWindow >> feedbackSquareX: xVal y: yVal [

	"Draws the feedback holes"

	self
		createCircleX: (xVal + 4) y: (yVal + 4) diameter: 15 color: (self backLightGray);
		createCircleX: (xVal + 21) y: (yVal + 4) diameter: 15 color: (self backLightGray);
		createCircleX: (xVal + 4) y: (yVal + 21) diameter: 15 color: (self backLightGray);
		createCircleX: (xVal + 21) y: (yVal + 21) diameter: 15 color: (self backLightGray);
		
		createCircleX: (xVal + 7) y: (yVal + 7) diameter: 9 color: (self backDarkGray);
		createCircleX: (xVal + 24) y: (yVal + 7) diameter: 9 color: (self backDarkGray);
		createCircleX: (xVal + 7) y: (yVal + 24) diameter: 9 color: (self backDarkGray);
		createCircleX: (xVal + 24) y: (yVal + 24) diameter: 9 color: (self backDarkGray)
]

{ #category : 'Not categorized' }
MastermindWindow >> fillCircle: r [

	"Fill the circle r."

	self drawable
		fillArc: self gc
		x:  r origin x
		y:  r origin y
		width:  r width
		height: r height
		angle1: 0
		angle2: 360* 64
]

{ #category : 'Not categorized' }
MastermindWindow >> fillRect: r [

	"Fill the rectangle r."

	self drawable
		fillRectangle: self gc
		x: r origin x
		y: r origin y
		width: r width
		height: r height.
]

{ #category : 'Not categorized' }
MastermindWindow >> findFeedback [

	"Find how many exact and inexact matches between guess and answer"

	| guess actual exact inexact feed |
	guess := (board at: (currentSpot y)) copy.
	actual := answer copy.
	exact := 0.
	inexact := 0.
	feed := OrderedCollection new.
	
	"Find exact matches"
	1 to: 4 do: [:u |
		((guess at: (5 - u)) = (actual at: (5 - u))) ifTrue: [
			exact := exact + 1.
			actual remove: (actual at: (5 - u)).
			guess remove: (guess at: (5 - u)).].].
	"Find inexact matches"
	guess do: [:v |
		(actual includes: v) ifTrue: [
			inexact := inexact + 1.
			actual remove: v.].].
	
	"Finish if the guess fully matches answer"
	(exact = 4) ifTrue: [finished := true.].
			
	"Convert feedback into the key pegs"
	[exact > 0] whileTrue: 
		[feed add: 1.
		exact := exact - 1].
	[inexact > 0] whileTrue: 
		[feed add: 0.
		inexact := inexact - 1].
	feedBack add: feed.
		
	
	
]

{ #category : 'Not categorized' }
MastermindWindow >> foreground: anInteger [

	"Set the foreground colour to anInteger."

	self gc
		setForeground: anInteger
]

{ #category : 'Not categorized' }
MastermindWindow >> gc [

	"Answer the CgGC to use for the test."

	^gc
]

{ #category : 'Not categorized' }
MastermindWindow >> green [

	"Color Green - Pegs"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 0 green: 204 blue: 0).
]

{ #category : 'Not categorized' }
MastermindWindow >> initializeGraphics [

	"Initialize any resources required for graphics drawing."

	| palette fg bg |
	palette := CgIndexedPalette colorCube: #(32 32 32).
	self shell window setPalette: palette.
	fg := palette nearestPixelValue: self drawingArea foregroundColor.
	bg := palette nearestPixelValue:  self drawingArea backgroundColor.
	
	gc :=
		self drawingArea window 
			createGC: GCForeground | GCBackground
			values: (CgGCValues new 
							foreground: fg;
							background: bg).
]

{ #category : 'Not categorized' }
MastermindWindow >> initializeVars [

	"Initialize the colors and set duplicates to false while also reseting the board"
		
	colors := OrderedCollection new
		add: (self blue); add: (self red); add: (self yellow); add: (self green); add: (self black); add: (self white);
		yourself.
	duplicates := false.
	self reset.
	
	
	
	
	
			
		
]

{ #category : 'Not categorized' }
MastermindWindow >> isRealized [

	"Answer a Boolean indicating whether the drawing area widget has been realized."

	| widget |
	^(widget := self drawingArea) notNil
		and: [widget isRealized]
]

{ #category : 'Not categorized' }
MastermindWindow >> keyPress: area clientData: clientData event: event [

	"Takes the key input and updates the guesses"

	area hasFocus ifFalse: [^self].
	(finished) ifTrue: [^self].
	"If a numeric key is pressed between 1 and 6 inclusive"
	((49 to: 54) includes: (event keysym)) ifTrue: [
		((currentSpot x) <= 4) ifTrue: [
				(board at: (currentSpot y)) at: (currentSpot x) put: (event keysym - 48).
				currentSpot := (currentSpot x + 1)@(currentSpot y).].].
	"If the backspace key is pressed"
	(event keysym = XKBackSpace) ifTrue: [
		((currentSpot x) > 1) ifTrue: [
			self pieceSquareX: (40 * ((currentSpot x) - 1)) y: (40 * (11 - (currentSpot y))).
			currentSpot := (currentSpot x - 1)@(currentSpot y).
			(board at: (currentSpot y)) at: (currentSpot x) put: 0.].].
	"If the return key is pressed"
	(event keysym = XKReturn) ifTrue: [
		((currentSpot x) > 4) ifTrue: [
			self findFeedback.
			((currentSpot y) < 10)
				ifTrue: [
					currentSpot := 1@(currentSpot y + 1).]
				ifFalse: [
					self 
						showAnswerX: 40 y: 0;
						drawBoard;
						messageAtEnd: 'You Lost'].].].
	"Update board"
	[self drawBoard] forkAt: Processor userBackgroundPriority.
]

{ #category : 'Not categorized' }
MastermindWindow >> mainWindowArgs [

	"Answer an argBlock containing some default width and height settings."

	^[:w | w width: 240; height: 500]
]

{ #category : 'Not categorized' }
MastermindWindow >> MenuClick: aButton clientData: clientData callData: callData [

	"Reset the board or show information"

	(clientData = 'Reset')
		ifTrue: [self reset; drawBackground].
	(clientData = 'About')
		ifTrue: [self aboutShow].
		
]

{ #category : 'Not categorized' }
MastermindWindow >> messageAtEnd: outcome [

	"Creates a pop-up at the end for reseting or quitting"

	(self isRealized)
		ifTrue: [
			(CwMessagePrompter 
				confirm: 'Play again?'
				title: outcome)
					ifTrue: [self reset; drawBackground]
					ifFalse: [self shell destroyWidget].].
]

{ #category : 'Not categorized' }
MastermindWindow >> open [

	"Set all the initial parameters and reset the graphics"

	super open.
	self 
		initializeVars;
		drawBackground.
	
	
	
]

{ #category : 'Not categorized' }
MastermindWindow >> pieceSquareX: xVal y: yVal [

	"Draw one piece hole"

	self 
		createRectX: xVal y: yVal width: 40 height: 40 color: (self backGray);
		createCircleX: xVal y: yVal diameter: 40 color: (self backLightGray);
		createCircleX: (xVal + 2) y: (yVal + 2) diameter: 36 color: (self backGray);
		createCircleX: (xVal + 10) y: (yVal + 10) diameter: 20 color: (self backLightGray);
		createCircleX: (xVal + 12) y: (yVal + 12) diameter: 16 color: (self backDarkGray)
]

{ #category : 'Not categorized' }
MastermindWindow >> red [

	"Color Red - Pegs"
	
	^ shell window getPalette 
		nearestPixelValue: Color red
]

{ #category : 'Not categorized' }
MastermindWindow >> reset [

	"Reset all the variables for a new game"

	| rand |
	"Create empty board"
	board := OrderedCollection new.
	1 to: 10 do: [:w |
		| row |
		row := OrderedCollection new.
		1 to: 4 do: [:x |
			row add: 0].
		board add: row].
		
	currentSpot := 1@1.	
	finished := false.
	rand := EsRandom new.
	answer := OrderedCollection new.
	
	"Create answer based on whether duplicates are allowed"
	(duplicates)
		ifTrue: [
			1 to: 4 do: [:w |
				answer add: (rand nextInt: (colors size))].]
		ifFalse: [
			| allPossible |
			allPossible := OrderedCollection
				with: 1 with: 2 with: 3 with: 4 with: 5 with: 6.
			1 to: 4 do: [:w |
			| r |
			r := (allPossible at: (rand nextInt: (allPossible size))).
			answer add: r.
			allPossible remove: r].].
	feedBack := OrderedCollection new.
	
	Transcript 
		clear;
		show: (answer printString);
		cr.
	
	
	
	
	
			
		
]

{ #category : 'Not categorized' }
MastermindWindow >> selector: widget clientData: clientData callData: callData [

	"Changes the boolean duplicates"

	widget getState
		ifTrue: [duplicates := true]
		ifFalse: [duplicates := false].
	self
		reset;
		drawBackground.
]

{ #category : 'Not categorized' }
MastermindWindow >> shellName [

	"Answer the name of the receiver's shell.
	This is used as the default label of the window."

	^'Mastermind'
]

{ #category : 'Not categorized' }
MastermindWindow >> showAnswerX: xVal y: yVal [

	"Draw the answer pegs at the top"

	1 to: (answer size) do: [:g |
		self 
			createCircleX: (47 + ((g - 1) * 40)) 
			y: 6
			diameter: 26 
			color: (colors at: (answer at: g))].
		
	
	
]

{ #category : 'Not categorized' }
MastermindWindow >> TextItem: aString [

	"Creates a text item based on the given string"

	^CgTextItem new
		chars: aString;
		delta: 0;
		font: 0
]

{ #category : 'Not categorized' }
MastermindWindow >> white [

	"Color White - Pegs"
	
	^ shell window getPalette 
		nearestPixelValue: Color white
]

{ #category : 'Not categorized' }
MastermindWindow >> yellow [

	"Color Yellow - Pegs"
	
	^ shell window getPalette 
		nearestPixelValue: Color yellow
]
