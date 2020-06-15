Class {
	#name : 'TowerOfHanoiWindow',
	#superclass : 'WidgetApplication',
	#instVars : [
		'gc',
		'drawingArea',
		'diskCount',
		'pegs',
		'start',
		'end',
		'colors',
		'moves',
		'currentMove',
		'running'
	],
	#pools : [
		'CgConstants',
		'NlsCatCGEX'
	],
	#category : 'TowerOfHanoi'
}

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> addLabelsMenu: menu label: label data: data selector: selector [
	"adds the item to the given menu"
	
	self
		addMenuEntryTo: menu 
		label: label
		selector: selector
		clientData: data.
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> addPegLetters [

	| item1 item2 item3 |

	item1 := Array with: (self TextItem: 'A').
	item2 := Array with: (self TextItem: 'B').
	item3 := Array with: (self TextItem: 'C').

	self
		foreground: self black;
		drawText: item1 at: 120@65;
		drawText: item2 at: 245@65;
		drawText: item3 at: 370@65.
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> addTowerOfHanoi [
	
	| text |

	text := Array with: (self TextItem: 'Towers of Hanoi').
	
	self
		foreground: self black;
		drawText: text at: 200@275.
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> animation: aButton [

	| delayVar |
	delayVar := Delay new.
	delayVar delayTime: 250.
	[[currentMove <= (moves size) & (running = true) & (self isRealized)]
		whileTrue: [
			self step.
			delayVar wait].
	aButton labelString: 'PLAY'.
	running := false] forkAt: Processor userBackgroundPriority.

]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> background: anInteger [
	"Set the background colour to anInteger."

	self gc
		setBackground: anInteger
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> black [
	"Color Black"
	
	^ shell window getPalette 
		nearestPixelValue: Color black. 
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> blue [
	"Color Blue"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 0 green: 102 blue: 255).
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> brown [
	"Color Brown"
	
	^ shell window getPalette 
		nearestPixelValue: Color brown.
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> buttonNames [
	"the array of buttons at the bottom of the window"

	^#('<<' '<' 'PLAY' '>' '>>')
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> clear [

	self 
		createRectX: 0 y: 0 
		width: (drawingArea width)
		height: (drawingArea height)
		color: (self lightestGray).
		

	
		
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> createDiskX: xVal y: yVal width: w height: h color: colr [
		"Test whether rectangle coordinates
	 are calculated correctly.
	 A rectangle is first outlined.
	 A filled rectangle is then drawn
	 using the same coordinates.
	 The filled area should overwrite the
	 left and top portions of the outline,
	 but not the bottom and right."
	| r |

	r := xVal@yVal extent: w@h.
	

	self
		foreground: colr;
		fillRect: r;
		foreground: self black;
		drawRect: r.
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> createPegs [

	self 
		"Pegs"
		createRectX: 114 y: 49 width: 22 height: 182 color: self black;
		createRectX: 239 y: 49 width: 22 height: 182 color: self black;
		createRectX: 364 y: 49 width: 22 height: 182 color: self black;
		
		createRectX: 49 y: 229 width: 402 height: 22 color: self black;
		
		createRectX: 115 y: 50 width: 20 height: 180 color: self gray;
		createRectX: 240 y: 50 width: 20 height: 180 color: self gray;
		createRectX: 365 y: 50 width: 20 height: 180 color: self gray;
		"Base"
		createRectX: 50 y: 230 width: 400 height: 20 color: self gray;
		
		addPegLetters.
		
		
		
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> createPulldownMenus [
	"Create the pulldown menus."

	| p1 p2 p3 list1 list2|
	
	
	list1 := OrderedCollection new
		add: '1'; add: '2'; add: '3'; add: '4'; add: '5';add: '6';
		yourself.
	list2 := OrderedCollection new
		add: 'A'; add: 'B'; add: 'C';
		yourself.

	p1 := (self addPulldownMenu: 'Disks') subMenuId.
	list1 doWithIndex: [:item :i | 
		self addLabelsMenu: p1 label: item data: item selector: #diskMenuClick:clientData:callData:].
	p2 := (self addPulldownMenu: 'Start Peg') subMenuId. 
	list2 doWithIndex: [:item :i | 
		self addLabelsMenu: p2 label: item data: i selector: #pegMenuClick1:clientData:callData:].
	p3 := (self addPulldownMenu: 'End Peg') subMenuId.
	list2 doWithIndex: [:item :i | 
		self addLabelsMenu: p3 label: item data: i selector: #pegMenuClick2:clientData:callData:].

	
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> createRectX: xVal y: yVal width: w height: h color: colr [
		"Test whether rectangle coordinates
	 are calculated correctly.
	 A rectangle is first outlined.
	 A filled rectangle is then drawn
	 using the same coordinates.
	 The filled area should overwrite the
	 left and top portions of the outline,
	 but not the bottom and right."
	| r |

	r := xVal@yVal extent: w@h.
	

	self
		foreground: colr;
		fillRect: r.
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> createWorkRegion [
	"Create the receiver's workRegion widget hierarchy."

	| form bottomButtons |
	
	form := CwForm 
		createManagedWidget: 'drawingArea'
		parent: self mainWindow 
		argBlock: nil.
	form manageChild.
	self workRegion: form.	

	"Creates the drawing area for towers"
	drawingArea := CwDrawingArea
		createWidget: 'drawingArea'  "$NON-NLS$"
		parent:  form
		argBlock: [:w | w
			width: 500;
			height: 300].
	drawingArea manageChild.
	
	"Creates the container for the buttons at the bottom of the screen"
	bottomButtons := form
		createRowColumn: 'toggle buttons'
		argBlock: [:w | w 
			orientation: XmHORIZONTAL;
			packing: XmPACKCOLUMN;
			numColumns: 1;
			x: 15;
			y: 310;
			spacing: 15].
	bottomButtons manageChild.
	
	"Creates the buttons with their name coming from the buttonNames method"
	self buttonNames
		do: [:name |
			(bottomButtons
				createPushButton: name 
				argBlock: [:w | w
					width: 82;
					height: 40])
					manageChild;
					addCallback: XmNactivateCallback
					receiver: self
					selector: #pressed:clientData:callData:
					clientData: name ].
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> cyan [
	"Color Cyan"
	
	^ shell window getPalette 
		nearestPixelValue: Color cyan.
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> diskMenuClick: aButton clientData: clientData callData: callData [

				
	diskCount := (clientData asNumber).
	self 
		clear;
		reset
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> drawable [
	"Checks if the drawing area is ready to be drawn on"

	self isRealized
		ifTrue: [^self drawingArea window]
		ifFalse: [^self screen rootWindow]
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> drawDisks [
	
	1 to: pegs size do: [:s | 
		1 to: (pegs at: s) size do: [:x | 
			| peg |
			peg := (pegs at: s).
			self 
				createDiskX:  ((s * 125) - ((((peg at: x) width) / 2) asInteger))
				y:  229 - (x * 20)
				width:  ((peg at: x) width)
				height: 20
				color: (colors at: ((peg at: x) number))]].
		

	
		
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> drawingArea [
	"Answer the drawing area widget."

	^self workRegion
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> drawRect: r [
	"Draw the rectangle outline r."

	self drawable
		drawRectangle: self gc
		x: r origin x
		y: r origin y
		width: r width
		height: r height
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> drawText: textItems at: aPoint [

	self drawable
		drawText: self gc
		x: aPoint x
		y: aPoint y
		items: textItems
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> fillRect: r [
	"Fill the rectangle r."

	self drawable
		fillRectangle: self gc
		x: r origin x
		y: r origin y
		width: r width
		height: r height.
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> foreground: anInteger [
	"Set the foreground colour to anInteger."

	self gc
		setForeground: anInteger
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> function: anInteger [
	"Set the combination function to anInteger."

	self gc
		setFunction: anInteger
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> gc [
	"Answer the CgGC to use for the test."

	^gc
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> gray [
	"Color Gray"
	
	^ shell window getPalette 
		nearestPixelValue: Color gray.
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> green [
	"Color Green"
	
	^ shell window getPalette 
		nearestPixelValue: Color green.
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> initializeGraphics [
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
TowerOfHanoiWindow >> initializePegs [
	
	| peg1 peg2 peg3 startingWidth |
	
	startingWidth := 120.
	
	"create rod collections"
	peg1:= OrderedCollection new.
	peg2:= OrderedCollection new.
	peg3:= OrderedCollection new.
	
	"add the rods to the collection of rods"
	pegs := OrderedCollection new.
	pegs add: peg1; add: peg2; add: peg3.
	
	"create and add the disks to the starting rod"
	1 to: diskCount do: [:num | 
		| disk w|
		w := startingWidth - ((75 * (num / diskCount)) asInteger).
		disk := TowerOfHanoiDisk new.
		disk number: num width: w color: (colors at: num).
		(pegs at: start) add: disk]

	
	
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> isRealized [
	"Answer a Boolean indicating whether the
	 drawing area widget has been realized."

	| widget |

	^(widget := self drawingArea) notNil
		and: [widget isRealized]
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> lightestGray [
	"Background color for a cleared drawingArea"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 240 green: 240 blue: 240).
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> lightGray [
	"Answer the red pixel value."

	^ shell window getPalette 
		nearestPixelValue: Color lightGray.
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> mainWindowArgs [
	"Answer an argBlock containing some default width and height settings."

	^[:w | w width: 500; height: 365]
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> messageStartEqualEnd: ablock switchPeg: switch data: data [

	(CwMessagePrompter 
		confirm: 'Change ', switch, '?'
		title: 'Start and end pegs cannot be the same')
			ifTrue: [
				ablock value: data].
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> moveDiskFrom: fromPeg to: toPeg [
	
	"Add top disk from the 'fromRod' to 'toRod'"
	(pegs at: toPeg) add: ((pegs at: fromPeg) last).
	
	"Remove the disk that was moved from the 'fromRod'"
	(pegs at: fromPeg) removeLast.
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> open [
	"Set all the initial parameters and reset the graphics"

	super open.
	
	self 
		setDiskCount;
		setStartAndEnd;
		setColors;
		setMoves;
		setRunning;
		reset
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> orange [
	"Color Orange"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 255 green: 153 blue: 0).
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> pegMenuClick1: aButton clientData: clientData callData: callData [

				
	(clientData = end)
		ifTrue: [
			self
				messageStartEqualEnd:
					[:x | 
						start := x.
						end := (start \\ 3) + 1]
				switchPeg: 'end peg'
				data: clientData]
		ifFalse: [start := clientData].
		
		self
			clear;
			reset
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> pegMenuClick2: aButton clientData: clientData callData: callData [

						
	(clientData = start)
		ifTrue: [
			self
				messageStartEqualEnd:
					[:x | 
						end := x.
						start := (end \\ 3) + 1]
				switchPeg: 'start peg'
				data: clientData]
		ifFalse: [end := clientData].
		
		self
			clear;
			reset

]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> pink [
	"Color Pink"
	
	^ shell window getPalette 
		nearestPixelValue: Color pink.
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> PlayAnimation: value [
	
	CwAppContext default
		addTimeout: 100 
		receiver:  self
		selector:  #workProc:
		clientData: nil.
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> pressed: aButton clientData: clientData callData: callData [
	
	"Step forward"
	((clientData = '>') & (currentMove <= (moves size)))
		ifTrue: [
			self 
				moveDiskFrom: ((moves at: currentMove) first) to: ((moves at: currentMove) last);
				updateGraphics.
			currentMove := (currentMove + 1)].
			
	"Step all the way to the end"
	((clientData = '>>') & (currentMove <= (moves size)))
		ifTrue: [
			currentMove to: (moves size) do: [:x |
				self moveDiskFrom: ((moves at: currentMove) first) to: ((moves at: currentMove) last).
				currentMove := (currentMove + 1)].
			self updateGraphics].
			
	"Step backward"
	((clientData = '<') & (currentMove > 1))
		ifTrue: [
			currentMove := (currentMove - 1).
			self 
				moveDiskFrom: ((moves at: currentMove) last) to: ((moves at: currentMove) first);
				updateGraphics].
	
	"Step all the way back to the beginning"
	((clientData = '<<') & (currentMove > 1))
		ifTrue: [
			1 to: (currentMove - 1) do: [:x |
				currentMove := (currentMove - 1).
				self moveDiskFrom: ((moves at: currentMove) last) to: ((moves at: currentMove) first)].
				self updateGraphics].
				
	"Start animation"
	(clientData = 'PLAY')
		ifTrue: [
			running
				ifTrue: [
					running := false.
					aButton labelString: 'PLAY'.
					self stop]
				ifFalse: [
					running := true.
					aButton labelString: 'STOP'.
					self animation: aButton].
		].
	
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> red [
	"Color Red"
	
	^ shell window getPalette 
		nearestPixelValue: Color red.
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> reset [

	self
		initializePegs;
		"solve and add each move to moves"
		setMoves;
		solveHanoiDisk: diskCount fromPeg: start toPeg: end;
		"draw initial pegs and disks"
		createPegs;
		drawDisks.
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> setColors [

	| colorList |
	
	colorList := OrderedCollection new
		add: self blue; 
		add: self green; 
		add: self yellow;
		add: self orange;
		add: self red;
		add: self white;
		yourself.
		
	colors := colorList.
	
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> setDiskCount [

	"Max 6"
	diskCount := 6.
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> setMoves [

	moves := OrderedCollection new.
	currentMove := 1.
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> setRunning [

	running := false.
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> setStartAndEnd [
	"Both values must be 1 - 3 inclusive"
	start := 1.
	end := 2.
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> shellName [
	"Answer the name of the receiver's shell.
	This is used as the default label of the window."

	^'Tower of Hanoi - Lee Clayberg'
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> solveHanoiDisk: count fromPeg: from toPeg: to [

	(count = 0)
		ifTrue: [
			^true]
		ifFalse: [
			| spare newMove|
			
			"find the spare peg"
			spare := self sparePegFrom: from To: to.
			
			"move all but bottom disk to spare peg"
			self solveHanoiDisk: (count - 1) fromPeg: from toPeg: spare.
				"add move to the list of moves"
				newMove := OrderedCollection new.
				newMove add: from; add: to.
				moves add: newMove.
			"move all but bottom disk to final peg"
			self solveHanoiDisk: (count - 1) fromPeg: spare toPeg: to]
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> sparePegFrom: fromPeg To: toPeg [

	| possiblePegs |
	
	"add the possible peg numbers to the collection"
	possiblePegs := OrderedCollection new.
	possiblePegs add: 1; add: 2; add: 3.
	
	"removes the two pegs being used"
	possiblePegs 
		remove: fromPeg;
		remove: toPeg.
		
	"returns the one peg left in the collection"
	^possiblePegs first
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> step [

	(currentMove <= (moves size))
		ifTrue: [
			self 
				moveDiskFrom: ((moves at: currentMove) first) to: ((moves at: currentMove) last);
				updateGraphics.
			currentMove := (currentMove + 1)].
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> stop [
	"Stop the animation."

	running
		ifTrue: [running := false]
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> TextItem: aString [

	^CgTextItem new
		chars: aString;
		delta: 0;
		font: 0
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> updateGraphics [

	"clears and re-draws the disks in the new positions"
	self 
		clear;
		createPegs;
		drawDisks.
		

]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> white [
	"Color White"
	
	^ shell window getPalette 
		nearestPixelValue: Color  white.
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> workProc: value [
	
	|x|
	running ifFalse: [^true].
	x := Delay new.
	x delayTime: 1.
	self step.
	^false
]

{ #category : 'Not categorized' }
TowerOfHanoiWindow >> yellow [
	"Color Yellow"
	
	^ shell window getPalette 
		nearestPixelValue: Color yellow.
]
