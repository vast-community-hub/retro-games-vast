Class {
	#name : 'LightCyclesWindow',
	#superclass : 'WidgetApplication',
	#instVars : [
		'gc',
		'gcValues',
		'drawingArea',
		'gridWidth',
		'gridHeight',
		'board',
		'positions',
		'directions',
		'colors',
		'trails',
		'alive',
		'length',
		'trailPoints',
		'running',
		'pressed',
		'enemyCount',
		'lives',
		'speeds',
		'timerProcId',
		'points',
		'counts',
		'cyclesStart',
		'cyclesEnd',
		'round',
		'endAnimation',
		'endPosition',
		'endTimer'
	],
	#pools : [
		'CgConstants'
	],
	#category : 'LightCycles'
}

{ #category : 'Not categorized' }
LightCyclesWindow >> addCurrentSegments [

	cyclesStart to: cyclesEnd do: [:w |
		(alive at: w)
			ifTrue: [| pos |
				pos := (positions at: w).
				(((1 to: gridWidth) includes: (pos x)) & ((1 to: gridHeight) includes: (pos y)))
					ifTrue: [
						(((board at: (pos y)) at: (pos x)) = 0)
							ifTrue: [
								(board at: (pos y)) at: (pos x) put:(positions indexOf: pos)]
							ifFalse: [
								(self destroyEnemyNum: (positions indexOf: pos))
									ifTrue: [^self]]]
					ifFalse: [
						(self destroyEnemyNum: (positions indexOf: pos))
							ifTrue: [^self]]]].
]

{ #category : 'Not categorized' }
LightCyclesWindow >> addLabelsMenu: menu label: label data: data selector: selector [

	"Adds the item to the given menu"
	
	self
		addMenuEntryTo: menu 
		label: label
		selector: selector
		clientData: data.
]

{ #category : 'Not categorized' }
LightCyclesWindow >> allEnemiesDead [

	1 to: enemyCount do: [:s |
		((alive at: (s + 1)) = true)
			ifTrue: [^false]].	
	^true
]

{ #category : 'Not categorized' }
LightCyclesWindow >> background: anInteger [

	"Set the background colour to anInteger."

	self gc
		setBackground: anInteger
]

{ #category : 'Not categorized' }
LightCyclesWindow >> black [

	"Black Color"
	
	^ shell window getPalette 
		nearestPixelValue: Color black. 
		
]

{ #category : 'Not categorized' }
LightCyclesWindow >> blue [
	"Color Blue"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 51 green: 0 blue: 255).
]

{ #category : 'Not categorized' }
LightCyclesWindow >> changeLineWidth: w [
	
	gcValues lineWidth = w
		ifFalse:[
			gcValues lineWidth: w.
			self gc
				changeGC: GCLineWidth
				values: gcValues].
	
]

{ #category : 'Not categorized' }
LightCyclesWindow >> checkAroundNum: num [

	| xVal yVal |
	xVal := ((positions at: num) x).
	yVal := ((positions at: num) y).

	((xVal > 1) & (yVal > 1))
		ifTrue: [
			((((board at:(yVal - 1)) at: (xVal - 1)) = 1) 
			& ((((board at:(yVal - 1)) at: xVal) >= 2)
			& (((board at:yVal) at: (xVal - 1)) = 0)))
				ifTrue: [^false].
			((((board at:(yVal - 1)) at: (xVal - 1)) = 1) 
			& ((((board at:(yVal - 1)) at: xVal) = 0)
			& (((board at:yVal) at: (xVal - 1)) >= 2)))
				ifTrue: [^false]].
	((xVal < gridWidth) & (yVal > 1))
		ifTrue: [
			((((board at:(yVal - 1)) at: (xVal + 1)) = 1) 
			& ((((board at:(yVal - 1)) at: xVal) >= 2)
			& (((board at:yVal) at: (xVal + 1)) = 0)))
				ifTrue: [^false].
			((((board at:(yVal - 1)) at: (xVal + 1)) = 1) 
			& ((((board at:(yVal - 1)) at: xVal) = 0)
			& (((board at:yVal) at: (xVal + 1)) >= 2)))
				ifTrue: [^false]].
	((xVal > 1) & (yVal < gridHeight))
		ifTrue: [
			((((board at:(yVal + 1)) at: (xVal - 1)) = 1) 
			& ((((board at:(yVal + 1)) at: xVal) >= 2)
			& (((board at:yVal) at: (xVal - 1)) = 0)))
				ifTrue: [^false].
			((((board at:(yVal + 1)) at: (xVal - 1)) = 1) 
			& ((((board at:(yVal + 1)) at: xVal) = 0)
			& (((board at:yVal) at: (xVal - 1)) >= 2)))
				ifTrue: [^false]].
	((xVal < gridWidth) & (yVal < gridHeight))
		ifTrue: [
			((((board at:(yVal + 1)) at: (xVal + 1)) = 1) 
			& ((((board at:(yVal + 1)) at: xVal) >= 2)
			& (((board at:yVal) at: (xVal + 1)) = 0)))
				ifTrue: [^false].
			((((board at:(yVal + 1)) at: (xVal + 1)) = 1) 
			& ((((board at:(yVal + 1)) at: xVal) = 0)
			& (((board at:yVal) at: (xVal + 1)) >= 2)))
				ifTrue: [^false]].
				
	^true
					
				
							
				
							
				
				
						
							
							
						
]

{ #category : 'Not categorized' }
LightCyclesWindow >> checkInLine: num [

	| distance xMax yMax range1 range2 |
		
	range1 := ((((positions at: 1) x) - 1) to: (((positions at: 1) x) + 1)).
	range2 := ((((positions at: 1) y) - 1) to: (((positions at: 1) y) + 1)).
	
	xMax := ((positions at: 1) x) max: ((positions at: num) x).
	yMax := ((positions at: 1) y) max: ((positions at: num) y).
	
	"More Extreme"
	((range1 includes: ((positions at: num) x)) & (((directions at: num) y) = 0) & ((directions at: num) = ((directions at: 1) * -1)))
		ifTrue: [
			distance := ((((positions at: num) y) - ((positions at: 1) y)) abs).
			1 to: (distance - 1) do: [:a |
				(((board at: (yMax - a)) at: ((positions at: num) x)) ~= 0)
					ifTrue: [^true]].
			^false].
	
	((range2 includes: ((positions at: num) y)) & (((directions at: num) x) = 0) & ((directions at: num) = ((directions at: 1) * -1)))
		ifTrue: [
			distance := ((((positions at: num) x) - ((positions at: 1) x)) abs).
			1 to: (distance - 1) do: [:a |
				(((board at: ((positions at: num) y)) at: (xMax - a)) ~= 0)
					ifTrue: [^true]].
			^false].
			
	^true
]

{ #category : 'Not categorized' }
LightCyclesWindow >> checkRowNum: num [
	
	(((directions at: num) x) = 0)
		ifTrue: [
			1 to: (enemyCount + 1) do: [:a |
				((((positions at: a) x) = ((positions at: num) x)) 
				& (((((positions at: a) y) - ((positions at: num) y)) abs) < 4)
				& (a ~= (positions at: num))
				& ((directions at: a) = ((directions at: num) * -1)))
					ifTrue: [^false]].
			^true]
		ifFalse: [
			1 to: (enemyCount + 1) do: [:a |
				((((positions at: a) y) = ((positions at: num) y)) 
				& (((((positions at: a) x) - ((positions at: num) x)) abs) < 4)
				& (a ~= (positions at: num))
				& ((directions at: a) = ((directions at: num) * -1)))
					ifTrue: [^false]].
			^true]
]

{ #category : 'Not categorized' }
LightCyclesWindow >> createPulldownMenus [
	"Create the pulldown menus"

	| menu1 |
		
	"Create highscore menu and add highscore to the menu"
	menu1 := (self addPulldownMenu: 'File') subMenuId.
	self addLabelsMenu: menu1 label: 'Reset' data: 'Reset' selector: #MenuClick:clientData:callData:
]

{ #category : 'Not categorized' }
LightCyclesWindow >> createWorkRegion [

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
			width: 550;
			height: 550].
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
LightCyclesWindow >> darkBlue [
	"Color Blue"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 0 green: 0 blue: 51).
]

{ #category : 'Not categorized' }
LightCyclesWindow >> darkGreen [

	"Color Dark Green"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 0 green: 51 blue: 51)
]

{ #category : 'Not categorized' }
LightCyclesWindow >> destroy: widget clientData: clientData callData: callData [
	"The drawing area has been destroyed."

	"Remove the timerProc."
	self removeTimeout.
	"Free the color and GC."
	self gc freeGC
]

{ #category : 'Not categorized' }
LightCyclesWindow >> destroyEnemyNum: num [

	(num > 1)
		ifTrue: [
			1 to: (board size) do: [:q |
				1 to: ((board at: q) size) do: [:w |
					(((board at: q) at: w) = num)
						ifTrue: [(board at: q) at: w put: 0]]].
			endPosition at: num put: ((positions at: num) - (directions at: num)).
			positions at: num put: -4@-4.
			alive at: num put: false.
			points := points + 250.
			(self allEnemiesDead)
				ifTrue: [
					endTimer := endTimer + 1.
					^true]]
		ifFalse: [
			endPosition at: 1 put: ((positions at: 1) - (directions at: 1)).
			positions at: num put: -4@-4.
			alive at: 1 put: false.
			endTimer := endTimer + 1.
			^true].
		
		self drawTopX: 0 y: 0.
				
		^false
]

{ #category : 'Not categorized' }
LightCyclesWindow >> drawable [

	"Checks if the drawing area is ready to be drawn on"

	self isRealized
		ifTrue: [^self drawingArea window]
		ifFalse: [^self screen rootWindow]
]

{ #category : 'Not categorized' }
LightCyclesWindow >> drawBackgroundX: xVal y: yVal [
			
	| r |
	r := xVal@yVal extent: (gridWidth * 10)@(gridHeight * 10).
	self
		foreground: (self darkBlue);
		fillRect: r.
		
	self changeLineWidth: 4.

	self foreground: (self black).
	1 to: ((gridWidth / 5) - 1) do: [:k |
		self drawLineStartPoint: (xVal + (k * 50))@yVal EndPoint: (xVal + (k * 50))@(yVal + (gridHeight * 10))].
		
	1 to: ((gridHeight / 5) - 1) do: [:k |
		self drawLineStartPoint: xVal@(yVal + (k * 50)) EndPoint: (xVal + (gridWidth * 10))@(yVal + (k * 50))].
	
]

{ #category : 'Not categorized' }
LightCyclesWindow >> drawBoardX: xVal y: yVal [

	| a b c d |
	
	self drawBackgroundX: (xVal + 20) y: (yVal + 60).
		
	a := xVal@(yVal + 40) extent: 20@((gridHeight * 10) + 60).
	b := (xVal + 20 + (gridHeight * 10))@(yVal + 40) extent: 20@((gridHeight * 10) + 60).
	c := xVal@(yVal + 40) extent: ((gridHeight * 10) + 40)@20.
	d := xVal@(yVal + 60 + (gridHeight * 10)) extent: ((gridHeight * 10) + 40)@40.
	
	self
		foreground: (self lightBorder);
		fillRect: a; fillRect: b; fillRect: c; fillRect: d.
		
	self
		drawTrailsX: (xVal + 20) y: (yVal + 60);
		drawCyclesX: (xVal + 20) y: (yVal + 60);
		drawExplosionsX: (xVal + 20) y: (yVal + 60)
]

{ #category : 'Not categorized' }
LightCyclesWindow >> drawCycleNumber: num x: xCorner y: yCorner [

	| xVal yVal xDir yDir colr extra a b c d e f g h |
	
	xVal := (((positions at: num) x) - 1) * 10 + xCorner.
	yVal := (((positions at: num) y) - 1) * 10 + yCorner.
	xDir := ((directions at: num) x).
	yDir := ((directions at: num) y).
	colr := colors at: num.
	
	(yDir > 0 or: [xDir > 0])
		ifTrue: [extra := 1]
		ifFalse: [extra := 0].
	
	(yDir ~= 0)
		ifTrue: [
			yVal := yVal + (yDir * 5).
			a := (xVal - 3)@(yVal - (extra * 26) + (yDir * 8)) extent: 16@26.
			b := (xVal - 2)@(yVal - (extra * 10) + (yDir * 12)) extent: 14@10.
			c := (xVal - 1)@(yVal - (extra * 20) + (yDir * 6)) extent: 12@20.
			d := (xVal + 1)@(yVal - (extra * 14) + (yDir * 8)) extent: 8@14.
			e := (xVal + 2)@(yVal - (extra * 15) + (yDir * 7)) extent: 6@15.
			f := (xVal)@(yVal - (extra * 6) + (yDir * 10)) extent: 10@6.
			g := (xVal + 3)@(yVal - (extra * 3) - (yDir * 8)) extent: 4@3.
			h := (xVal + 3)@(yVal - (extra * 3) + (yDir * 8)) extent: 4@3].
			
	(xDir ~= 0)
		ifTrue: [
			xVal := xVal + (xDir * 5).
			a := (xVal - (extra * 26) + (xDir * 8))@(yVal - 3) extent: 26@16.
			b := (xVal - (extra * 10) + (xDir * 12))@(yVal - 2) extent: 10@14.
			c := (xVal - (extra * 20) + (xDir * 6))@(yVal - 1) extent: 20@12.
			d := (xVal - (extra * 14) + (xDir * 8))@(yVal + 1) extent: 14@8.
			e := (xVal - (extra * 15) + (xDir * 7))@(yVal + 2) extent: 15@6.
			f := (xVal - (extra * 6) + (xDir * 10))@(yVal) extent: 6@10.
			g := (xVal - (extra * 3) - (xDir * 8))@(yVal + 3) extent: 3@4.
			h := (xVal - (extra * 3) + (xDir * 8))@(yVal + 3) extent: 3@4].
	
	self
		foreground: colr;
		fillCircle: a;
		fillCircle: b;
		foreground: (self black);
		fillCircle: c;
		foreground: colr;
		fillRect: d;
		foreground: (self black);
		fillRect: e;
		fillCircle: f;
		foreground: colr;
		fillRect: g;
		fillCircle: h

	
]

{ #category : 'Not categorized' }
LightCyclesWindow >> drawCyclesX: xVal y: yVal [

	1 to: (enemyCount + 1) do: [:w | self drawCycleNumber: w x: xVal y: yVal].
]

{ #category : 'Not categorized' }
LightCyclesWindow >> drawExplosionNewX: xVal y: yVal frame: frame [

	| rects yellow|
	
	rects := OrderedCollection new.
	rects 
		"Red"
		add: (11@5 extent: 5@2); add: (4@9 extent: 2@2); add: (16@8 extent: 3@2); add: (21@7 extent: 2@2);
		add: (19@10 extent: 2@2); add: (8@11 extent: 3@2); add: (25@12 extent: 2@2); add: (6@13 extent: 2@2);
		add: (21@14 extent: 2@3); add: (2@15 extent: 2@2); add: (10@17 extent: 2@2); add: (19@17 extent: 2@2);
		add: (23@18 extent: 2@2); add: (7@19 extent: 3@2); add: (16@22 extent: 3@2);
		"Orange"
		add: (11@7 extent: 5@2); add: (6@9 extent: 2@2); add: (21@10 extent: 2@2); add: (23@12 extent: 2@2);
		add: (4@15 extent: 2@2); add: (7@17 extent: 3@2); add: (16@20 extent: 3@2).
		
	yellow := OrderedCollection new.
	yellow add: 6@11; add: 11@11; add: 11@8; add: 21@8; add: 21@11; add: 23@11; add: 23@19;
		add: 19@19; add: 19@20; add: 16@20; add: 16@19; add: 12@19; add: 12@21; add: 8@21;
		add: 8@17; add: 6@17.
		
	yellow := yellow	collect: [:m | ((m x) + xVal - 15)@((m y) + yVal - 15)].
	rects := rects collect: [:m | 
		(((m origin) x) + xVal - 15)@(((m origin) y) + yVal - 15) extent: (m width)@(m height)].
	
	self 
		foreground: (self yellow);
		fillPolygon: yellow.
	1 to: 15 do: [:a | self foreground: (self red); fillRect: (rects at: a)].
	16 to: (rects size) do: [:a | self foreground: (self orange); fillRect: (rects at: a)].
	
]

{ #category : 'Not categorized' }
LightCyclesWindow >> drawExplosionsX: xVal y: yVal [

	1 to: (enemyCount + 1) do: [:w | 
		(((alive at: w) = false) & ((endAnimation at: w) <=3))
			ifTrue: [
				self drawExplosionNewX: (((((endPosition at: w) x) - 1) * 10) + xVal)
					y: (((((endPosition at: w) y) - 1) * 10) + yVal)
					frame: (endAnimation at: w).
				endAnimation at: w put: ((endAnimation at: w) + 1).]].
]

{ #category : 'Not categorized' }
LightCyclesWindow >> drawExplosionX: xVal y: yVal frame: frame [

	| oneR oneL colr1 colr2 outer inner |
	
	outer := OrderedCollection new.
	outer add: 0@0; add: 12@10; add: 12@2; add:15@0; add: 21@10; add: 28@3; add: 22@14; add: 30@15; add: 22@20; 
		add: 26@29; add: 17@23; add: 15@30; add: 9@22; add: 1@30; add: 4@18; add: 0@13; add: 6@12.
	inner := OrderedCollection new.
	inner add: 2@2; add: 12@12; add: 12@4; add:15@2; add: 19@12; add: 28@5; add: 20@16; add: 28@15; add: 20@20; 
		add: 24@27; add: 15@21; add: 15@28; add: 9@20; add: 3@28; add: 6@18; add: 2@13; add: 8@13.
	
	(frame = 1)
		ifTrue: [
			colr1 := (self orange).
			colr2 := (self lightOrange).
			outer := outer collect: [:m | ((((m x) * (0.6)) asInteger) + 6)@((((m y) * (0.6)) asInteger) + 6)].
			inner := inner collect: [:m | ((((m x) * (0.6)) asInteger) + 6)@((((m y) * (0.6)) asInteger) + 6)].
		].
	(frame = 2)
		ifTrue: [
			colr1 := (self red).
			colr2 := (self orange).
		].
	(frame = 3)
		ifTrue: [
			colr1 := (self orange).
			colr2 := (self lightOrange).
			outer := outer collect: [:m | ((((m x) * (0.8)) asInteger) + 6)@((((m y) * (0.6)) asInteger) + 3)].
			inner := inner collect: [:m | ((((m x) * (0.8)) asInteger) + 6)@((((m y) * (0.6)) asInteger) + 3)].
		].

	outer := outer collect: [:m | ((m x) + xVal - 15)@((m y) + yVal - 15)].
	inner := inner collect: [:m | ((m x) + xVal - 15)@((m y) + yVal - 15)].	
	self
		foreground: colr1;
		fillPolygon: outer;
		foreground: colr2;
		fillPolygon: inner.
]

{ #category : 'Not categorized' }
LightCyclesWindow >> drawingArea [

	"Answer the drawing area widget."

	^self workRegion
]

{ #category : 'Not categorized' }
LightCyclesWindow >> drawLetterX: xVal y: yVal let: let [

	| r o u n d ready |
	
	r := OrderedCollection new.
	r add: 0@0; add: 0@24; add: 6@24; add: 6@15; add: 15@15; add: 15@24; add: 18@24; add: 18@12;
		add: 15@12; add: 15@0; add: 3@0; add: 3@3; add: 12@3; add: 12@12; add: 3@12; add: 3@0.
	o := OrderedCollection new.
	o add: 0@0; add: 0@24; add: 18@24; add: 18@0; add: 3@0; add: 3@3; add: 12@3; add: 12@6;
		add: 15@6; add: 15@21; add: 3@21; add: 3@0.
	u := OrderedCollection new.
	u add: 0@0; add: 0@24; add: 18@24; add: 18@0; add: 15@0; add: 15@21; add: 6@21;
		add: 6@12; add: 3@12; add: 3@0.
	n := OrderedCollection new.
	n add: 0@0; add: 0@24; add: 6@24; add: 6@12; add: 3@12; add: 3@3; add: 15@3; add: 15@24;
		add: 18@24; add: 18@0.
	d := OrderedCollection new.
	d add: 0@0; add: 0@24; add: 18@24; add: 18@0; add: 3@0; add: 3@3; add: 15@3; add: 15@21; 
		add: 6@21; add: 6@12; add: 3@12; add: 3@0.
	
	self foreground: (self lightBorder).
	(let = 'r') ifTrue: [ready := r].
	(let = 'o') ifTrue: [ready := o].
	(let = 'u') ifTrue: [ready := u].
	(let = 'n') ifTrue: [ready := n].
	(let = 'd') ifTrue: [ready := d].
	
		
		
	ready := ready collect: [:m | ((m x) + xVal)@((m y) + yVal)].
	self fillPolygon: ready
]

{ #category : 'Not categorized' }
LightCyclesWindow >> drawLifeX: xVal y: yVal [

	| a b c d e f g h |
	
	a := (xVal + 10)@yVal extent: 6@18.
	b := (xVal + 7)@(yVal + 6) extent: 12@3.
	c := (xVal + 4)@(yVal + 9) extent: 3@3.
	d := (xVal + 19)@(yVal + 9) extent: 3@3.
	e := (xVal + 7)@(yVal + 15) extent: 3@9.
	f := (xVal + 16)@(yVal + 15) extent: 3@9.
	g := (xVal + 4)@(yVal + 21) extent: 3@3.
	h := (xVal + 19)@(yVal + 21) extent: 3@3.
	
	self
		foreground: (self lightBorder);
		fillRect: a;
		fillRect: b;
		fillRect: c;
		fillRect: d;
		fillRect: e;
		fillRect: f;
		fillRect: g;
		fillRect: h
]

{ #category : 'Not categorized' }
LightCyclesWindow >> drawLineStartPoint: startPoint EndPoint: endPoint [
	
	"Draws a line"

	self drawable
		drawLine: self gc
		x1: startPoint x
		y1: startPoint y
		x2: endPoint x
		y2: endPoint y
	
]

{ #category : 'Not categorized' }
LightCyclesWindow >> drawLivesX: xVal y: yVal [

	1 to: lives do: [:k | self drawLifeX: (30 + ((k - 1) * 25)) y: 8].
]

{ #category : 'Not categorized' }
LightCyclesWindow >> drawNumberX: xVal y: yVal num: num [

	| a b c d e f g h i j ready |
	
	a := OrderedCollection new.
	a add: 0@0; add: 0@24; add: 18@24; add: 18@0; add: 3@0; add: 3@3; 
		add: 15@3; add: 15@18; add: 12@18; add: 12@21; add: 3@21; add: 3@0.	
	b := OrderedCollection new.
	b add: 12@24; add: 12@9; add: 15@9; add: 15@0; add: 18@0; add: 18@24.
	c := OrderedCollection new.
	c add: 0@0; add: 0@6; add: 3@6; add: 3@3; add: 15@3; add: 15@9; add: 0@9; add: 0@24; add: 18@24;
		add: 18@18; add: 15@18; add: 15@21; add: 6@21; add: 6@12; add: 18@12; add: 18@0.		
	d := OrderedCollection new.
	d add: 0@0; add: 0@3; add: 12@3; add: 12@6; add: 9@6; add: 9@9; add: 12@9; add: 12@21; add: 3@21;
		add: 3@18; add: 0@18; add: 0@24; add: 18@24; add: 18@6; add: 15@6; add: 15@0.
	e := OrderedCollection new.
	e add: 0@0; add: 0@15; add: 9@15; add: 9@24; add: 15@24; add: 15@15; add: 18@15; add: 18@12;
		add: 15@12; add: 15@0; add: 3@0; add: 3@3; add: 12@3; add: 12@12; add: 3@12; add: 3@0.
	f := OrderedCollection new.
	f add: 0@0; add: 0@12; add: 12@12; add: 12@21; add: 3@21; add: 3@18; add: 0@18; add: 0@24;
		add: 18@24; add: 18@9; add: 3@9; add: 3@3; add: 18@3; add: 18@0.
	g := OrderedCollection new.
	g add: 0@0; add: 0@24; add: 18@24; add: 18@12; add: 12@12; add: 12@21; add: 3@21; add: 3@15;
		add: 12@15; add: 12@12; add: 3@12; add: 3@3; add: 15@3; add: 15@6; add: 18@6; add: 18@0.		
	h := OrderedCollection new.
	h add: 0@0; add: 0@3; add: 15@3; add: 15@9; add: 12@9; add: 12@24; add: 18@24; add: 18@0.
	i := OrderedCollection new.
	i add: 3@0; add: 3@9; add: 0@9; add: 0@24; add: 18@24; add: 18@9; add: 15@9; add: 15@0; add: 6@0;
		add: 6@0; add: 6@3; add: 12@3; add: 12@9; add: 6@9; add: 6@12; add: 12@12; add: 12@21;
		add: 3@21; add: 3@12; add: 6@12; add: 6@0.
	j := OrderedCollection new.
	j add: 0@0; add: 0@15; add: 12@15; add: 12@24; add: 18@24; add: 18@0; add: 3@0; add: 3@3; 
		add: 15@3; add: 15@12; add: 3@12; add: 3@0.
	
	self foreground: (self lightBorder).
	(num = 0) ifTrue: [ready := a].
	(num = 1) ifTrue: [ready := b].
	(num = 2) ifTrue: [ready := c].
	(num = 3) ifTrue: [ready := d].
	(num = 4) ifTrue: [ready := e].
	(num = 5) ifTrue: [ready := f].
	(num = 6) ifTrue: [ready := g].
	(num = 7) ifTrue: [ready := h].
	(num = 8) ifTrue: [ready := i].
	(num = 9) ifTrue: [ready := j].
	
		
		
	ready := ready collect: [:m | ((m x) + xVal)@((m y) + yVal)].
	self fillPolygon: ready
]

{ #category : 'Not categorized' }
LightCyclesWindow >> drawPointsX: xVal y: yVal [

	| str current piece power|
	
	current := points.
	str := (current printString).
	
	1 to: (str size) do: [:a |
		power := (10 raisedTo: ((str size) - a)).
		piece := ((current / power) floor).
		current := (current - (power * piece)).
		self drawNumberX: (xVal - (((str size) - a) * 24)) y: yVal num: piece].
	
	
]

{ #category : 'Not categorized' }
LightCyclesWindow >> drawRoundX: xVal y: yVal [

	| str current piece power roundText xPos |
	
	current := round.
	str := (current printString).
	
	xPos := xVal - (((24 * (5 + (str size))) + 12) / 2).
	
	roundText := OrderedCollection 
		with: 'r' with: 'o' with: 'u' with: 'n' with: 'd'.
	1 to: (roundText size) do: [:s |
		self drawLetterX: (xPos + (s * 24)) y: yVal let: (roundText at: s)].
	
	1 to: (str size) do: [:a |
		power := (10 raisedTo: ((str size) - a)).
		piece := ((current / power) floor).
		current := (current - (power * piece)).
		self drawNumberX: (xPos + 132 + (a * 24)) y: yVal num: piece].
	
	
]

{ #category : 'Not categorized' }
LightCyclesWindow >> drawText: textItems at: aPoint [

	"Draw the text at the given point"

	self drawable
		drawText: self gc
		x: aPoint x
		y: aPoint y
		items: textItems
]

{ #category : 'Not categorized' }
LightCyclesWindow >> drawTopX: xVal y: yVal [

	| block |
	block := xVal@yVal extent: ((gridHeight * 10) + 40)@40.
	self	
		foreground: (self black);
		fillRect: block;
		"foreground: (self blue);
		drawText: text at: 255@25;"
		drawLivesX: xVal y: yVal;
		drawPointsX: 540 y: 8;
		drawRoundX: 275 y: 8
]

{ #category : 'Not categorized' }
LightCyclesWindow >> drawTrailsX: xVal y: yVal [

	1 to: (enemyCount + 1) do: [:w |
		
		(alive at: w)
			ifTrue: [
				(trailPoints at: w) add: (positions at: w).
				self foreground: (trails at: w).
				1 to: (((trailPoints at: w) size) - 1) do: [:g |
					| point1 point2 |
					point1 := (((((trailPoints at: w) at: g) - (1@1)) * 10) + ((xVal + 5)@(yVal + 5))).
					point2 := (((((trailPoints at: w) at: (g + 1)) - (1@1)) * 10) + ((xVal + 5)@(yVal + 5))).	
					self drawLineStartPoint: point1 EndPoint: point2].
				(trailPoints at: w) removeLast]].
		
		
		

]

{ #category : 'Not categorized' }
LightCyclesWindow >> enemyChangeDirection [

	2 to: (enemyCount + 1) do: [:r |
		| posCurr posNext posCheck dirCheck closest left right a b |
		posCurr := (positions at: r).
		posNext := posCurr + (directions at: r).
		
		left := ((directions at: r) y)@((directions at: r) x).
		right := left * (-1).
		a := (((((posCurr + left) x) - ((positions at: 1) x)) squared) + ((((posCurr + left) y) - ((positions at: 1) y)) squared)) sqrt.
		b := (((((posCurr + right) x) - ((positions at: 1) x)) squared) + ((((posCurr + right) y) - ((positions at: 1) y)) squared)) sqrt.
		(a < b)
			ifTrue: [closest := 1] 
			ifFalse: [closest := -1].
		
		(((1 to: gridWidth) includes: (posNext x)) and: [(1 to: gridHeight) includes: (posNext y)])
			ifTrue: [
				((((((board at: (posNext y)) at:(posNext x)) = 0) and: [self checkRowNum: r]) and: [self checkAroundNum: r]) and: [self checkInLine: r])
					ifTrue: ["Next Enemy"]
					ifFalse: [
						dirCheck := (((directions at: r) y)@((directions at: r) x) * closest).
						posCheck := posCurr + dirCheck.
						(((1 to: gridWidth) includes: (posCheck x)) and: [(1 to: gridHeight) includes: (posCheck y)])
							ifTrue: [
								(((board at: (posCheck y)) at:(posCheck x)) = 0)
									ifTrue: [
										directions at: r put: dirCheck.
										(trailPoints at: r) add: (positions at: r).]
									ifFalse: [
										directions at: r put: (dirCheck * (-1)).
										(trailPoints at: r) add: (positions at: r).]]
							ifFalse: [
								directions at: r put: (dirCheck * (-1)).
								(trailPoints at: r) add: (positions at: r).]]]
			ifFalse: [
				dirCheck := ((((directions at: r) y)@((directions at: r) x)) * closest).
				posCheck := posCurr + dirCheck.
				(((1 to: gridWidth) includes: (posCheck x)) and: [(1 to: gridHeight) includes: (posCheck y)])
					ifTrue: [
						(((board at: (posCheck y)) at: (posCheck x)) = 0)
							ifTrue: [
								directions at: r put: dirCheck.
								(trailPoints at: r) add: (positions at: r).]
							ifFalse: [
								directions at: r put: (dirCheck * (-1)).
								(trailPoints at: r) add: (positions at: r).]]
					ifFalse: [
						directions at: r put: (dirCheck * (-1)).
						(trailPoints at: r) add: (positions at: r).]]].
							
				
							
				
				
						
							
							
						
]

{ #category : 'Not categorized' }
LightCyclesWindow >> fillCircle: r [

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
LightCyclesWindow >> fillPolygon: pointList [

	"Fill the polygon given by the list of points"

	self drawable
		fillPolygon: self gc
		points: pointList
		shape: Complex
		mode: CoordModeOrigin
]

{ #category : 'Not categorized' }
LightCyclesWindow >> fillRect: r [

	"Fill the rectangle r."

	self drawable
		fillRectangle: self gc
		x: r origin x
		y: r origin y
		width: r width
		height: r height.
]

{ #category : 'Not categorized' }
LightCyclesWindow >> foreground: anInteger [

	"Set the foreground colour to anInteger."

	self gc
		setForeground: anInteger
]

{ #category : 'Not categorized' }
LightCyclesWindow >> gc [

	"Answer the CgGC to use for the test."

	^gc
]

{ #category : 'Not categorized' }
LightCyclesWindow >> initializeGraphics [

	"Initialize any resources required for graphics drawing."

	| palette fg bg |
	palette := CgIndexedPalette colorCube: #(32 32 32).
	self shell window setPalette: palette.
	fg := palette nearestPixelValue: self drawingArea foregroundColor.
	bg := palette nearestPixelValue:  self drawingArea backgroundColor.
	
	gcValues :=
		CgGCValues new
			capStyle: CapRound;
			foreground: (self black);
			background: (self blue).
			
	gc :=
		self drawingArea window 
			createGC: GCForeground | GCBackground
			values: (CgGCValues new 
							foreground: fg;
							background: bg).
]

{ #category : 'Not categorized' }
LightCyclesWindow >> initializeVariables [

	gridWidth := 55.
	gridHeight := 55.
	
			
	speeds := OrderedCollection 
		with: 5 with: 10.
		
	enemyCount := 1.
	lives := 3.
	points := 0.
	round := 1.
		
	self reset
]

{ #category : 'Not categorized' }
LightCyclesWindow >> isRealized [

	"Answer a Boolean indicating whether the drawing area widget has been realized."

	| widget |
	^(widget := self drawingArea) notNil
		and: [widget isRealized]
]

{ #category : 'Not categorized' }
LightCyclesWindow >> keyPress: area clientData: clientData event: event [

	"Takes the key input and updates the snakes direction"

	area hasFocus ifFalse: [^self].
	
	(pressed = false)
		ifTrue: [
			"If the up key is pressed"
			((event keysym = XKUp) & ((directions at: 1) ~= (0@1)))
				ifTrue: [directions at: 1 put: 0@(-1)].
			"If the down key is pressed"
			((event keysym = XKDown) & ((directions at: 1) ~= (0@(-1))))
				ifTrue: [directions at: 1 put: 0@1].
			"If the left key is pressed"
			((event keysym = XKLeft) & ((directions at: 1) ~= (1@0)))
				ifTrue: [directions at: 1 put: (-1)@0].
			"If the right key is pressed"
			((event keysym = XKRight) & ((directions at: 1) ~= ((-1)@0)))
				ifTrue: [directions at: 1 put: 1@0].
			(trailPoints at: 1) add: (positions at: 1).
			speeds at: 1 put: 5.
			pressed := true].
	
]

{ #category : 'Not categorized' }
LightCyclesWindow >> lightBlue [
	"Color Blue"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 0 green: 153 blue: 255)
]

{ #category : 'Not categorized' }
LightCyclesWindow >> lightBorder [
	"Color Blue"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 111 green: 146 blue: 146).
]

{ #category : 'Not categorized' }
LightCyclesWindow >> lightOrange [
	"Color Orange"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 255 green: 225 blue: 58).
]

{ #category : 'Not categorized' }
LightCyclesWindow >> mainWindowArgs [

	"Answer an argBlock containing some default width and height settings."
	
	^[:w | w width: 590; height: 630]
]

{ #category : 'Not categorized' }
LightCyclesWindow >> MenuClick: aButton clientData: clientData callData: callData [

	"Change the mode based on what is selected"
	
	(clientData = 'Reset')
		ifTrue: [self initializeVariables].

	
]

{ #category : 'Not categorized' }
LightCyclesWindow >> open [

	super open.
	self
		initializeVariables;
		registerTimeoutIn: 0
]

{ #category : 'Not categorized' }
LightCyclesWindow >> orange [
	"Color Orange"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 255 green: 153 blue: 0).
]

{ #category : 'Not categorized' }
LightCyclesWindow >> outlineRect: r [

	"Fill the rectangle r."

	self drawable
		drawRectangle: self gc
		x: r origin x
		y: r origin y
		width: r width
		height: r height.
]

{ #category : 'Not categorized' }
LightCyclesWindow >> printGrid: grid [

	"Print the given two-dimensional list on the Transcript"

	Transcript clear.
	grid do: [:row |
		row do: [:i | Transcript show: ((i printString), '  ')].
		Transcript cr.].
]

{ #category : 'Not categorized' }
LightCyclesWindow >> red [

	"Color Red"
	
	^ shell window getPalette 
		nearestPixelValue: Color red
]

{ #category : 'Not categorized' }
LightCyclesWindow >> registerTimeoutIn: ms [

	timerProcId :=
		CwAppContext default
			addTimeout: ms
			receiver: self
			selector: #timerProc:
			clientData: nil
]

{ #category : 'Not categorized' }
LightCyclesWindow >> removeTimeout [
	"Remove the current timeout."

	CwAppContext default
		removeTimeout: timerProcId.
]

{ #category : 'Not categorized' }
LightCyclesWindow >> reset [
	
	positions := OrderedCollection
		with: 28@48 with: 28@ 8 with: 18@8 with: 38@8.
	directions := OrderedCollection
		with: 0@(-1) with: 0@1 with: 0@1 with: 0@1.
	colors := OrderedCollection 
		with: (self blue) with: (self orange) with: (self orange) with: (self orange).
	trails := OrderedCollection 
		with: (self lightBlue) with: (self lightOrange) with: (self lightOrange) with: (self lightOrange).	
	length := OrderedCollection 
		with: 1 with: 1 with: 1 with: 1.
	alive := OrderedCollection 
		with: true with: true with: true with: true.
	endAnimation := OrderedCollection 
		with: 1 with: 1 with: 1 with: 1.
	endPosition := OrderedCollection 
		with: -1@-1 with: -1@-1 with: -1@-1 with: -1@-1.
	
	trailPoints := OrderedCollection new.
	1 to: (positions size) do: [:a |
		| list |
		list := OrderedCollection
			with: ((positions at: a) + (directions at: a)).
		trailPoints add: list].

	board := OrderedCollection new.
	1 to: gridHeight do: [:a |
		| row |
		row := OrderedCollection new.
		1 to: gridWidth do: [:b | row add: 0].
		board add: row].
			
	counts := OrderedCollection 
		with: 0 with: 0.
	
	running := true.
	pressed := false.
	cyclesStart := 1.
	cyclesEnd := 1.
	speeds at: 1 put: 5.
	endTimer := 0.
		
	self 
		drawBoardX: 0 y: 0;
		drawTopX: 0 y: 0.
]

{ #category : 'Not categorized' }
LightCyclesWindow >> shellName [

	"Answer the name of the receiver's shell.
	This is used as the default label of the window."

	^'Light Cycles'
]

{ #category : 'Not categorized' }
LightCyclesWindow >> TextItem: aString [

	"Creates a text item based on the given string"

	^CgTextItem new
		chars: aString;
		delta: 0;
		font: 0
]

{ #category : 'Not categorized' }
LightCyclesWindow >> timerProc: value [
	"This is the timer proc.  Update the display with
	 the current time and register a new timeout."
		
	self drawingArea isDestroyed ifTrue: [^self].

	(CgDisplay default osGetModifierState = 256)
		ifTrue: [speeds at: 1 put: 2] 
		ifFalse: [speeds at: 1 put: 5].
		
	(endTimer = 50)
		ifTrue: [
			((alive at: 1) = false)
				ifTrue: [
					(lives > 0)
						ifTrue: [
							lives := lives - 1.
							self reset] 
						ifFalse: [running := false]]
				ifFalse: [
					(enemyCount < 3)
						ifTrue: [enemyCount := enemyCount + 1]
						ifFalse: [enemyCount := 3].
					((speeds at: 2) > 3)
						ifTrue: [speeds at: 2 put: ((speeds at: 2) - 1)].
					round := round + 1.
					self reset]]
		ifFalse: [
			(endTimer > 0)
				ifTrue: [
					endTimer := endTimer + 1]].
	
	(running)
		ifTrue: [
			((counts at: 1) >= (speeds at: 1))
				ifTrue: [
					counts at: 1 put: 0.
					cyclesStart := 1]
				ifFalse: [
					counts at: 1 put: ((counts at: 1) + 1).
					cyclesStart := 2].
			((counts at: 2) >= (speeds at: 2))
				ifTrue: [
					counts at: 2 put: 0.
					cyclesEnd := (enemyCount + 1)]
				ifFalse: [
					counts at: 2 put: ((counts at: 2) + 1).
					cyclesEnd := 1].
			((cyclesStart = 2) & (cyclesEnd = 1))
				ifFalse: [self timerStep]].
			
	self registerTimeoutIn: 5. 
	
	pressed := false.
	
]

{ #category : 'Not categorized' }
LightCyclesWindow >> timerStep [

	(endTimer = 0)
		ifTrue: [
			self
				enemyChangeDirection;
				updatePositions;
				addCurrentSegments].
		
	self
		drawBoardX: 0 y: 0.
	

	
]

{ #category : 'Not categorized' }
LightCyclesWindow >> updatePositions [

	cyclesStart to: cyclesEnd do: [:p |
		positions at: p put: ((positions at: p) + (directions at: p))].
]

{ #category : 'Not categorized' }
LightCyclesWindow >> white [

	"Color White"
	
	^ shell window getPalette 
		nearestPixelValue: Color white
]

{ #category : 'Not categorized' }
LightCyclesWindow >> yellow [

	"Color Red"
	
	^ shell window getPalette 
		nearestPixelValue: Color yellow
]
