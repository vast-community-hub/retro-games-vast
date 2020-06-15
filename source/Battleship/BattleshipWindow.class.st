Class {
	#name : 'BattleshipWindow',
	#superclass : 'WidgetApplication',
	#instVars : [
		'gc',
		'drawingArea',
		'board',
		'opponentBoard',
		'clickGrid',
		'checked',
		'opponentChecked',
		'checkPoints',
		'selectable'
	],
	#category : 'Battleship'
}

{ #category : 'Not categorized' }
BattleshipWindow >> addOpponentShips [

	| rand shipSizes finding count|
	rand := EsRandom new.
	shipSizes := #(5 4 3 3 2).
	finding := true.
	count := 1.
	
	shipSizes do: [:size |
		((rand nextInt: 2) = 1)
			ifTrue: [
				| ranX ranY |
				[finding = true]
					whileTrue: [
						ranX := rand nextInt: (10 - size).
						ranY := rand nextInt: 10.
						(self checkFreeSquaresX: ranX y: ranY len: size horizontal: true grid: opponentBoard)
							ifTrue: [
								1 to: size do: [:w |
									(opponentBoard at: ranY) at: (ranX + (w - 1)) put: count].
								finding := false].].]
			ifFalse: [
				| ranX ranY |
				[finding = true]
					whileTrue: [
						ranX := rand nextInt: 10.
						ranY := rand nextInt: (10 - size).
						(self checkFreeSquaresX: ranX y: ranY len: size horizontal: false grid: opponentBoard)
							ifTrue: [
								1 to: size do: [:w |
									(opponentBoard at: (ranY + (w - 1))) at: ranX put: count].
								finding := false].].].
			finding := true.
			count := count + 1].
	
]

{ #category : 'Not categorized' }
BattleshipWindow >> addShips [

	| rand shipSizes finding count|
	rand := EsRandom new.
	shipSizes := #(5 4 3 3 2).
	finding := true.
	count := 1.
	
	shipSizes do: [:size |
		((rand nextInt: 2) = 1)
			ifTrue: [
				| ranX ranY |
				[finding = true]
					whileTrue: [
						ranX := rand nextInt: (10 - size).
						ranY := rand nextInt: 10.
						(self checkFreeSquaresX: ranX y: ranY len: size horizontal: true grid: board)
							ifTrue: [
								1 to: size do: [:w |
									(board at: ranY) at: (ranX + (w - 1)) put: count].
								self drawLargeShipHorizontalX: ranX y: ranY size: size.
								finding := false].].]
			ifFalse: [
				| ranX ranY |
				[finding = true]
					whileTrue: [
						ranX := rand nextInt: 10.
						ranY := rand nextInt: (10 - size).
						(self checkFreeSquaresX: ranX y: ranY len: size horizontal: false grid: board)
							ifTrue: [
								1 to: size do: [:w |
									(board at: (ranY + (w - 1))) at: ranX put: count].
								self drawLargeShipVerticalX: ranX y: ranY size: size.
								finding := false].].].
			finding := true.
			count := count + 1.].
	
]

{ #category : 'Not categorized' }
BattleshipWindow >> addSurroundingCurrent: current [

	((current) x > 1)
		ifTrue: [checkPoints add: ((current x) - 1)@(current y)].
		
	((current) x < 10)
		ifTrue: [checkPoints add: ((current x) + 1)@(current y)].
		
	((current y) >1)
		ifTrue: [checkPoints add: (current x)@((current y) - 1)].
		
	((current y) <10)
		ifTrue: [checkPoints add: (current x)@((current y) + 1)].
]

{ #category : 'Not categorized' }
BattleshipWindow >> background: anInteger [

	"Set the background colour to anInteger."

	self gc
		setBackground: anInteger
]

{ #category : 'Not categorized' }
BattleshipWindow >> black [

	"Color Black"
	
	^ shell window getPalette 
		nearestPixelValue: (Color black)
]

{ #category : 'Not categorized' }
BattleshipWindow >> blue1 [

	"Color Darkened Blue"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 51 green: 153 blue: 255).
]

{ #category : 'Not categorized' }
BattleshipWindow >> blue2 [

	"Color Darkened Blue"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 102 green: 204 blue: 255).
]

{ #category : 'Not categorized' }
BattleshipWindow >> checkFreeSquaresX: xVal y: yVal len: length horizontal: direction grid: grid [

	direction
		ifTrue: [
			1 to: length do: [:s |
				(((grid at: yVal) at: (xVal + (s - 1))) = 0)
					ifFalse: [^false]].
			^true]
		ifFalse: [
			1 to: length do: [:s |
				(((grid at: (yVal + (s - 1))) at: xVal) = 0)
					ifFalse: [^false]].
			^true]
	
]

{ #category : 'Not categorized' }
BattleshipWindow >> createCircleX: xVal y: yVal diameter: dia color: colr [

	"Create a filled circle"
	
	| r |
	r := xVal@yVal extent: dia@dia.
	self
		foreground: colr;
		fillCircle: r.
]

{ #category : 'Not categorized' }
BattleshipWindow >> createRectX: xVal y: yVal width: w height: h color: colr [

	"Create a filled rectangle"
	
	| r |
	r := xVal@yVal extent: w@h.
	self
		foreground: colr;
		fillRect: r.
]

{ #category : 'Not categorized' }
BattleshipWindow >> createWorkRegion [

	"Create the receiver's workRegion widget hierarchy."

	| form |
	form := CwForm 
		createManagedWidget: 'drawingArea'
		parent: self mainWindow 
		argBlock: nil.
	form manageChild.
	self workRegion: form.
	
	"Creates the drawing area for the game"
	drawingArea := CwDrawingArea
		createWidget: 'drawingArea'  "$NON-NLS$"
		parent: form
		argBlock: [:w | w
			width: 762;
			height: 368].
	drawingArea
		manageChild;
		addCallback: XmNinputCallback
		receiver: self
		selector: #input:clientData:callData:
		clientData: nil
		
]

{ #category : 'Not categorized' }
BattleshipWindow >> darkGray [

	"Color Black"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 51 green: 51 blue: 51)
]

{ #category : 'Not categorized' }
BattleshipWindow >> dotsColor [

	"Color Black"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 51 green: 51 blue: 51)
]

{ #category : 'Not categorized' }
BattleshipWindow >> drawable [

	"Checks if the drawing area is ready to be drawn on"

	self isRealized
		ifTrue: [^self drawingArea window]
		ifFalse: [^self screen rootWindow]
]

{ #category : 'Not categorized' }
BattleshipWindow >> drawBackgroundX: xVal y: yVal [

	| letters |
	letters := #('A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J').
	self createRectX: xVal y: yVal width: 376 height: 368 color: (self darkGray).

	1 to: 10 do: [:x |
		1 to: 10 do: [:y |
			self drawCellX: (32 * (x - 1) + 28 + xVal) y: (32 * (y - 1) + 48 + yVal)].].
			
	1 to: 10 do: [:d |
		| text |
		text := Array with: (self TextItem: (d printString)).
				self foreground: self white.
			(d < 10) 
				ifTrue: [self drawText: text at: (10 + xVal)@(32 * (d - 1) + 65 + yVal)]
				ifFalse: [self drawText: text at: (6 + xVal)@(32 * (d - 1) + 65 + yVal)]].
	
	1 to: 10 do: [:d |
		| text |
		text := Array with: (self TextItem: (letters at: d)).
		self 
			foreground: self white;
			drawText: text at: (32 * (d - 1) + 38 + xVal)@(40 + yVal)].
]

{ #category : 'Not categorized' }
BattleshipWindow >> drawCellX: xVal y: yVal [

	self
		createRectX: xVal y: yVal width: 30 height: 30 color: (self blue1);
		createCircleX: (xVal + 10) y: (yVal + 10) diameter: 10 color: (self blue2).
]

{ #category : 'Not categorized' }
BattleshipWindow >> drawFullBackground [

	| text1 text2 |
	text1 := Array with: (self TextItem: ('FLEET')).
	text2 := Array with: (self TextItem: ('TARGETING')).

	self 
		drawBackgroundX: 0 y: 0;
		createRectX: 376 y: 0 width: 10 height: 348 color: (self white);
		drawBackgroundX: 386 y: 0;
		foreground: self white;
		drawText: text1 at: 165@18;
		drawText: text2 at: 535@18
]

{ #category : 'Not categorized' }
BattleshipWindow >> drawingArea [

	"Answer the drawing area widget."

	^self workRegion
]

{ #category : 'Not categorized' }
BattleshipWindow >> drawLargeShipHorizontalX: xVal y: yVal size: size [

	| xPos yPos |
	xPos := (xVal * 32) - 4.
	yPos := (yVal * 32) + 16.
	
	self
		createCircleX: (xPos + 5) y: (yPos + 5) diameter: 20 color: (self shipGray2);
		createCircleX: (xPos + (32 * (size - 1) + 5)) y: (yPos + 5) diameter: 20 color: (self shipGray2);
		createRectX: (xPos + 15) y: (yPos + 5) width: (32 * (size - 1)) height: 20 color: (self shipGray2);
		
		createCircleX: (xPos + 7) y: (yPos + 7) diameter: 16 color: (self shipGray1);
		createCircleX: (xPos + (32 * (size - 1) + 7)) y: (yPos + 7) diameter: 16 color: (self shipGray1);
		createRectX: (xPos + 17) y: (yPos + 7) width: (31 * (size - 1)) height: 16 color: (self shipGray1).
		
		1 to: size do: [:w |
			self createCircleX: (xPos + (32 * (w - 1)) + 10) y: (yPos + 10) diameter: 10 color: (self shipGray3)].

	
]

{ #category : 'Not categorized' }
BattleshipWindow >> drawLargeShipVerticalX: xVal y: yVal size: size [

	| xPos yPos |
	xPos := (xVal * 32) - 4.
	yPos := (yVal * 32) + 16.

	self
		createCircleX: (xPos + 5) y: (yPos + 5) diameter: 20 color: (self shipGray2);
		createCircleX: (xPos + 5) y: (yPos + (32 * (size - 1) + 5)) diameter: 20 color: (self shipGray2);
		createRectX: (xPos + 5) y: (yPos + 15) width: 20 height: (32 * (size - 1)) color: (self shipGray2);
		
		createCircleX: (xPos + 7) y: (yPos + 7) diameter: 16 color: (self shipGray1);
		createCircleX: (xPos + 7) y: (yPos + (32 * (size - 1) + 7)) diameter: 16 color: (self shipGray1);
		createRectX: (xPos + 7) y: (yPos + 17) width: 16 height: (31 * (size - 1)) color: (self shipGray1).

		1 to: size do: [:w |
			self createCircleX: (xPos + 10) y: (yPos + (32 * (w - 1)) + 10) diameter: 10 color: (self shipGray3)].
	
]

{ #category : 'Not categorized' }
BattleshipWindow >> drawText: textItems at: aPoint [

	"Draw the text at the given point"

	self drawable
		drawText: self gc
		x: aPoint x
		y: aPoint y
		items: textItems
]

{ #category : 'Not categorized' }
BattleshipWindow >> fillCircle: r [

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
BattleshipWindow >> fillRect: r [

	"Fill the rectangle r."

	self drawable
		fillRectangle: self gc
		x: r origin x
		y: r origin y
		width: r width
		height: r height.
]

{ #category : 'Not categorized' }
BattleshipWindow >> foreground: anInteger [

	"Set the foreground colour to anInteger."

	self gc
		setForeground: anInteger
]

{ #category : 'Not categorized' }
BattleshipWindow >> gc [

	"Answer the CgGC to use for the test."

	^gc
]

{ #category : 'Not categorized' }
BattleshipWindow >> initializeGraphics [

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
BattleshipWindow >> initializeVars [

	board := OrderedCollection new.
	1 to: 10 do: [:a |
		| row |
		row := OrderedCollection new.
		1 to: 10 do: [:b | row add: 0].
		board add: row.].
		
	opponentBoard := OrderedCollection new.
	1 to: 10 do: [:a |
		| row |
		row := OrderedCollection new.
		1 to: 10 do: [:b | row add: 0].
		opponentBoard add: row.].
		
	checked := OrderedCollection new.
	1 to: 10 do: [:a |
		| row |
		row := OrderedCollection new.
		1 to: 10 do: [:b | row add: false].
		checked add: row.].
		
	opponentChecked := OrderedCollection new.
	1 to: 10 do: [:a |
		| row |
		row := OrderedCollection new.
		1 to: 10 do: [:b | row add: false].
		opponentChecked add: row.].
		
	selectable := true.
	checkPoints := OrderedCollection new.
]

{ #category : 'Not categorized' }
BattleshipWindow >> input: aDrawingArea clientData: clientData callData: callData [

	| event point |
	event := callData event.
	
	(event type = ButtonPress and: [event button = Button1])
		ifTrue: [
			point := self squarePressedX: (event x) y: (event y).
			(((point x = -1 or: [point y = -1]) 
				or: [((checked at: (point y)) at: (point x)) = true])
					or: [selectable = false])
				ifFalse: [
					(((opponentBoard at: (point y)) at: (point x)) ~= 0)
						ifTrue: [
							self 
								createCircleX: (423 + (32 * (point x - 1))) 
								y: (57 + (32 * (point y - 1))) 
								diameter: 12 
								color: (self red).]
						ifFalse: [
							self 
								createCircleX: (423 + (32 * (point x - 1))) 
								y: (57 + (32 * (point y - 1))) 
								diameter: 12 
								color: (self white).].
						(checked at: (point y)) at: (point x) put: true.
						selectable := false.
						self opponentTurn].].
]

{ #category : 'Not categorized' }
BattleshipWindow >> isRealized [

	"Answer a Boolean indicating whether the drawing area widget has been realized."

	| widget |
	^(widget := self drawingArea) notNil
		and: [widget isRealized]
]

{ #category : 'Not categorized' }
BattleshipWindow >> mainWindowArgs [

	"Answer an argBlock containing some default width and height settings."

	^[:w | w width: 762; height: 368]
]

{ #category : 'Not categorized' }
BattleshipWindow >> mouseEvent: dwFlags dx: dx dy: dy cButtons: cButtons dwExtraInfo: dwExtraInfo [

	self createCircleX: dx y: dy diameter: 10 color: (self darkGray).
]

{ #category : 'Not categorized' }
BattleshipWindow >> open [

	"Set all the initial parameters and reset the graphics"
	
	super open.
	
	self
		initializeVars;
		drawFullBackground;
		addShips;
		addOpponentShips.
	
	"self printGrid: opponentBoard"
]

{ #category : 'Not categorized' }
BattleshipWindow >> opponentTurn [

	| picking pickX pickY rand delayVar|
	
	rand := EsRandom new.
	picking := true.
	delayVar := Delay new.
	delayVar delayTime: 1000.
	
	delayVar wait.
	selectable := true.
			[(picking = true)]
				whileTrue: [
					pickX := rand nextInt: 10.
					pickY := rand nextInt: 10.
					(((opponentChecked at: pickY) at: pickX) = false)
						ifTrue: [
							(((board at: pickY) at: pickX) ~= 0)
								ifTrue: [
									self
										createCircleX: (37 + (32 * (pickX - 1))) 
										y: (57 + (32 * (pickY - 1))) 
										diameter: 12 
										color: (self red).
										self addSurroundingCurrent: (pickX@pickY)] 
								ifFalse: [
									self
										createCircleX: (37 + (32 * (pickX - 1))) 
										y: (57 + (32 * (pickY - 1))) 
										diameter: 12 
										color: (self white)].
							(opponentChecked at: pickY) at: pickX put: true.
							picking := false].].
		
]

{ #category : 'Not categorized' }
BattleshipWindow >> printGrid: grid [

	Transcript clear.
	grid do: [:row |
		row do: [:i | Transcript show: ((i printString), '  ')].
		Transcript cr.].
]

{ #category : 'Not categorized' }
BattleshipWindow >> red [

	"Color Darkened Blue"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red)
]

{ #category : 'Not categorized' }
BattleshipWindow >> shellName [

	"Answer the name of the receiver's shell.
	This is used as the default label of the window."

	^'BATTLESHIP'
]

{ #category : 'Not categorized' }
BattleshipWindow >> shipGray1 [

	"Color Black"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 225 green: 225 blue: 225)
]

{ #category : 'Not categorized' }
BattleshipWindow >> shipGray2 [

	"Color Black"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 184 green: 184 blue: 184)
]

{ #category : 'Not categorized' }
BattleshipWindow >> shipGray3 [

	"Color Black"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 153 green: 153 blue: 153)
]

{ #category : 'Not categorized' }
BattleshipWindow >> squarePressedX: xVal y: yVal [
	
	| blockX blockY |
	
	blockX := -1.
	blockY := -1.
	
	1 to: 10 do: [:p |
		| boX |
		boX := (414 + (32 * (p -1))).
		(xVal > boX and: [xVal < (boX + 30)])
			ifTrue: [blockX := p].].
			
	1 to: 10 do: [:p |
		| boY |
		boY := (48 + (32 * (p -1))).
		(yVal > boY and: [yVal < (boY + 30)])
			ifTrue: [blockY := p].].

	^blockX@blockY
]

{ #category : 'Not categorized' }
BattleshipWindow >> TextItem: aString [

	"Creates a text item based on the given string"

	^CgTextItem new
		chars: aString;
		delta: 0;
		font: 0
]

{ #category : 'Not categorized' }
BattleshipWindow >> white [

	"Color Darkened Blue"
	
	^ shell window getPalette 
		nearestPixelValue: (Color white)
]
