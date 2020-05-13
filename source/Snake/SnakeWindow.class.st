Class {
	#name : 'SnakeWindow',
	#superclass : 'WidgetApplication',
	#instVars : [
		'gc',
		'drawingArea',
		'timerProcId',
		'board',
		'currentDirection',
		'count',
		'running',
		'food',
		'pressed',
		'theme',
		'highscore',
		'speed',
		'themeButtons',
		'modeButtons'
	],
	#pools : [
		'CgConstants'
	],
	#category : 'Snake'
}

{ #category : 'Not categorized' }
SnakeWindow >> addFood [

	"Create food at a random available location"

	| row col finding rand|
	rand := EsRandom new.
	finding := true.
	
	"Keep picking locations until it's available"
	[finding = true]
		whileTrue: [
			row := rand nextInt: 40.
			col := rand nextInt: 30.
			(((board at: row) at: col) = 0)
				ifTrue: [
					food := row@col.
					finding := false].].
		
			
		
		
]

{ #category : 'Not categorized' }
SnakeWindow >> addLabelsMenu: menu label: label data: data selector: selector [

	"Adds the item to the given menu"
	
	self
		addMenuEntryTo: menu 
		label: label
		selector: selector
		clientData: data.
]

{ #category : 'Not categorized' }
SnakeWindow >> addLength [

	"Renders the length text in the bottom right-hand corner"
	
	| text |
	text := Array with: (self TextItem: ('Length: ', ((count - 2)) printString)).
	
	self
		foreground: self white;
		drawText: text at: 540@468
]

{ #category : 'Not categorized' }
SnakeWindow >> background: anInteger [

	"Set the background colour to anInteger."

	self gc
		setBackground: anInteger
]

{ #category : 'Not categorized' }
SnakeWindow >> BestClick: aButton clientData: clientData callData: callData [

	"Show the highscore when clicked"
	
	self highscoreShow.

		

	
]

{ #category : 'Not categorized' }
SnakeWindow >> black [

	"Black Color"
	
	^ shell window getPalette 
		nearestPixelValue: Color black. 
		
			
		
		
]

{ #category : 'Not categorized' }
SnakeWindow >> blue [

	"Blue Color"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 0 green: 102 blue: 153).
]

{ #category : 'Not categorized' }
SnakeWindow >> blueSky [

	"Blue Sky Color"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 76 green: 181 blue: 245).
]

{ #category : 'Not categorized' }
SnakeWindow >> createPulldownMenus [
	"Create the pulldown menus"

	| menu1 menu2 menu3 themes modes button |
	
	"Add the themes to a collections"
	themes := OrderedCollection new
		add: 'Main'; add: 'Dark'; add: 'Neon'; add: 'Ice'; 
		yourself.
	
	"Add the modes to a collections"
	modes := OrderedCollection new
		add: 'Easy'; add: 'Medium'; add: 'Hard';
		yourself.
	

	"Create theme menu and add the possible themes to the menu"
	menu1 := (self addPulldownMenu: 'Theme') subMenuId.
	themeButtons := OrderedCollection new.
	themes doWithIndex: [:item :i | 
		button := 
			self 
				addMenuEntryTo: menu1 
				buttonClass: CwToggleButton 
				label: item 
				selector: #ThemeClick:clientData:callData: 
				clientData: item.
		(item = 'Main')
			ifTrue: [button setState: true notify: false].
		themeButtons add: button].
		
	"Create mode menu and add the possible modes to the menu"
	menu2 := (self addPulldownMenu: 'Mode') subMenuId.
	modeButtons := OrderedCollection new.
	modes doWithIndex: [:item :i | 
		button :=
			self 
				addMenuEntryTo: menu2
				buttonClass: CwToggleButton 
				label: item 
				selector: #ModeClick:clientData:callData: 
				clientData: item.
		(item = 'Medium')
			ifTrue: [button setState: true notify: false].
		modeButtons add: button].
		
	"Create highscore menu and add highscore to the menu"
	menu3 := (self addPulldownMenu: 'Highscore') subMenuId.
	self addLabelsMenu: menu3 label: 'Highscore' data: 'Highscore' selector: #BestClick:clientData:callData:

	
]

{ #category : 'Not categorized' }
SnakeWindow >> createRectX: xVal y: yVal width: w height: h color: colr [

	"Create a filled rectangle"
	
	| r |
	r := xVal@yVal extent: w@h.

	self
		foreground: colr;
		fillRect: r.
]

{ #category : 'Not categorized' }
SnakeWindow >> createWorkRegion [

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
			width: 680;
			height: 480].
	drawingArea 
		manageChild;
		addEventHandler: KeyPressMask
			receiver: self
			selector: #keyPress:clientData:event:
			clientData: nil;
		addCallback: XmNdestroyCallback
			receiver: self
			selector: #destroy:clientData:callData:
			clientData: nil.
]

{ #category : 'Not categorized' }
SnakeWindow >> darkGray [

	"Dark Gray Color"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 51 green: 51 blue: 51). 
		
			
		
		
]

{ #category : 'Not categorized' }
SnakeWindow >> destroy: widget clientData: clientData callData: callData [
	"The drawing area has been destroyed."

	"Remove the timerProc."
	self removeTimeout.
	"Free the color and GC."
	self gc freeGC
]

{ #category : 'Not categorized' }
SnakeWindow >> drawable [

	"Checks if the drawing area is ready to be drawn on"

	self isRealized
		ifTrue: [^self drawingArea window]
		ifFalse: [^self screen rootWindow]
]

{ #category : 'Not categorized' }
SnakeWindow >> drawBackground [

	"Renders the background"

	self
		createRectX: 0 y: 0 width: 630 height: 480 color: (theme at: 1);	
		createRectX: 30 y: 30 width: 570 height: 420 color: (theme at: 2);
		addLength
		
		
		
]

{ #category : 'Not categorized' }
SnakeWindow >> drawFood [

	"Render the food"

	self
		createRectX: (food x) * 15 + 1
		y: (food y) * 15 + 1
		width: 13
		height: 13
		color: (theme at: 4)
]

{ #category : 'Not categorized' }
SnakeWindow >> drawGame [

	"Render the background, food and snake on the screen"
	
	self
		drawBackground;
		drawFood;
		drawSnake
]

{ #category : 'Not categorized' }
SnakeWindow >> drawingArea [

	"Answer the drawing area widget."

	^self workRegion
]

{ #category : 'Not categorized' }
SnakeWindow >> drawSnake [

	"Render the snake on the screen"

	board do: [:c |
		c do: [:w |
			(w > 1) 
				ifTrue: [
					self
						createRectX: (board indexOf: c)  * 15 + 1
						y: (c indexOf: w) * 15 + 1
						width: 13
						height: 13
						color: (theme at: 3).].].].
		
		
			
		
		
]

{ #category : 'Not categorized' }
SnakeWindow >> drawText: textItems at: aPoint [

	"Draws text at a given location"

	self drawable
		drawText: self gc
		x: aPoint x
		y: aPoint y
		items: textItems
]

{ #category : 'Not categorized' }
SnakeWindow >> fillRect: r [

	"Fill the rectangle r."

	self drawable
		fillRectangle: self gc
		x: r origin x
		y: r origin y
		width: r width
		height: r height.
]

{ #category : 'Not categorized' }
SnakeWindow >> foreground: anInteger [

	"Set the foreground colour to anInteger."

	self gc
		setForeground: anInteger
]

{ #category : 'Not categorized' }
SnakeWindow >> function: anInteger [

	"Set the combination function to anInteger."

	self gc
		setFunction: anInteger
]

{ #category : 'Not categorized' }
SnakeWindow >> gc [

	"Answer the CgGC to use for the test."

	^gc
]

{ #category : 'Not categorized' }
SnakeWindow >> highscoreShow [

	"Creates a pop-up showing the highscore"

	(self isRealized)
		ifTrue: [
			(CwMessagePrompter new
				buttonType: XmOK;
				title: ' Highscore';
				iconType: XmNOICON;
				messageString: (highscore printString);
				prompt)].
]

{ #category : 'Not categorized' }
SnakeWindow >> ice [

	"Ice Color"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 102 green: 204 blue: 255).
]

{ #category : 'Not categorized' }
SnakeWindow >> initializeBoard [

	"Initailize the board and start timer"

	self reset.
	"Set initial colors"
	theme := OrderedCollection new
		add: (self lightRed); add: (self blue); add: (self yellow); add: (self red);
		yourself.
	highscore := 1.
	speed := 100.
	
		
			
		
		
]

{ #category : 'Not categorized' }
SnakeWindow >> initializeGraphics [

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
SnakeWindow >> isRealized [

	"Answer a Boolean indicating whether the drawing area widget has been realized."

	| widget |
	^(widget := self drawingArea) notNil
		and: [widget isRealized]
]

{ #category : 'Not categorized' }
SnakeWindow >> keyPress: area clientData: clientData event: event [

	"Takes the key input and updates the snakes direction"

	area hasFocus ifFalse: [^self].
	(pressed = false)
		ifTrue: [
			"If the up key is pressed"
			event keysym = XKUp ifTrue: [
				(currentDirection ~= 'down')
					ifTrue: [
						currentDirection := 'up'.
						pressed := true].].
			"If the down key is pressed"
			event keysym = XKDown ifTrue: [
				(currentDirection ~= 'up')
					ifTrue: [
						currentDirection := 'down'.
						pressed := true].].
			"If the left key is pressed"
			event keysym = XKLeft ifTrue: [
				(currentDirection ~= 'right')
					ifTrue: [
						currentDirection := 'left'.
						pressed := true].].
			"If the right key is pressed"
			event keysym = XKRight ifTrue: [
				(currentDirection ~= 'left')
					ifTrue: [
						currentDirection := 'right'.
						pressed := true].].].
]

{ #category : 'Not categorized' }
SnakeWindow >> lightPink [

	"Light Pink Color"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 255 green: 153 blue: 255).
]

{ #category : 'Not categorized' }
SnakeWindow >> lightRed [

	"Light Red Color"

	^ shell window getPalette 
		nearestPixelValue: (Color red: 255 green: 102 blue: 102).
]

{ #category : 'Not categorized' }
SnakeWindow >> mainWindowArgs [

	"Answer an argBlock containing some default width and height settings."

	^[:w | w width: 630; height: 480]
]

{ #category : 'Not categorized' }
SnakeWindow >> messageStartEqualEnd [

	"Creates a pop-up at the end for restarting or quitting"

	(self isRealized)
		ifTrue: [
			(CwMessagePrompter 
				confirm: 'Play Again?'
				title: ' You died :(')
					ifTrue: [self reset]
					ifFalse: [self shell destroyWidget].].
			
]

{ #category : 'Not categorized' }
SnakeWindow >> ModeClick: aButton clientData: clientData callData: callData [

	"Change the mode based on what is selected"
	modeButtons do: [:a | a set: false].
	aButton setState: true notify: false.
	
	(clientData = 'Easy') ifTrue: [speed := 150].
	(clientData = 'Medium') ifTrue: [speed := 100].
	(clientData = 'Hard') ifTrue: [speed := 50].
	
]

{ #category : 'Not categorized' }
SnakeWindow >> moveSnake [

	"Create a new snake part at the head of the snake depending on the direction and 
	 checking whether the snake has collided with itself or one of the walls. Also checks 
	 if the snake has got the food, and grows the snake. The snake is then updated and 
	 drawn to the screen."

	1 to: (board size) do: [:i |
		1 to: ((board at: i) size) do: [:j |
			(((board at: i) at: j) = 3)
				ifTrue: [
					"Collect food"
					((i = (food x)) and: [(j = (food y))])
						ifTrue: [
							count := (count + 5).
							((count - 2) > highscore) 
								ifTrue: [highscore := (count - 2)].
							self addFood].
					"Add the new part above the head"
					(currentDirection = 'up')
						ifTrue: [
							(((board at: i) at: (j - 1)) = 0)
								ifFalse: [running := false].
							(board at: i) at: (j - 1) put: 2].
					"Add the new part to the left of the head"
					(currentDirection = 'left')
						ifTrue: [
							(((board at: (i - 1)) at: j) = 0)
								ifFalse: [running := false].
							(board at: (i - 1)) at: j put: 2].
					"Add the new part to the right of the head"
					(currentDirection = 'right' )
						ifTrue: [
							(((board at: (i + 1)) at: j) = 0)
								ifFalse: [running := false].
							(board at: (i + 1)) at: j put: 2].
					"Add the new part below the head"
					(currentDirection = 'down')
						ifTrue: [
							(((board at: i) at: (j +1)) = 0)
								ifFalse: [running := false].
							(board at: i) at: (j +1) put: 2].
					"Keep the snake still until a direction is chosen"
					(currentDirection = 'begin')
						ifTrue: [
							(board at: i) at: j put: 2].].].].
		
		self 
			updateSnake;
			drawGame
]

{ #category : 'Not categorized' }
SnakeWindow >> neonBlue [

	"Cyan Color"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 0 green: 255 blue: 255).
]

{ #category : 'Not categorized' }
SnakeWindow >> neonPink [

	"Pink Color"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 255 green: 0 blue: 255).
]

{ #category : 'Not categorized' }
SnakeWindow >> neonPurple [

	"Purple Color"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 153 green: 0 blue: 255).
]

{ #category : 'Not categorized' }
SnakeWindow >> open [

	"Set all the initial parameters and start the timer"

	super open.
	self 
		initializeBoard;
		registerTimeoutIn: 0
]

{ #category : 'Not categorized' }
SnakeWindow >> red [

	"Red Color"

	^ shell window getPalette 
		nearestPixelValue: (Color red: 255 green: 51 blue: 51).
]

{ #category : 'Not categorized' }
SnakeWindow >> registerTimeoutIn: ms [

	timerProcId :=
		CwAppContext default
			addTimeout: ms
			receiver: self
			selector: #timerProc:
			clientData: nil
]

{ #category : 'Not categorized' }
SnakeWindow >> removeTimeout [
	"Remove the current timeout."

	CwAppContext default
		removeTimeout: timerProcId.
]

{ #category : 'Not categorized' }
SnakeWindow >> reset [

	"Reset the board"
	
	| r |
	"Set all squares in the board to zero except the starting position"
	board := OrderedCollection new.
	1 to: 40 do: [:i |
		r := OrderedCollection new.
		1 to: 30 do: [:j |
			((i = 1) or: [(i = 40) or: [(j = 1) or: [j = 30]]])
				ifTrue: [r add: -1]
				ifFalse: [r add: 0]].
		board add: r.].
	(board at: 3) at: 3 put: 3.
	"Initialize direction, running and count"
	currentDirection := 'begin'.
	running := true.
	count := 3.
	"Add food to the new board"
	self addFood. 
	
		
			
		
		
]

{ #category : 'Not categorized' }
SnakeWindow >> shellName [

	"Answer the name of the receiver's shell.
	This is used as the default label of the window."

	^'Snake - Lee Clayberg'
]

{ #category : 'Not categorized' }
SnakeWindow >> TextItem: aString [

	"Creates a text item"

	^CgTextItem new
		chars: aString;
		delta: 0;
		font: 0
]

{ #category : 'Not categorized' }
SnakeWindow >> ThemeClick: aButton clientData: clientData callData: callData [

	"Change the theme based on what is selected"
	themeButtons do: [:a | a set: false].
	aButton setState: true notify: false.
	
	(clientData = 'Main')
		ifTrue: [	
			theme := OrderedCollection new
				add: (self lightRed); add: (self blue); add: (self yellow); add: (self red);
				yourself.].
	(clientData = 'Dark')
		ifTrue: [
			theme := OrderedCollection new
				add: (self veryDarkGray); add: (self darkGray); add: (self white); add: (self black);
				yourself.].
	(clientData = 'Neon')
		ifTrue: [
			theme := OrderedCollection new
				add: (self neonPink); add: (self neonPurple); add: (self neonBlue); add: (self lightPink);
				yourself.].
	(clientData = 'Ice')
		ifTrue: [
			theme := OrderedCollection new
				add: (self ice); add: (self blueSky); add: (self veryLightGray); add: (self blue);
				yourself.].
	
]

{ #category : 'Not categorized' }
SnakeWindow >> timerProc: value [
	"This is the timer proc.  Update the display with
	 the current time and register a new timeout."

	pressed := false.
		
	self drawingArea isDestroyed ifTrue: [^self].
	(running)
		ifTrue: [self moveSnake]
		ifFalse: [self messageStartEqualEnd].
	self registerTimeoutIn: speed. 

]

{ #category : 'Not categorized' }
SnakeWindow >> updateSnake [

	"Adds 1 to each part of the snake and changes the snake based on its length"

	| f r |
	f := OrderedCollection new.
	board do: [:w |
		r := OrderedCollection new.
		w do: [:c | 
			((c > 1 ) and: [c < count])
				ifTrue: [r add: (c + 1)]
				ifFalse: [
					(c = -1)
						ifTrue: [r add: -1]
						ifFalse: [r add: 0].].].
		f add: r.].
	board := f.
						
					

			
			
		
		
]

{ #category : 'Not categorized' }
SnakeWindow >> veryDarkGray [

	"Very Dark Gray Color"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 17 green: 17 blue: 17). 
		
			
		
		
]

{ #category : 'Not categorized' }
SnakeWindow >> veryLightGray [

	"Very Light Color"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 238 green: 238 blue: 238).
]

{ #category : 'Not categorized' }
SnakeWindow >> white [

	"White Color"

	^ shell window getPalette 
		nearestPixelValue: Color white
]

{ #category : 'Not categorized' }
SnakeWindow >> yellow [

	"Yellow Color"

	^ shell window getPalette 
		nearestPixelValue: Color yellow
]
