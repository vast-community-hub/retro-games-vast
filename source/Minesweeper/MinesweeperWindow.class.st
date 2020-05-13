Class {
	#name : 'MinesweeperWindow',
	#superclass : 'WidgetApplication',
	#instVars : [
		'gc',
		'drawingArea',
		'gridWidth',
		'gridHeight',
		'board',
		'mines',
		'colors',
		'clicked',
		'triggered',
		'minesLeft',
		'time',
		'running',
		'counting',
		'menuButtons'
	],
	#pools : [
		'CgConstants'
	],
	#category : 'Minesweeper'
}

{ #category : 'Not categorized' }
MinesweeperWindow >> addMines [

	"Adds all mines to the board"

	| rand posX posY finding |
	
	rand := EsRandom new.
		
	1 to: mines do: [:s |
		finding := true.
		[finding]
			whileTrue: [
				posX := rand nextInt: gridWidth.
				posY := rand nextInt: gridHeight.
				(((board at: posY) at: posX) = 0)
					ifTrue: [
						(board at: posY) at: posX put: 9.
						finding := false]]].
		
		

	
]

{ #category : 'Not categorized' }
MinesweeperWindow >> aqua [

	"Color Aqua"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 2 green: 127 blue: 130)
]

{ #category : 'Not categorized' }
MinesweeperWindow >> background: anInteger [

	"Set the background colour to anInteger."

	self gc
		setBackground: anInteger
]

{ #category : 'Not categorized' }
MinesweeperWindow >> black [

	"Color Black"
	
	^ shell window getPalette 
		nearestPixelValue: Color black
]

{ #category : 'Not categorized' }
MinesweeperWindow >> blue [

	"Color Blue"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 0 green: 0 blue: 251)
]

{ #category : 'Not categorized' }
MinesweeperWindow >> cellBorderGray [

	"Color Gray - For cell borders and dark shade"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 123 green: 123 blue: 123).
]

{ #category : 'Not categorized' }
MinesweeperWindow >> cellGray [

	"Color Gray - For cells, covers, and the background"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 189 green: 189 blue: 189).
]

{ #category : 'Not categorized' }
MinesweeperWindow >> checkCompleteness [

	"Checks if all but the mines are uncovered"

	| done |

	done := true.
	1 to: (board size) do: [:w |
		1 to: ((board at: w) size) do: [:v |
			((((board at: w) at: v) < 9) and: [((clicked at: w) at: v) ~= 2])
				ifTrue: [done := false]]].
				
	(done)
		ifTrue: [
			1 to: (board size) do: [:w |
				1 to: ((board at: w) size) do: [:v |
					(((board at: w) at: v) = 9) 
						ifTrue: [
							(clicked at: w) at: v put: 1.
							minesLeft := minesLeft - 1]]].
			self 
				drawBoard;
				drawCornerNumbers;
				drawFaceX: (((gridWidth * 20) / 2) - 7) y: 10 num: 4.
			counting := false].
			
]

{ #category : 'Not categorized' }
MinesweeperWindow >> clear [
	
	"Clears the drawing area"

	self createRectX: 0 y: 0 width: (shell width) height: (shell height) color: (self cellGray)
]

{ #category : 'Not categorized' }
MinesweeperWindow >> createCircleX: xVal y: yVal diameter: dia color: colr [

	"Create a filled circle"
	
	| r |
	r := xVal@yVal extent: dia@dia.
	self
		foreground: colr;
		fillCircle: r 
]

{ #category : 'Not categorized' }
MinesweeperWindow >> createFlagX: xVal y: yVal [

	"Create the flag graphic at the specified location"

	| flagPolePoints flagPoints |
	
	"Points to make the flag pole"
	flagPolePoints := OrderedCollection new.
	flagPolePoints 
		add: (xVal + 4)@(yVal + 16);
		add: (xVal + 4)@(yVal + 14);
		add: (xVal + 10)@(yVal + 12);
		add: (xVal + 10)@(yVal + 10);
		add: (xVal + 12)@(yVal + 10);
		add: (xVal + 12)@(yVal + 12);
		add: (xVal + 16)@(yVal + 14);
		add: (xVal + 16)@(yVal + 16).
		
	"Points to make the flag"
	flagPoints := OrderedCollection new.
	flagPoints
		add: (xVal + 10)@(yVal + 4);
		add: (xVal + 12)@(yVal + 4);
		add: (xVal + 12)@(yVal + 10);
		add: (xVal + 10)@(yVal + 10);
		add: (xVal + 5)@(yVal + 7).
	
	self
		foreground: (self black);
		fillPolygon: flagPolePoints;
		foreground: (self red);
		fillPolygon: flagPoints
]

{ #category : 'Not categorized' }
MinesweeperWindow >> createPulldownMenus [

	"Create the pulldown menus"

	| list menu1 menu2 button |
	
	list := OrderedCollection with: 'Beginner' with: 'Intermediate' with: 'Expert'.
	
	menu1 := (self addPulldownMenu: 'Game') subMenuId.
	menuButtons := OrderedCollection new.
	list do: [:item |
		button :=
			self 
				addMenuEntryTo: menu1
				buttonClass: CwToggleButton 
				label: item 
				selector: #MenuClick:clientData:callData: 
				clientData: item.
		(item = 'Beginner')
			ifTrue: [button setState: true notify: false].
		menuButtons add: button].
		
	menu2 := (self addPulldownMenu: 'Help') subMenuId.
	self addMenuEntryTo: menu2 label: 'Help' selector: #HelpClick:clientData:callData: clientData: 'Help'.
]

{ #category : 'Not categorized' }
MinesweeperWindow >> createRectX: xVal y: yVal width: w height: h color: colr [

	"Create a filled rectangle"
	
	| r |
	r := xVal@yVal extent: w@h.
	self
		foreground: colr;
		fillRect: r.
]

{ #category : 'Not categorized' }
MinesweeperWindow >> createWorkRegion [

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
			width: 1000;
			height: 1000].
	drawingArea
		manageChild;
		addCallback: XmNinputCallback
		receiver: self
		selector: #input:clientData:callData:
		clientData: nil

	
]

{ #category : 'Not categorized' }
MinesweeperWindow >> darkBlue [

	"Color Dark Blue"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 1 green: 0 blue: 128)
]

{ #category : 'Not categorized' }
MinesweeperWindow >> darkRed [

	"Color Dark Red"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 131 green: 1 blue: 1)
]

{ #category : 'Not categorized' }
MinesweeperWindow >> drawable [

	"Checks if the drawing area is ready to be drawn on"

	self isRealized
		ifTrue: [^self drawingArea window]
		ifFalse: [^self screen rootWindow]
]

{ #category : 'Not categorized' }
MinesweeperWindow >> drawArc: r ang1: angle1 ang2: angle2 [

	"Draw an arc based on the two angles"

	self drawable
		drawArc: self gc
		x:  r origin x
		y:  r origin y
		width:  r width
		height: r height
		angle1: angle1
		angle2: angle2
]

{ #category : 'Not categorized' }
MinesweeperWindow >> drawBoard [

	"Draw the board"
	
	| colr xVal yVal |
	
	xVal := 8.
	yVal := 53.
	
	"Draws all the borders and the numbers"
	self 
		drawTopBorder;
		drawBottomBorder;
		drawCornerNumbers.
		
	"Draws the face at the top"
	(counting)
		ifTrue: [self drawFaceX: (((gridWidth * 20) / 2) - 7) y: 10 num: 1] 
		ifFalse: [self drawFaceX: (((gridWidth * 20) / 2) - 7) y: 10 num: 2].	
	
	"Draws all the cells and covers"
	1 to: (board size) do: [:h |
		1 to: ((board at: h) size) do: [:w |
			((h = (triggered y)) and: [w = (triggered x)])
				ifTrue: [colr := self red]
				ifFalse: [colr := self cellGray].		
			(((clicked at: h) at: w) = 0)
				ifTrue: [self drawCoverX: (xVal + ((w - 1) * 20)) y: (yVal + ((h - 1) * 20)) flag: false].
			(((clicked at: h) at: w) = 1)
				ifTrue: [self drawCoverX: (xVal + ((w - 1) * 20)) y: (yVal + ((h - 1) * 20)) flag: true].
			(((clicked at: h) at: w) = 2)
				ifTrue: [self drawCellX: (xVal + ((w - 1) * 20)) y: (yVal + ((h - 1) * 20)) value: ((board at: h) at: w) color: colr]]].
]

{ #category : 'Not categorized' }
MinesweeperWindow >> drawBottomBorder [

	"Draw border around all the cells"

	| topLeftPart bottomRightPart |
	
	topLeftPart := OrderedCollection 
		with: 5@50 with: ((gridWidth * 20) + 11)@50 with: ((gridWidth * 20) + 8)@53 with: 8@53 
		with: 8@((gridHeight * 20) + 53) with: 5@((gridHeight * 20) + 56).
	bottomRightPart := OrderedCollection
		with: 5@((gridHeight * 20) + 56) with: 8@((gridHeight * 20) + 53) 
		with: ((gridWidth * 20) + 8)@((gridHeight * 20) + 53)
		with: ((gridWidth * 20) + 8)@53 with: ((gridWidth * 20) + 11)@50
		with: ((gridWidth * 20) + 11)@((gridHeight * 20) + 56).
		
	self
		foreground: (self cellBorderGray);
		fillPolygon: topLeftPart;
		foreground: (self white);
		fillPolygon: bottomRightPart
]

{ #category : 'Not categorized' }
MinesweeperWindow >> drawCellX: xVal y: yVal value: num color: colr [

	"Draw a cell of the grid"

	self createRectX: xVal y: yVal width: 20 height: 20 color: (self cellBorderGray).
	self createRectX: (xVal + 1) y: (yVal + 1) width: 18 height: 18 color: colr.
		
	"Add the text if a number or a mine if not"
	((1 to: 8) includes: num)
		ifTrue: [
			| text |
			text := Array with: (self TextItem: (num printString)).
			self 
				foreground: (colors at: num);
				drawText: text at: (xVal + 6)@(yVal + 14)].
	(num = 9)
		ifTrue: [self drawMineX: xVal y: yVal].
]

{ #category : 'Not categorized' }
MinesweeperWindow >> drawCornerNumbers [

	"Draws the mines left and time in the top corners"

	| minesHold timeHold m1 m2 m3 t1 t2 t3 |
	
	(minesLeft >= 0)
		ifTrue: [minesHold := minesLeft]
		ifFalse: [minesHold := 0].
	m1 := (minesHold / 100) floor.
	minesHold := minesHold - (m1 * 100).
	m2 := (minesHold / 10) floor.
	minesHold := minesHold - (m2 * 10).
	m3 := minesHold.
	
	(time <= 999)
		ifTrue: [timeHold := time] 
		ifFalse: [timeHold := 999].
	t1 := (timeHold / 100) floor.
	timeHold := timeHold - (t1 * 100).
	t2 := (timeHold / 10) floor.
	timeHold := timeHold - (t2 * 10).
	t3 := timeHold.
	
	"Draw all the numbers"
	self
		drawNumberBlockX: 10 y: 10 num: m1;
		drawNumberBlockX: 25 y: 10 num: m2;
		drawNumberBlockX: 40 y: 10 num: m3;
		drawNumberBlockX: (((gridWidth * 20) + 16) - 55) y: 10 num: t1;
		drawNumberBlockX: (((gridWidth * 20) + 16) - 40)  y: 10 num: t2;
		drawNumberBlockX: (((gridWidth * 20) + 16) - 25)  y: 10 num: t3
		
	
	
		
]

{ #category : 'Not categorized' }
MinesweeperWindow >> drawCoverX: xVal y: yVal flag: flag [

	"Draws a cell cover"
	
	| triangle |
	
	triangle := OrderedCollection 
		with: (xVal)@(yVal + 20) with: (xVal + 20)@(yVal) with: (xVal + 20)@(yVal + 20).
			
	self 
		createRectX: xVal y: yVal width: 20 height: 20 color: (self white);
		foreground: (self cellBorderGray);
		fillPolygon: triangle;
		createRectX: (xVal + 2) y: (yVal + 2) width: 16 height: 16 color: (self cellGray).
		
	"Draws flag on the cover"
	(flag)
		ifTrue: [self createFlagX: xVal y: yVal].
]

{ #category : 'Not categorized' }
MinesweeperWindow >> drawFaceX: xVal y: yVal num: num [

	"Draws the face at the top which changes with user input"

	| triangle r |
	
	triangle := OrderedCollection 
		with: (xVal)@(yVal + 30) with: (xVal + 30)@(yVal) with: (xVal + 30)@(yVal + 30).
			
	"Draws background and head"
	self 
		createRectX: xVal y: yVal width: 30 height: 30 color: (self white);
		foreground: (self cellBorderGray);
		fillPolygon: triangle;
		createRectX: (xVal + 3) y: (yVal + 3) width: 24 height: 24 color: (self cellGray);
		createCircleX: (xVal + 5) y: (yVal + 5) diameter: 20 color: (self black);
		createCircleX: (xVal + 6) y: (yVal + 6) diameter: 18 color: (self yellow).
	"Draws the face's eyes"	
	(num = 2)
		ifTrue: [
			self
				foreground: (self black);
				drawLineStartPoint: (xVal + 10)@(yVal + 10) EndPoint: (xVal + 13)@(yVal + 13);
				drawLineStartPoint: (xVal + 10)@(yVal + 13) EndPoint: (xVal + 13)@(yVal + 10);
				drawLineStartPoint: (xVal + 16)@(yVal + 10) EndPoint: (xVal + 19)@(yVal + 13);
				drawLineStartPoint: (xVal + 16)@(yVal + 13) EndPoint: (xVal + 19)@(yVal + 10)]
		ifFalse: [
			self
				createCircleX: (xVal + 10) y: (yVal + 10) diameter: 4 color: (self black);
				createCircleX: (xVal + 16) y: (yVal + 10) diameter: 4 color: (self black)].
		
	"Smiley Face - Adds smile"
	(num = 1) ifTrue: [
		r := (xVal + 8)@(yVal + 5) extent: 14@14.
		self drawArc: r ang1: -140*60 ang2: 90*60].
	"Frowny Face - Adds frown"
	(num = 2) ifTrue: [
		r := (xVal + 9)@(yVal + 17) extent: 12@12.
		self drawArc: r ang1: 45*60 ang2: 100*60].
	"Oh Face - Adds circular mouth"
	(num = 3) ifTrue: [
		self 
			createCircleX: (xVal + 12) y: (yVal + 15) diameter: 6 color: (self black);
			createCircleX: (xVal + 13) y: (yVal + 16) diameter: 4 color: (self cellGray)].
	"Chill Face - Adds Sunglasses and a large smile"
	(num = 4) ifTrue: [
		| a b c d e |
		a := (xVal + 7)@(yVal + 9) extent: 8@6.
		b := (xVal + 15)@(yVal + 9) extent: 8@6.
		c := (xVal + 13)@(yVal + 10) extent: 4@2.
		d := OrderedCollection 
			with: (xVal + 9)@(yVal + 16) with: (xVal + 21)@(yVal + 16) with: (xVal + 19)@(yVal + 19)
			with: (xVal + 15)@(yVal + 21) with: (xVal + 11)@(yVal + 19).
		e := OrderedCollection 
			with: (xVal + 11)@(yVal + 17) with: (xVal + 20)@(yVal + 17) with: (xVal + 18)@(yVal + 18)
			with: (xVal + 15)@(yVal + 20) with: (xVal + 12)@(yVal + 18).
		self
			foreground: (self black);
			fillCircle: a;
			fillCircle: b;
			fillRect: c;
			fillPolygon: d;
			foreground: (self white);
			fillPolygon: e]
	
		
]

{ #category : 'Not categorized' }
MinesweeperWindow >> drawingArea [

	"Answer the drawing area widget."

	^self workRegion
]

{ #category : 'Not categorized' }
MinesweeperWindow >> drawLineStartPoint: startPoint EndPoint: endPoint [
	
	"Draws a line"

	self drawable
		drawLine: self gc
		x1: startPoint x
		y1: startPoint y
		x2: endPoint x
		y2: endPoint y
]

{ #category : 'Not categorized' }
MinesweeperWindow >> drawMineX: xVal y: yVal [

	"Draws a mine"

	self 
		foreground: (self black);
		drawLineStartPoint: (xVal + 5)@(yVal + 5) EndPoint: (xVal + 14)@(yVal + 14);
		drawLineStartPoint: (xVal + 14)@(yVal + 5) EndPoint: (xVal + 5)@(yVal + 14);
		drawLineStartPoint: (xVal + 9)@(yVal + 4) EndPoint: (xVal + 9)@(yVal + 15);
		drawLineStartPoint: (xVal + 4)@(yVal + 10) EndPoint: (xVal + 15)@(yVal + 9);
		createCircleX: (xVal + 5) y: (yVal + 5) diameter: 10 color: (self black);
		createCircleX: (xVal + 8) y: (yVal + 8) diameter: 3 color: (self white)
]

{ #category : 'Not categorized' }
MinesweeperWindow >> drawNumberBlockX: xVal y: yVal num: num [

	"Draws the given number in the block form"

	| top topLeft topRight middle bottomLeft bottomRight bottom |
	
	top := OrderedCollection with: (xVal + 2)@(yVal + 2) with: (xVal + 13)@(yVal + 2) with: (xVal + 11)@(yVal + 4) 
		with: (xVal + 4)@(yVal + 4).
	topLeft := OrderedCollection with: (xVal + 1)@(yVal + 3) with: (xVal + 3)@(yVal + 5) with: (xVal + 3)@(yVal + 12) 
		with: (xVal + 1)@(yVal + 14).
	topRight := OrderedCollection with: (xVal + 14)@(yVal + 3) with: (xVal + 12)@(yVal + 5) with: (xVal + 12)@(yVal + 12) 
		with: (xVal + 14)@(yVal + 14).
	middle := OrderedCollection with: (xVal + 4)@(yVal + 14) with: (xVal + 11)@(yVal + 14) with: (xVal + 13)@(yVal + 15) 
		with: (xVal + 11)@(yVal + 17) with: (xVal + 4)@(yVal + 17) with: (xVal + 2)@(yVal + 15).
	bottomLeft := OrderedCollection with: (xVal + 1)@(yVal + 16) with: (xVal + 3)@(yVal + 18) with: (xVal + 3)@(yVal + 25) 
		with: (xVal + 1)@(yVal + 27).
	bottomRight := OrderedCollection with: (xVal + 14)@(yVal + 16) with: (xVal + 12)@(yVal + 18) with: (xVal + 12)@(yVal + 25) 
		with: (xVal + 14)@(yVal + 27).
	bottom := OrderedCollection with: (xVal + 4)@(yVal + 26) with: (xVal + 11)@(yVal + 26) with: (xVal + 13)@(yVal + 28) 
		with: (xVal + 2)@(yVal + 28).
	
	self 
		createRectX: xVal y: yVal width: 15 height: 30 color: (self black);
		foreground: (self red).
	
	(#(0 2 3 5 6 7 8 9) includes: num) ifTrue: [self fillPolygon: top].
	(#(0 4 5 6 8 9) includes: num) ifTrue: [self fillPolygon: topLeft].
	(#(0 1 2 3 4 7 8 9) includes: num) ifTrue: [self fillPolygon: topRight].
	(#(2 3 4 5 6 8 9) includes: num) ifTrue: [self fillPolygon: middle].
	(#(0 2 6 8) includes: num) ifTrue: [self fillPolygon: bottomLeft].
	(#(0 1 3 4 5 6 7 8 9) includes: num) ifTrue: [self fillPolygon: bottomRight].
	(#(0 2 3 5 6 8 9) includes: num) ifTrue: [self fillPolygon: bottom].
	

]

{ #category : 'Not categorized' }
MinesweeperWindow >> drawText: textItems at: aPoint [

	"Draw the text at the given point"

	self drawable
		drawText: self gc
		x: aPoint x
		y: aPoint y
		items: textItems
]

{ #category : 'Not categorized' }
MinesweeperWindow >> drawTopBorder [

	"Draws the border around the top numbers and face"

	| topLeftPart topRightPart |
	
	topLeftPart := OrderedCollection 
		with: 5@5 with: ((gridWidth * 20) + 11)@5 with: ((gridWidth * 20) + 8)@8 with: 8@8 with: 8@42 with: 5@45.
	topRightPart := OrderedCollection
		with: 5@45 with: 8@42 with: ((gridWidth * 20) + 8)@42 with: ((gridWidth * 20) + 8)@8
		with: ((gridWidth * 20) + 11)@5 with: ((gridWidth * 20) + 11)@45.
		
	self
		foreground: (self cellBorderGray);
		fillPolygon: topLeftPart;
		foreground: (self white);
		fillPolygon: topRightPart
]

{ #category : 'Not categorized' }
MinesweeperWindow >> fillCircle: r [


	"Fill the circle r."

	self drawable
		fillArc: self gc
		x:  r origin x
		y:  r origin y
		width:  r width
		height: r height
		angle1: 0
		angle2: 380 * 60
]

{ #category : 'Not categorized' }
MinesweeperWindow >> fillPolygon: points [

	"Fill the polygon given by the list of points"

	self drawable
		fillPolygon: self gc
		points: points
		shape: Complex
		mode: CoordModeOrigin
]

{ #category : 'Not categorized' }
MinesweeperWindow >> fillRect: r [

	"Fill the rectangle r."

	self drawable
		fillRectangle: self gc
		x: r origin x
		y: r origin y
		width: r width
		height: r height.
]

{ #category : 'Not categorized' }
MinesweeperWindow >> floodEmptyX: xVal y: yVal [

	"Floods the empty cells"

	| stack |
	
	stack := OrderedCollection with: xVal@yVal.
	[(stack size) > 0]
		whileTrue: [
			| stckX stckY |
			stckX := ((stack first) x).
			stckY := ((stack first) y).
			"Add neighbors to stack if 0"
			(((board at: stckY) at: stckX) = 0)
				ifTrue: [
					"Top Left"
					(((stckX > 1) and: [stckY > 1]) and: [((clicked at: (stckY - 1)) at: (stckX - 1)) = 0])
						ifTrue: [
							(clicked at: (stckY - 1)) at: (stckX - 1) put: 2.
							(((board at: (stckY - 1)) at: (stckX - 1)) = 0)
								ifTrue: [stack add: (stckX - 1)@(stckY - 1)]].
					"Top Center"
					((stckY > 1) and: [((clicked at: (stckY - 1)) at: (stckX)) = 0])
						ifTrue: [
							(clicked at: (stckY - 1)) at: (stckX) put: 2.
							(((board at: (stckY - 1)) at: (stckX)) = 0)
								ifTrue: [stack add: (stckX)@(stckY - 1)]].
					"Top Right"
					(((stckX < gridWidth) and: [stckY > 1]) and: [((clicked at: (stckY - 1)) at: (stckX + 1)) = 0])
						ifTrue: [
							(clicked at: (stckY - 1)) at: (stckX + 1) put: 2.
							(((board at: (stckY - 1)) at: (stckX + 1)) = 0)
								ifTrue: [stack add: (stckX + 1)@(stckY - 1)]].
					"Left"
					((stckX > 1) and: [((clicked at: (stckY)) at: (stckX - 1)) = 0])
						ifTrue: [
							(clicked at: (stckY)) at: (stckX - 1) put: 2.
							(((board at: (stckY)) at: (stckX - 1)) = 0)
								ifTrue: [stack add: (stckX - 1)@(stckY)]].
					"Right"
					((stckX < gridWidth) and: [((clicked at: (stckY)) at: (stckX + 1)) = 0])
						ifTrue: [
							(clicked at: (stckY)) at: (stckX + 1) put: 2.
							(((board at: (stckY)) at: (stckX + 1)) = 0)
								ifTrue: [stack add: (stckX + 1)@(stckY)]].
					"Bottom Left"
					(((stckX > 1) and: [stckY < gridHeight]) and: [((clicked at: (stckY + 1)) at: (stckX - 1)) = 0])
						ifTrue: [
							(clicked at: (stckY + 1)) at: (stckX - 1) put: 2.
							(((board at: (stckY + 1)) at: (stckX - 1)) = 0)
								ifTrue: [stack add: (stckX - 1)@(stckY + 1)]].
					"Bottom Center"
					((stckY < gridHeight) and: [((clicked at: (stckY + 1)) at: (stckX)) = 0])
						ifTrue: [
							(clicked at: (stckY + 1)) at: (stckX) put: 2.
							(((board at: (stckY + 1)) at: (stckX)) = 0)
								ifTrue: [stack add: (stckX)@(stckY + 1)]].
					"Bottom Right"
					(((stckX < gridWidth) and: [stckY < gridHeight]) and: [((clicked at: (stckY + 1)) at: (stckX + 1)) = 0])
						ifTrue: [
							(clicked at: (stckY + 1)) at: (stckX + 1) put: 2.
							(((board at: (stckY + 1)) at: (stckX + 1)) = 0)
								ifTrue: [stack add: (stckX + 1)@(stckY + 1)]]].
				stack removeFirst].
	
]

{ #category : 'Not categorized' }
MinesweeperWindow >> foreground: anInteger [

	"Set the foreground colour to anInteger."

	self gc
		setForeground: anInteger
]

{ #category : 'Not categorized' }
MinesweeperWindow >> gc [

	"Answer the CgGC to use for the test."

	^gc
]

{ #category : 'Not categorized' }
MinesweeperWindow >> gray [

	"Color Gray"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 128 green: 128 blue: 128)
]

{ #category : 'Not categorized' }
MinesweeperWindow >> green [

	"Color Green"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 3 green: 126 blue: 1)
]

{ #category : 'Not categorized' }
MinesweeperWindow >> HelpClick: aButton clientData: clientData callData: callData [

	"Creates a pop-up showing the help information"

	(self isRealized)
		ifTrue: [
			(CwMessagePrompter new
				buttonType: XmOK;
				title: ' Minesweeper - Help';
				iconType: XmNOICON;
				messageString: 'Click to uncover a square and right-click to flag a square. ',
										'The total amount of un-flagged mines is displayed on the ',
										'left and the time in seconds is displayed on the right. Press the ',
										'face to reset the current game board.';
				prompt)].
]

{ #category : 'Not categorized' }
MinesweeperWindow >> initializeGraphics [

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
MinesweeperWindow >> input: aDrawingArea clientData: clientData callData: callData [

	"On-click of the drawing area"

	| event point resetXrange resetYrange |
	
	event := callData event.
	resetXrange := ((((gridWidth * 20) / 2) - 7) to: (((gridWidth * 20) / 2) + 23)).
	resetYrange := (10 to: 40).
	
	point := self squarePressedX: (event x) y: (event y).
	
	"On Mouse Down"
	(event type = ButtonPress and: [event button = Button1])
		ifTrue: [
			((counting) and: [((point x ~= -1) and: [point y ~= -1])])
				ifTrue: [self drawFaceX: (((gridWidth * 20) / 2) - 7) y: 10 num: 3].
			((resetXrange includes: (event x)) and: [resetYrange includes: (event y)])
				ifTrue: [self setVariables]].

	"On Click Release"
	((event type = ButtonRelease and: [event button = Button1]) and: [counting])
		ifTrue: [
			(((point x = -1) or: [point y = -1]) or: [((clicked at: (point y)) at: (point x)) = 1])
				ifFalse: [
					(running = false)
						ifTrue: [
							running := true.
							self timer].
					(((board at: (point y)) at: (point x)) = 9)
						ifTrue: [
							triggered := (point x)@(point y).
							self showAllMines.
							counting := false].
					(clicked at: (point y)) at: (point x) put: 2.
					self 
						floodEmptyX: (point x) y: (point y);
						drawBoard;
						checkCompleteness.]].
					
	"On Right Click Release"
	((event type = ButtonRelease and: [event button = Button3]) and: [counting])
		ifTrue: [
			((point x = -1) or: [point y = -1])
				ifFalse: [
					(running = false)
						ifTrue: [
							running := true.
							self timer].
					(((clicked at: (point y)) at: (point x)) = 0)
						ifTrue: [
							(clicked at: (point y)) at: (point x) put: 1.
							minesLeft := minesLeft - 1.
							self drawCornerNumbers]
						ifFalse: [
							(((clicked at: (point y)) at: (point x)) = 1)
							ifTrue: [
								(clicked at: (point y)) at: (point x) put: 0.
								minesLeft := minesLeft + 1.
								self drawCornerNumbers]].
					self drawBoard]].
	
]

{ #category : 'Not categorized' }
MinesweeperWindow >> isRealized [

	"Answer a Boolean indicating whether the drawing area widget has been realized."

	| widget |
	^(widget := self drawingArea) notNil
		and: [widget isRealized]
]

{ #category : 'Not categorized' }
MinesweeperWindow >> mainWindowArgs [

	"Answer an argBlock containing some default width and height settings."
	
	^[:w | w width: 196; height: 241]
]

{ #category : 'Not categorized' }
MinesweeperWindow >> MenuClick: aButton clientData: clientData callData: callData [

	"Change the game style and reset"
	menuButtons do: [:a | a set: false].
	aButton setState: true notify: false.
	
	(clientData = 'Beginner')
		ifTrue: [
			gridWidth := 9.
			gridHeight := 9.
			mines := 10].
	(clientData = 'Intermediate')
		ifTrue: [
			gridWidth := 16.
			gridHeight := 16.
			mines := 40].
	(clientData = 'Expert')
		ifTrue: [
			gridWidth := 30.
			gridHeight := 16.
			mines := 99].
			
	shell width: ((gridWidth * 20) + 16).
	shell height: (61 + (gridHeight * 20)).
	self setVariables.
]

{ #category : 'Not categorized' }
MinesweeperWindow >> open [

	"Set all the initial parameters and reset the graphics"
	
	super open.
	self setVariables
]

{ #category : 'Not categorized' }
MinesweeperWindow >> printGrid: grid [

	"Print the given two-dimensional list on the Transcript"

	Transcript clear.
	grid do: [:row |
		row do: [:i | Transcript show: ((i printString), '  ')].
		Transcript cr.].
	
	

	
]

{ #category : 'Not categorized' }
MinesweeperWindow >> red [

	"Color Red"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 253 green: 0 blue: 0)
]

{ #category : 'Not categorized' }
MinesweeperWindow >> setVariables [

	"Initialize all the variables"

	(gridWidth = nil)
		ifTrue: [gridWidth := 9].
	(gridHeight = nil)
		ifTrue: [gridHeight := 9].
	(mines = nil)
		ifTrue: [mines := 10].
	triggered := (-1)@(-1).
	
	minesLeft := mines.
	time := 0.		
	running := false.
	counting := true.
	
	colors := OrderedCollection new.
	colors
		add: (self blue);
		add: (self green);
		add: (self red);
		add: (self darkBlue);
		add: (self darkRed);
		add: (self aqua);
		add: (self black);
		add: (self gray).
	
	board := OrderedCollection new.
	1 to: gridHeight do: [:a |
		| row |
		row := OrderedCollection new.
		1 to: gridWidth do: [:b | row add: 0].
		board add: row.].
		
	clicked := OrderedCollection new.
	1 to: gridHeight do: [:a |
		| row |
		row := OrderedCollection new.
		1 to: gridWidth do: [:b | row add: 0].
		clicked add: row.].
			
	self 
		addMines;
		updateNeighbors;
		printGrid: board;
		clear;
		drawBoard

	
]

{ #category : 'Not categorized' }
MinesweeperWindow >> shellName [

	"Answer the name of the receiver's shell.
	This is used as the default label of the window."

	^'Minesweeper'
]

{ #category : 'Not categorized' }
MinesweeperWindow >> showAllMines [

	"Uncover all mines"

	1 to: (board size) do: [:w |
		1 to: ((board at: w) size) do: [:v |
			((((board at: w) at: v) = 9) and: [((clicked at: w) at: v) ~= 1])
				ifTrue: [(clicked at: w) at: v put: 2]]].
]

{ #category : 'Not categorized' }
MinesweeperWindow >> squarePressedX: xVal y: yVal [

	"Return the location of the cell the user clicked on"
	
	| blockX blockY |
	
	blockX := -1.
	blockY := -1.
	
	1 to: gridWidth do: [:p |
		| boX |
		boX := (8 + (20 * (p - 1))).
		(xVal > boX and: [xVal < (boX + 20)])
			ifTrue: [blockX := p].].
			
	1 to: gridHeight do: [:p |
		| boY |
		boY := (53 + (20 * (p - 1))).
		(yVal > boY and: [yVal < (boY + 20)])
			ifTrue: [blockY := p].].

	^blockX@blockY

	
]

{ #category : 'Not categorized' }
MinesweeperWindow >> TextItem: aString [

	"Creates a text item based on the given string"

	^CgTextItem new
		chars: aString;
		delta: 0;
		font: 0
]

{ #category : 'Not categorized' }
MinesweeperWindow >> timer [

	"Keep track of the time since the user started"

	| delayVar |
	delayVar := Delay new.
	delayVar delayTime: 1000.
	
	"Run timer when running and the window is realized"
	[[(running = true) & (self isRealized)]
		whileTrue: [
			(counting)
				ifTrue: [time := time + 1].
			self drawCornerNumbers.
			delayVar wait]] forkAt: Processor userBackgroundPriority.
]

{ #category : 'Not categorized' }
MinesweeperWindow >> updateNeighbors [

	"Adds the neighboring mine count to each cell"

	1 to: (board size) do: [:h |
		1 to: ((board at: h) size) do: [:w |
			(((board at: h) at: w) = 0)
				ifTrue: [
					"Top Left"
					(((h > 1) and: [w > 1]) and: [((board at: (h - 1)) at: (w - 1)) = 9])
						ifTrue: [(board at: h) at: w put: (((board at: h) at: w) + 1)].
					"Top Center"
					((h > 1) and: [((board at: (h - 1)) at: w) = 9])
						ifTrue: [(board at: h) at: w put: (((board at: h) at: w) + 1)].
					"Top Right"
					(((h > 1) and: [w < gridWidth]) and: [((board at: (h - 1)) at: (w + 1)) = 9])
						ifTrue: [(board at: h) at: w put: (((board at: h) at: w) + 1)].
					"Left"
					((w > 1) and: [((board at: h) at: (w - 1)) = 9])
						ifTrue: [(board at: h) at: w put: (((board at: h) at: w) + 1)].
					"Right"
					((w < gridWidth) and: [((board at: h) at: (w + 1)) = 9])
						ifTrue: [(board at: h) at: w put: (((board at: h) at: w) + 1)].
					"Bottom Left"
					(((h < gridHeight) and: [w > 1]) and: [((board at: (h + 1)) at: (w - 1)) = 9])
						ifTrue: [(board at: h) at: w put: (((board at: h) at: w) + 1)].
					"Bottom Center"
					((h < gridHeight) and: [((board at: (h + 1)) at: w) = 9])
						ifTrue: [(board at: h) at: w put: (((board at: h) at: w) + 1)].
					"Bottom Right"
					(((h < gridHeight) and: [w < gridWidth]) and: [((board at: (h + 1)) at: (w + 1)) = 9])
						ifTrue: [(board at: h) at: w put: (((board at: h) at: w) + 1)]]]].
	
		
		

	
]

{ #category : 'Not categorized' }
MinesweeperWindow >> white [

	"Color White"
	
	^ shell window getPalette 
		nearestPixelValue: Color white
]

{ #category : 'Not categorized' }
MinesweeperWindow >> yellow [

	"Color Yellow"
	
	^ shell window getPalette 
		nearestPixelValue: Color yellow
]
