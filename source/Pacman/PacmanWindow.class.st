Class {
	#name : 'PacmanWindow',
	#superclass : 'WidgetApplication',
	#instVars : [
		'gc',
		'gcValues',
		'timerProcId',
		'drawingArea',
		'dotPoints',
		'powerPellets',
		'pelletCount',
		'pacPosition',
		'ghostPositions',
		'ghostColors',
		'ghostDirections',
		'ghostLastPositions',
		'ghostOnBoard',
		'ghostMove',
		'ghostReturn',
		'lastPosition',
		'pacDirection',
		'nextDirection',
		'pacIntersections',
		'pacDecisions',
		'currentDirections',
		'mouthCount',
		'moving',
		'powered',
		'poweredTimer',
		'enemyCount',
		'pacCount',
		'releaseTimer',
		'beingReleased',
		'releaseCount',
		'ghostWaitingCount',
		'lives',
		'powerTime',
		'endTimer',
		'winTimer',
		'ghostEat',
		'startTimer',
		'level',
		'fruitCollectable',
		'fruitEaten',
		'collectableTimer',
		'posText',
		'disappear',
		'pointsPerGhost',
		'fruitCollectedTimer',
		'score',
		'collectableTime'
	],
	#classVars : [
		'Highscore'
	],
	#category : 'Pacman'
}

{ #category : 'Not categorized' }
PacmanWindow >> addDots [

	powerPellets := OrderedCollection 
		with: 40@80 with: 540@80 with: 40@480 with: 540@480.

	"Add All Dots"
	dotPoints := OrderedCollection new.
	"Rows"
	2 to: 13 do: [:a | dotPoints add: (a * 20)@40].
	16 to: 27 do: [:a | dotPoints add: (a * 20)@40].
	2 to: 27 do: [:a | dotPoints add: (a * 20)@120].
	2 to: 7 do: [:a | dotPoints add: (a * 20)@180].
	10 to: 13 do: [:a | dotPoints add: (a * 20)@180].
	16 to: 19 do: [:a | dotPoints add: (a * 20)@180].
	22 to: 27 do: [:a | dotPoints add: (a * 20)@180].
	2 to: 13 do: [:a | dotPoints add: (a * 20)@420].
	16 to: 27 do: [:a | dotPoints add: (a * 20)@420].
	2 to: 4 do: [:a | dotPoints add: (a * 20)@480].
	7 to: 13 do: [:a | dotPoints add: (a * 20)@480].
	16 to: 22 do: [:a | dotPoints add: (a * 20)@480].
	25 to: 27 do: [:a | dotPoints add: (a * 20)@480].
	2 to: 7 do: [:a | dotPoints add: (a * 20)@540].
	10 to: 13 do: [:a | dotPoints add: (a * 20)@540].
	16 to: 19 do: [:a | dotPoints add: (a * 20)@540].
	22 to: 27 do: [:a | dotPoints add: (a * 20)@540].
	2 to: 27 do: [:a | dotPoints add: (a * 20)@600].
	"Rest"
	#(-1 1) do: [:b |
		 #(3 4 5 7 8 22 23 28 29) do: [:a | dotPoints add: (290 + (b * 250))@(a * 20)].
		 #(25 26) do: [:a | dotPoints add: (290 + (b * 210))@(a * 20)].
		 #(3 4 5 7 8 10 11 12 13 14 15 16 17 18 19 20 22 23 25 26) do: [:a | dotPoints add: (290 + (b * 150))@(a * 20)].
		 #(7 8 25 26) do: [:a | dotPoints add: (290 + (b * 90))@(a * 20)].
		 #(3 4 5 22 23 28 29) do: [:a | dotPoints add: (290 + (b * 30))@(a * 20)]].
		
]

{ #category : 'Not categorized' }
PacmanWindow >> addFruitPoints [

	| points |
	(level = 1)
		ifTrue: [points := 100].
	(level = 2)
		ifTrue: [points := 300].
	((level = 3) | (level = 4))
		ifTrue: [points := 500].
	((level = 5) | (level = 6))
		ifTrue: [points := 700].
	((level = 7) | (level = 8))
		ifTrue: [points := 1000].
	((level = 9) | (level = 10))
		ifTrue: [points := 2000].
	((level = 11) | (level = 12))
		ifTrue: [points := 3000].
	(level >= 13) 
		ifTrue: [points := 5000].
		
	score := score + points.
	(score > Highscore)
		ifTrue: [Highscore := score].
		
	self 
		drawScore;
		drawHighScore.
	
]

{ #category : 'Not categorized' }
PacmanWindow >> addIntersections [

	pacIntersections := OrderedCollection new.
	
	pacIntersections add: 40@40; add: 140@40; add: 260@40; add: 320@40; add: 440@40; add: 540@40;
		add: 40@120; add: 140@120; add: 200@120; add: 260@120; add: 320@120; add: 380@120; add: 440@120; add: 540@120;
		add: 40@180; add: 140@180; add: 200@180; add: 260@180; add: 320@180; add: 380@180; add: 440@180; add: 540@180;
		add: 200@240; add: 260@240; add: 290@240; add: 320@240; add: 380@240; 
		add: 140@300; add: 200@300; add: 380@300; add: 440@300;
		add: 200@360; add: 380@360; 
		add: 40@420; add: 140@420; add: 200@420; add: 260@420; add: 320@420; add: 380@420; add: 440@420; add: 540@420;
		add: 40@480; add: 80@480; add: 140@480; add: 200@480; add: 260@480; add: 320@480; add: 380@480; add: 440@480; add: 500@480; add: 540@480;
		add: 40@540; add: 80@540; add: 140@540; add: 200@540; add: 260@540; add: 320@540; add: 380@540; add: 440@540; add: 500@540; add: 540@540;
		add: 40@600; add: 260@600; add: 320@600; add: 540@600.
		
	pacDecisions := OrderedCollection new.
	
	pacDecisions add: 9; add: 8; add: 7; add: 9; add: 8; add: 7;
		add: 6; add: 5; add: 8; add: 2; add: 2; add: 8; add: 5; add: 4;
		add: 3; add: 4; add: 3; add: 7; add: 9; add: 1; add: 6; add: 1;
		add: 9; add: 2; add: 0; add: 2; add: 7; 
		add: 5; add: 4; add: 6; add: 5; 
		add: 6; add: 4;
		add: 9; add: 5; add: 2; add: 7; add: 9; add: 2; add: 5; add: 7;
		add: 3; add: 7; add: 6; add: 8; add: 2; add: 2; add: 8; add: 4; add: 9; add: 1;
		add: 9; add: 2; add: 1; add: 3; add: 7; add: 9; add: 1; add: 3; add: 2; add: 7;
		add: 3; add: 2; add: 2; add: 1.
]

{ #category : 'Not categorized' }
PacmanWindow >> aqua [

	"Color Darkened Blue"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 75 green: 175 blue: 139)
]

{ #category : 'Not categorized' }
PacmanWindow >> background: anInteger [

	"Set the background colour to anInteger."

	self gc
		setBackground: anInteger
]

{ #category : 'Not categorized' }
PacmanWindow >> black [

	"Black Color"
	
	^ shell window getPalette 
		nearestPixelValue: Color black. 
]

{ #category : 'Not categorized' }
PacmanWindow >> blue [
	"Color Blue"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 51 green: 0 blue: 255).
]

{ #category : 'Not categorized' }
PacmanWindow >> changeLineWidth: w [
	
	gcValues lineWidth = w
		ifFalse:[
			gcValues lineWidth: w.
			self gc
				changeGC: GCLineWidth
				values: gcValues].
	
]

{ #category : 'Not categorized' }
PacmanWindow >> checkForCollision [
	
	1 to: (ghostPositions size) do: [:a |
		| xDist yDist total |
		xDist := (((ghostPositions at: a) x) - (pacPosition x)) abs.
		yDist := (((ghostPositions at: a) y) - (pacPosition y)) abs.
		total := ((xDist squared) + (yDist squared)) sqrt.
		(total < 20) 
			ifTrue: [
				((powered at: a) & ((ghostReturn at: a) not))
					ifTrue: [
					posText := ((ghostPositions at: a) x)@((ghostPositions at: a) y).
					pointsPerGhost := pointsPerGhost * 2.
					score := score + pointsPerGhost.
					(score > Highscore)
						ifTrue: [Highscore := score].
					self 
						drawScore;
						drawHighScore.
					ghostEat := true].
				((powered at: a) | (ghostReturn at: a))
					ifTrue: [
						ghostReturn at: a put: true] 
					ifFalse: [
						endTimer := 1]]].
	
	
]

{ #category : 'Not categorized' }
PacmanWindow >> closestPacmanIntersection [
		
	| directions point |
		
	directions := OrderedCollection 
		with: 0@-5 with: -5@0 with: 5@0 with: 0@5.
	point := pacPosition.
		
	(pacDirection = 0)
		ifTrue: [^point].
		
	[((pacIntersections includes: point) = false) & ((-30 to: 610) includes: (point x))]
		whileTrue: [point := point + (directions at: pacDirection)].
		
	^point

	
]

{ #category : 'Not categorized' }
PacmanWindow >> connectedLines: points polygon: wrapped curved: curve [
	
	| curveSize newPoints|
	
	curveSize := 9.
	
	"Add points "
	newPoints := OrderedCollection new.
	newPoints add: (points first).
	2 to: ((points size) - 1) do: [:k | 
		newPoints add: (points at: k).
		newPoints add: (points at: k)].
	newPoints add: (points last).
	(wrapped)
		ifTrue: [
			newPoints add: (points last).
			newPoints add: (points first)].
	"Fix points"
	1 to: (((newPoints size) / 2) floor) do: [:a |
		(((newPoints at: (a * 2)) x) = ((newPoints at: ((a * 2) - 1)) x))
			ifTrue: [
				(((newPoints at: (a * 2)) y) > ((newPoints at: ((a * 2) - 1)) y))
					ifTrue: [
						newPoints at: (a * 2) put: ((newPoints at: (a * 2)) - (0@curveSize))] 
					ifFalse: [
						newPoints at: (a * 2)  put: ((newPoints at: (a * 2)) + (0@curveSize))]]
			ifFalse: [
				(((newPoints at: (a * 2)) x) > ((newPoints at: ((a * 2) - 1)) x))
					ifTrue: [
						newPoints at: (a * 2) put: ((newPoints at: (a * 2)) - (curveSize@0))] 
					ifFalse: [
						newPoints at: (a * 2)  put: ((newPoints at: (a * 2)) + (curveSize@0))]]].
	1 to: (((newPoints size) / 2) floor) do: [:a |
		(((newPoints at: (a * 2)) x) = ((newPoints at: ((a * 2) - 1)) x))
			ifTrue: [
				(((newPoints at: (a * 2)) y) > ((newPoints at: ((a * 2) - 1)) y))
					ifTrue: [
						newPoints at: ((a * 2) - 1) put: ((newPoints at: ((a * 2) - 1)) + (0@curveSize))] 
					ifFalse: [
						newPoints at: ((a * 2) - 1)  put: ((newPoints at: ((a * 2) - 1)) - (0@curveSize))]]
			ifFalse: [
				(((newPoints at: (a * 2)) x) > ((newPoints at: ((a * 2) - 1)) x))
					ifTrue: [
						newPoints at: ((a * 2) - 1) put: ((newPoints at: ((a * 2) - 1)) + (curveSize@0))] 
					ifFalse: [
						newPoints at: ((a * 2) - 1) put: ((newPoints at: ((a * 2) - 1)) - (curveSize@0))]]].
	(wrapped)
		ifTrue: [newPoints add: (newPoints first).]
		ifFalse: [
			newPoints removeFirst.
			newPoints addFirst: (points first).
			newPoints removeLast.
			newPoints add: (points last).].
		
	curve
		ifTrue: [
			1 to: ((((newPoints size) - 1) / 2) ceiling) do: [:p |
					self
						drawLineStartPoint: (newPoints at: ((p * 2) - 1)) EndPoint: (newPoints at: (p * 2))].
			1 to: ((((newPoints size) - 1) / 2) floor) do: [:p |
					self drawCurvePoint1: (newPoints at: (p * 2)) point2: (newPoints at: ((p * 2) + 1)) point3: (newPoints at: ((p * 2) - 1)) curve: curveSize]]
		ifFalse: [
			1 to: ((points size) - 1) do: [:p |
				self drawLineStartPoint: (points at: p) EndPoint: (points at: (p + 1))].
			wrapped
				ifTrue: [self drawLineStartPoint: (points last) EndPoint: (points first)]].
		
	
]

{ #category : 'Not categorized' }
PacmanWindow >> connectedLines: points polygon: wrapped curved: curve curves: curves [
	
	| curveSize newPoints start|
	
	curveSize := 9.
	
	"Add points "
	newPoints := OrderedCollection new.
	newPoints add: (points first).
	2 to: ((points size) - 1) do: [:k | 
		newPoints add: (points at: k).
		newPoints add: (points at: k)].
	newPoints add: (points last).
	(wrapped)
		ifTrue: [
			newPoints add: (points last).
			newPoints add: (points first)].
	"Fix points"
	1 to: (((newPoints size) / 2) floor) do: [:a |
		(curves ~= nil)
			ifTrue: [curveSize := (curves at: a)].
		(((newPoints at: (a * 2)) x) = ((newPoints at: ((a * 2) - 1)) x))
			ifTrue: [
				(((newPoints at: (a * 2)) y) > ((newPoints at: ((a * 2) - 1)) y))
					ifTrue: [
						newPoints at: (a * 2) put: ((newPoints at: (a * 2)) - (0@curveSize))] 
					ifFalse: [
						newPoints at: (a * 2)  put: ((newPoints at: (a * 2)) + (0@curveSize))]]
			ifFalse: [
				(((newPoints at: (a * 2)) x) > ((newPoints at: ((a * 2) - 1)) x))
					ifTrue: [
						newPoints at: (a * 2) put: ((newPoints at: (a * 2)) - (curveSize@0))] 
					ifFalse: [
						newPoints at: (a * 2)  put: ((newPoints at: (a * 2)) + (curveSize@0))]]].						
	(curves ~= nil)
		ifTrue: [start := 2]
		ifFalse: [start := 1].
	start to: (((newPoints size) / 2) floor) do: [:a |
		(curves ~= nil)
			ifTrue: [curveSize := (curves at: (a - 1))].
		(((newPoints at: (a * 2)) x) = ((newPoints at: ((a * 2) - 1)) x))
			ifTrue: [
				(((newPoints at: (a * 2)) y) > ((newPoints at: ((a * 2) - 1)) y))
					ifTrue: [
						newPoints at: ((a * 2) - 1) put: ((newPoints at: ((a * 2) - 1)) + (0@curveSize))] 
					ifFalse: [
						newPoints at: ((a * 2) - 1)  put: ((newPoints at: ((a * 2) - 1)) - (0@curveSize))]]
			ifFalse: [
				(((newPoints at: (a * 2)) x) > ((newPoints at: ((a * 2) - 1)) x))
					ifTrue: [
						newPoints at: ((a * 2) - 1) put: ((newPoints at: ((a * 2) - 1)) + (curveSize@0))] 
					ifFalse: [
						newPoints at: ((a * 2) - 1) put: ((newPoints at: ((a * 2) - 1)) - (curveSize@0))]]].
	(wrapped)
		ifTrue: [newPoints add: (newPoints first).]
		ifFalse: [
			newPoints removeFirst.
			newPoints addFirst: (points first).
			newPoints removeLast.
			newPoints add: (points last).].
		
	curve
		ifTrue: [
			1 to: ((((newPoints size) - 1) / 2) ceiling) do: [:p |
				self
					drawLineStartPoint: (newPoints at: ((p * 2) - 1)) EndPoint: (newPoints at: (p * 2))].
			1 to: ((((newPoints size) - 1) / 2) floor) do: [:p |
				(curves ~= nil)
					ifTrue: [curveSize := (curves at: p)].
				self drawCurvePoint1: (newPoints at: (p * 2)) point2: (newPoints at: ((p * 2) + 1)) point3: (newPoints at: ((p * 2) - 1)) curve: curveSize]]
		ifFalse: [
			1 to: ((points size) - 1) do: [:p |
				self drawLineStartPoint: (points at: p) EndPoint: (points at: (p + 1))].
			wrapped
				ifTrue: [self drawLineStartPoint: (points last) EndPoint: (points first)]].
		
	
]

{ #category : 'Not categorized' }
PacmanWindow >> createWorkRegion [

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
			width: (shell width);
			height: (shell height)].
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
PacmanWindow >> cyan [

	"Color Darkened Blue"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 74 green: 223 blue: 203)
]

{ #category : 'Not categorized' }
PacmanWindow >> darkBlue [

	"Color Darkened Blue"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 35 green: 63 blue: 139)
]

{ #category : 'Not categorized' }
PacmanWindow >> darkYellow [

	"Color Red"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 205 green: 205 blue: 0)
			
			
			
			
			
			
]

{ #category : 'Not categorized' }
PacmanWindow >> destroy: widget clientData: clientData callData: callData [
	"The drawing area has been destroyed."

	"Remove the timerProc."
	self removeTimeout.
	"Free the color and GC."
	self gc freeGC
]

{ #category : 'Not categorized' }
PacmanWindow >> drawable [

	"Checks if the drawing area is ready to be drawn on"

	self isRealized
		ifTrue: [^self drawingArea window]
		ifFalse: [^self screen rootWindow]
]

{ #category : 'Not categorized' }
PacmanWindow >> drawAppleX: xVal y: yVal [
	
	| z a b c d e f g stem shadow|
	
	z := xVal@yVal extent: 30@30.
	a := (xVal + 2)@(yVal + 4) extent: 14@14.
	b := (xVal + 15)@(yVal + 4) extent: 14@14.
	c := (xVal + 2)@(yVal - 8) extent: 14@36.
	d := (xVal + 15)@(yVal - 8) extent: 14@36.
	e := (xVal + 6)@(yVal + 22) extent: 10@8.
	f := (xVal + 15)@(yVal + 22) extent: 10@8.
	g := (xVal + 8)@(yVal + 6) extent: 16@22.
	stem := (xVal + 15)@(yVal + 1) extent: 6@10.
	shadow := (xVal + 17)@(yVal + 10) extent: 6@14.
	
	self
		foreground: (self black);
		fillRect: z;
		foreground: (self red);
		fillCircle: a angle1: 0 angle2: 180*64;
		fillCircle: b angle1: 0 angle2: 180*64;
		fillCircle: c angle1: 180*64 angle2: 90*64;
		fillCircle: d angle1: 270*64 angle2: 90*64;
		fillCircle: e;
		fillCircle: f;
		fillRect: g;
		changeLineWidth: 3;
		foreground: (self lightBrown);
		drawCircle: stem angle1: 90*64 angle2: 90*64;
		changeLineWidth: 2;
		foreground: (self white);
		drawCircle: shadow angle1: 280*64 angle2: 75*64
		
		
]

{ #category : 'Not categorized' }
PacmanWindow >> drawBackgroundColor: colr [

	| topOut topIn box1 box2 box3 shape1 shape2 botOut botIn box4 shape3 box5 shape4 shape5 shape6 container yDist |
	
	yDist := 40.
	
	topOut := OrderedCollection 
		with: 291@10 with: 10@10 with: 10@210 with: 110@210 with: 110@270 with: 10@270.
	topIn := OrderedCollection new.
	topIn add: 291@100; add: 280@100; add: 280@20; add: 20@20; add: 20@200; add: 120@200; 
		add: 120@280; add: 10@280.
	box1 := OrderedCollection 
		with: 60@60 with: 120@60 with: 120@100 with: 60@100.
	box2 := OrderedCollection 
		with: 60@140 with: 120@140 with: 120@160 with: 60@160.
	box3 := OrderedCollection 
		with: 160@60 with: 240@60 with: 240@100 with: 160@100.
	shape1 := OrderedCollection new.
	shape1 add: 160@140; add: 180@140; add: 180@200; add: 240@200; add: 240@220; 
		add: 180@220; add:180@280; add: 160@280.
	shape2 := OrderedCollection 
		with: 291@140 with: 220@140 with: 220@160 with: 280@160 with: 280@220 with: 291@220.
	botOut := OrderedCollection 
		with: 10@330 with: 110@330 with:110@390 with: 10@390 with: 10@630 with: 291@630.
	botIn := OrderedCollection new.
	botIn add: 10@320; add: 120@320; add: 120@400; add: 20@400; add: 20@500; add: 60@500;
		add: 60@520; add: 20@520; add: 20@620; add: 291@620.
	box4 := OrderedCollection 
		with: 160@320 with: 180@320 with: 180@400 with: 160@400.
	shape3 := OrderedCollection 
		with: 60@440 with: 120@440 with: 120@520 with: 100@520 with: 100@460 with: 60@460.
	box5 := OrderedCollection 
		with: 160@440 with: 240@440 with: 240@460 with: 160@460.
	shape4 := OrderedCollection new.
	shape4 add: 60@560; add: 160@560; add: 160@500; add: 180@500; add: 180@560; add: 240@560;
		add: 240@580; add: 60@580.
	shape5 := OrderedCollection 
		with: 291@380 with: 220@380 with: 220@400 with: 280@400 with: 280@460 with: 291@460.
	shape6 := OrderedCollection 
		with: 291@500 with: 220@500 with: 220@520 with: 280@520 with: 280@580 with: 291@580.
	container := OrderedCollection new.
	container add: 291@340; add: 220@340; add: 220@260; add: 265@260; add: 265@270;
		add: 230@270; add: 230@330; add: 291@330.
		
	topOut := topOut collect: [:p | (p x)@((p y) + yDist)].
	topIn := topIn collect: [:p | (p x)@((p y) + yDist)].
	box1 := box1 collect: [:p | (p x)@((p y) + yDist)].
	box2 := box2 collect: [:p | (p x)@((p y) + yDist)].
	box3 := box3 collect: [:p | (p x)@((p y) + yDist)].
	shape1 := shape1 collect: [:p | (p x)@((p y) + yDist)].
	shape2 := shape2 collect: [:p | (p x)@((p y) + yDist)].
	botOut := botOut collect: [:p | (p x)@((p y) + yDist)].
	botIn := botIn collect: [:p | (p x)@((p y) + yDist)].
	box4 := box4 collect: [:p | (p x)@((p y) + yDist)].
	shape3 := shape3 collect: [:p | (p x)@((p y) + yDist)].
	box5 := box5 collect: [:p | (p x)@((p y) + yDist)].
	shape4 := shape4 collect: [:p | (p x)@((p y) + yDist)].
	shape5 := shape5 collect: [:p | (p x)@((p y) + yDist)].
	shape6 := shape6 collect: [:p | (p x)@((p y) + yDist)].
	container := container collect: [:p | (p x)@((p y) + yDist)].
	
	self 
		changeLineWidth: 3;
		foreground: (self black);
		fillRect: (0@0 extent: 580@725);
		drawString: '1up' x: 26 y: 6 scale: 2 color: (self white) align: 'left' space: 2;
		drawString: 'high score' x: 290 y: 6 scale: 2 color: (self white) align: 'center' space: 2.
	(winTimer > 0)
		ifTrue: [self foreground: (self black)]
		ifFalse: [self foreground: (self offWhite)].
	self drawLineStartPoint: 265@305 EndPoint: 315@305.
	
	#(1 2) do: [:s |	
		(s = 2)
			ifTrue: [
				topOut := topOut collect: [:p | (580 - (p x))@(p y)].
				topIn := topIn collect: [:p | (580 - (p x))@(p y)].
				box1 := box1 collect: [:p | (580 - (p x))@(p y)].
				box2 := box2 collect: [:p | (580 - (p x))@(p y)].
				box3 := box3 collect: [:p | (580 - (p x))@(p y)].
				shape1 := shape1 collect: [:p | (580 - (p x))@(p y)].
				shape2 := shape2 collect: [:p | (580 - (p x))@(p y)].
				botOut := botOut collect: [:p | (580 - (p x))@(p y)].
				botIn := botIn collect: [:p | (580 - (p x))@(p y)].
				box4 := box4 collect: [:p | (580 - (p x))@(p y)].
				shape3 := shape3 collect: [:p | (580 - (p x))@(p y)].
				box5 := box5 collect: [:p | (580 - (p x))@(p y)].
				shape4 := shape4 collect: [:p | (580 - (p x))@(p y)].
				shape5 := shape5 collect: [:p | (580 - (p x))@(p y)].
				shape6 := shape6 collect: [:p | (580 - (p x))@(p y)].
				container := container collect: [:p | (580 - (p x))@(p y)]].
		
		self
			foreground: colr;
			connectedLines: topOut polygon: false curved: true curves: #(9 9 4 4 4);
			connectedLines: topIn polygon: false curved: true curves: #(9 4 4 4 9 9 9);
			connectedLines: box1 polygon: true curved: true curves: nil;
			connectedLines: box2 polygon: true curved: true curves: nil;
			connectedLines: box3 polygon: true curved: true curves: nil;
			connectedLines: shape1 polygon: true curved: true curves: nil;
			connectedLines: shape2 polygon: false curved: true curves: nil;
			connectedLines: botOut polygon: false curved: true curves: #(4 4 9 9 9);
			connectedLines: botIn polygon: false curved: true curves: #(9 9 4 4 9 9 4 4 4);
			connectedLines: box4 polygon: true curved: true curves: nil;
			connectedLines: shape3 polygon: true curved: true curves: nil;
			connectedLines: box5 polygon: true curved: true curves: nil;
			connectedLines: shape4 polygon: true curved: true curves: nil;
			connectedLines: shape5 polygon: false curved: true curves: nil;
			connectedLines: shape6 polygon: false curved: true curves: nil;
			connectedLines: container polygon: false curved: false curves: nil].
]

{ #category : 'Not categorized' }
PacmanWindow >> drawBellX: xVal y: yVal [
	
	| z a b c d|
	
	z := xVal@yVal extent: 30@30.
	a := (xVal + 2)@(yVal + 1) extent: 26@50.
	b := (xVal + 2)@(yVal + 23) extent: 26@7.
	c := (xVal + 15)@(yVal + 22) extent: 8@8.
	d := (xVal + 7)@(yVal + 4) extent: 14@40.
	
	self
		foreground: (self black);
		fillRect: z;
		foreground: (self yellow);
		fillCircle: a angle1: 0 angle2: 180*64;
		foreground: (self skyBlue);
		fillCircle: b;
		foreground: (self white);
		fillCircle: c;
		changeLineWidth: 2;
		foreground: (self black);
		drawCircle: d angle1: 80*64 angle2: 20*64;
		drawCircle: d angle1: 125*64 angle2: 20*64;
		drawCircle: d angle1: 160*64 angle2: 10*64
		
		

		
		
]

{ #category : 'Not categorized' }
PacmanWindow >> drawCharacter: char x: xVal y: yVal scale: s color: clr [

	| points |
	points := OrderedCollection new.
	
	"Letters"
	(char = $r)
		ifTrue: [points add: 0@0; add: 6@0; add: 6@1; add: 7@1; add: 7@4; add: 5@4; add: 5@5; add: 6@5; add: 6@6; add: 7@6; add: 7@7; add: 4@7; add: 4@6; add: 3@6; add: 3@5; add: 2@5; add: 2@4; add: 4@4; add: 4@3; add: 5@3; add: 5@1; add: 2@1; add: 2@7; add: 0@7].
	(char = $e)
		ifTrue: [points add: 0@0; add: 7@0; add: 7@1; add: 2@1; add: 2@3; add: 6@3; add: 6@4; add: 2@4; add: 2@6; add: 7@6; add: 7@7; add: 0@7].
	(char = $a)
		ifTrue: [points add: 2@0; add: 5@0; add: 5@1; add: 6@1; add: 6@2; add: 7@2; add: 7@7; add: 5@7; add: 5@5; add: 2@5; add: 2@4; add: 5@4; add: 5@2; add: 4@2; add: 4@1; add: 3@1; add: 3@2; add: 2@2; add: 2@7; add: 0@7; add: 0@2; add: 1@2; add: 1@1; add: 2@1].
	(char = $d)
		ifTrue: [points add: 0@0; add: 5@0; add: 5@1; add: 6@1; add: 6@2; add: 7@2; add: 7@5; add: 6@5; add: 6@6; add: 5@6; add: 5@7; add: 2@7; add: 2@6; add: 4@6; add: 4@5; add: 5@5; add: 5@2; add: 4@2; add: 4@1; add: 2@1; add: 2@7; add: 0@7].
	(char = $y)
		ifTrue: [points add: 0@0; add: 2@0; add: 2@3; add: 4@3; add: 4@0; add: 6@0; add: 6@3; add: 5@3; add: 5@4; add: 4@4; add: 4@7; add: 2@7; add: 2@4; add: 1@4; add: 1@3; add: 0@3].
	(char = $!)
		ifTrue: [points add: 2@0; add: 5@0; add: 5@2; add: 4@2; add: 4@3; add: 3@3; add: 3@4; add: 2@4; add: 2@5; add: 1@5; add: 1@7; add: 0@7; add: 0@6; add: 1@6; add: 1@2; add: 2@2].
	(char = $h)
		ifTrue: [points add: 0@0; add: 2@0; add: 2@3; add: 5@3; add: 5@0; add: 7@0; add: 7@7; add: 5@7; add: 5@4; add: 2@4; add: 2@7; add: 0@7].
	(char = $i)
		ifTrue: [points add: 1@0; add: 7@0; add: 7@1; add: 5@1; add: 5@6; add: 7@6; add: 7@7; add: 1@7; add: 1@6; add: 3@6; add: 3@1; add: 1@1].
	(char = $g)
		ifTrue: [points add: 2@0; add: 7@0; add: 7@1; add: 3@1; add: 3@2; add: 2@2; add: 2@5; add: 3@5; add: 3@6; add: 5@6; add: 5@4; add: 4@4; add: 4@3; add: 7@3; add: 7@7; add: 2@7; add: 2@6; add: 1@6; add: 1@5; add: 0@5; add: 0@2; add: 1@2; add: 1@1; add: 2@1].
	(char = $s)
		ifTrue: [points add: 1@0; add: 5@0; add: 5@1; add: 6@1; add: 6@2; add: 4@2; add: 4@1; add: 2@1; add: 2@3; add: 6@3; add: 6@4; add: 7@4; add: 7@6; add: 6@6; add: 6@7; add: 1@7; add: 1@6; add: 0@6; add: 0@5; add: 2@5; add: 2@6; add: 5@6; add: 5@4; add: 1@4; add: 1@3; add: 0@3; add: 0@1; add: 1@1].
	(char = $c)
		ifTrue: [points add: 2@0; add: 6@0; add: 6@1; add: 7@1; add: 7@2; add: 5@2; add: 5@1; add: 3@1; add: 3@2; add: 2@2; add: 2@5; add: 3@5; add: 3@6; add: 5@6; add: 5@5; add: 7@5; add: 7@6; add: 6@6; add: 6@7; add: 2@7; add: 2@6; add: 1@6; add: 1@5; add: 0@5; add: 0@2; add: 1@2; add: 1@1; add: 2@1].
	(char = $o)
		ifTrue: [points add: 1@0; add: 6@0; add: 6@1; add: 7@1; add: 7@6; add: 6@6; add: 6@7; add: 1@7; add: 1@6; add: 5@6; add: 5@1; add: 2@1; add: 2@6; add: 0@6; add: 0@1; add: 1@1].
	(char = $u)
		ifTrue: [points add: 0@0; add: 2@0; add: 2@6; add: 5@6; add: 5@0; add: 7@0; add: 7@6; add: 6@6; add: 6@7; add: 1@7; add: 1@6; add: 0@6].
	(char = $p)
		ifTrue: [points add: 0@0; add: 6@0; add: 6@1; add: 7@1; add: 7@4; add: 6@4; add: 6@5; add: 2@5; add: 2@4; add: 5@4; add: 5@1; add: 2@1; add: 2@7; add: 0@7].
	(char = $m)
		ifTrue: [points add: 0@0; add: 2@0; add: 2@1; add: 3@1; add: 3@2; add: 4@2; add: 4@1; add: 5@1; add: 5@0; add: 7@0; add: 7@7; add: 5@7; add: 5@4; add: 4@4; add: 4@5; add: 3@5; add: 3@4; add: 2@4; add: 2@7; add: 0@7].
	(char = $v)
		ifTrue: [points add: 0@0; add: 2@0; add: 2@3; add: 3@3; add: 3@4; add: 4@4; add: 4@3; add: 5@3; add: 5@0; add: 7@0; add: 7@4; add: 6@4; add: 6@5; add: 5@5; add: 5@6; add: 4@6; add: 4@7; add: 3@7; add: 3@6; add: 2@6; add: 2@5; add: 1@5; add: 1@4; add: 0@4].
	(char = $t)
		ifTrue: [points add: 1@0; add: 7@0; add: 7@1; add: 5@1; add: 5@7; add: 3@7; add: 3@1; add: 1@1].
	
	"Numbers"
	(char = $1)
		ifTrue: [points add: 2@0; add: 4@0; add: 4@6; add: 6@6; add: 6@7; add: 0@7; add: 0@6; add: 2@6; add: 2@2; add: 1@2; add: 1@1; add: 2@1].
	(char = $2)
		ifTrue: [points add: 1@0; add: 6@0; add: 6@1; add: 7@1; add: 7@3; add: 6@3; add: 6@4; add: 5@4; add: 5@5; add: 3@5; add: 3@6; add: 7@6; add: 7@7; add: 0@7; add: 0@5; add: 1@5; add: 1@4; add: 2@4; add: 2@3; add: 4@3; add: 4@2; add: 5@2; add: 5@1; add: 2@1; add: 2@2; add: 0@2; add: 0@1; add: 1@1].
	(char = $3)
		ifTrue: [points add: 1@0; add: 7@0; add: 7@1; add: 6@1; add: 6@2; add: 5@2; add: 5@3; add: 6@3; add: 6@4; add: 7@4; add: 7@6; add: 6@6; add: 6@7; add: 1@7; add: 1@6; add: 0@6; add: 0@5; add: 2@5; add: 2@6; add: 5@6; add: 5@4; add: 2@4; add: 2@3; add: 3@3; add: 3@2; add: 4@2; add: 4@1; add: 1@1].
	(char = $4)
		ifTrue: [points add: 3@0; add: 6@0; add: 6@4; add: 7@4; add: 7@5; add: 6@5; add: 6@7; add: 4@7; add: 4@2; add: 3@2; add: 3@3; add: 2@3; add: 2@4; add: 4@4; add: 4@5; add: 0@5; add: 0@3; add: 1@3; add: 1@2; add: 2@2; add: 2@1; add: 3@1].
	(char = $5)
		ifTrue: [points add: 0@0; add: 6@0; add: 6@1; add: 2@1; add: 2@2; add: 6@2; add: 6@3; add: 7@3; add: 7@6; add: 6@6; add: 6@7; add: 1@7; add: 1@6; add: 0@6; add: 0@5; add: 2@5; add: 2@6; add: 5@6; add: 5@3; add: 0@3].
	(char = $6)
		ifTrue: [points add: 2@0; add: 6@0; add: 6@1; add: 3@1; add: 3@2; add: 2@2; add: 2@3; add: 6@3; add: 6@4; add: 7@4; add: 7@6; add: 6@6; add: 6@7; add: 1@7; add: 1@6; add: 5@6; add: 5@4; add: 2@4; add: 2@6; add: 0@6; add: 0@2; add: 1@2; add: 1@1; add: 2@1].
	(char = $7)
		ifTrue: [points add: 0@0; add: 7@0; add: 7@2; add: 6@2; add: 6@3; add: 5@3; add: 5@4; add: 4@4; add: 4@7; add: 2@7; add: 2@4; add: 3@4; add: 3@3; add: 4@3; add: 4@2; add: 5@2; add: 5@1; add: 2@1; add: 2@2; add: 0@2].
	(char = $8)
		ifTrue: [points add: 1@0; add: 5@0; add: 5@1; add: 6@1; add: 6@3; add: 5@3; add: 5@1; add: 2@1; add: 2@2; add: 3@2; add: 3@3; add: 5@3; add: 5@4; add: 7@4; add: 7@6; add: 6@6; add: 6@7; add: 1@7; add: 1@6; add: 0@6; add: 0@4; add: 1@4; add: 1@6; add: 5@6; add: 5@5; add: 3@5; add: 3@4; add: 1@4; add: 1@3; add: 0@3; add: 0@1; add: 1@1].
	(char = $9)
		ifTrue: [points add: 1@0; add: 6@0; add: 6@1; add: 7@1; add: 7@5; add: 6@5; add: 6@6; add: 5@6; add: 5@7; add: 1@7; add: 1@6; add: 4@6; add: 4@5; add: 5@5; add: 5@1; add: 2@1; add: 2@3; add: 5@3; add: 5@4; add: 1@4; add: 1@3; add: 0@3; add: 0@1; add: 1@1].
	(char = $0)
		ifTrue: [points add: 2@0; add: 5@0; add: 5@1; add: 6@1; add: 6@2; add: 7@2; add: 7@5; add: 6@5; add: 6@6; add: 5@6; add: 5@7; add: 2@7; add: 2@6; add: 1@6; add: 1@5; add: 0@5; add: 0@2; add: 1@2; add: 1@1; add: 2@1; add: 2@5; add: 3@5; add: 3@6; add: 5@6; add: 5@2; add: 4@2; add: 4@1; add: 2@1].
	
	(points isEmpty)
		ifTrue: [points add: 0@0].
		
	points := points collect: [:m | (((m x) * s) + xVal)@(((m y) * s) + yVal)].
	self 
		foreground: clr;
		fillPolygon: points
]

{ #category : 'Not categorized' }
PacmanWindow >> drawCherryX: xVal y: yVal [
	
	| z a b c d e f g|
	
	z := xVal@yVal extent: 30@30.
	a := (xVal + 1)@(yVal + 10) extent: 16@17.
	b := (xVal + 10)@(yVal + 11) extent: 20@21.
	c := (xVal + 12)@(yVal + 13) extent: 16@17.
	
	d := (xVal + 3)@(yVal + 10) extent: 12@12.
	e := (xVal + 14)@(yVal + 13) extent: 12@12.
	
	f := (xVal + 9)@(yVal + 2) extent: 30@22.
	g := (xVal + 20)@(yVal + 2) extent: 10@27.
	
	self
		foreground: (self black);
		fillRect: z;
		foreground: (self red);
		fillCircle: a;
		foreground: (self black);
		fillCircle: b;
		foreground: (self red);
		fillCircle: c;
		foreground: (self white);
		changeLineWidth: 2;
		drawCircle: d angle1: 210*64 angle2: 30*64;
		drawCircle: e angle1: 212*64 angle2: 30*64;
		foreground: (self lightBrown);
		changeLineWidth: 3;
		drawCircle: f angle1: 90*64 angle2: 90*64;
		drawCircle: g angle1: 90*64 angle2: 90*64
		
		
]

{ #category : 'Not categorized' }
PacmanWindow >> drawCircle: r angle1: ang1 angle2: ang2 [

	"Fill the circle r."

	self drawable
		drawArc: self gc
		x:  r origin x
		y:  r origin y
		width:  r width
		height: r height
		angle1: ang1
		angle2: ang2
]

{ #category : 'Not categorized' }
PacmanWindow >> drawCollectableFruitVisible: visible [

	| fruit |
	
	(level = 1)
		ifTrue: [fruit := [self drawCherryX: 275 y: 385]].
	(level = 2)
		ifTrue: [fruit := [self drawStrawberryX: 275 y: 385]].
	((level = 3) | (level = 4))
		ifTrue: [fruit := [self drawOrangeX: 275 y: 385]].
	((level = 5) | (level = 6))
		ifTrue: [fruit := [self drawAppleX: 275 y: 385]].
	((level = 7) | (level = 8))
		ifTrue: [fruit := [self drawMelonX: 275 y: 385]].
	((level = 9) | (level = 10))
		ifTrue: [fruit := [self drawGalaxianBossX: 275 y: 385]].
	((level = 11) | (level = 12))
		ifTrue: [fruit := [self drawBellX: 275 y: 385]].
	(level >= 13) 
		ifTrue: [fruit := [self drawKeyX: 275 y: 385]].
		
	visible
		ifTrue: [fruit value]
		ifFalse: [
			self 
				foreground: (self black);
				fillRect: (275@385 extent: 30@30)]
]

{ #category : 'Not categorized' }
PacmanWindow >> drawCurvePoint1: p1 point2: p2 point3: p3 curve: curve [

	"p1: start
	 p2: end
	 p3: determines the concavity
	"
	| r xPos yPos ang|
	
	(((p1 x) > (p2 x)) & ((p1 y) > (p2 y)) & ((p1 y) = (p3 y)))
		ifTrue: [
			xPos := (p2 x).
			yPos := ((p2 y) - curve).
			ang := 180 * 64].
	(((p1 x) > (p2 x)) & ((p1 y) > (p2 y)) & ((p1 x) = (p3 x)))
		ifTrue: [
			xPos := ((p2 x) - curve).
			yPos := (p2 y).
			ang := 0].
	(((p1 x) > (p2 x)) & ((p1 y) < (p2 y)) & ((p1 y) = (p3 y)))
		ifTrue: [
			xPos := (p2 x).
			yPos := (p1 y).
			ang := 90 * 64].
	(((p1 x) > (p2 x)) & ((p1 y) < (p2 y)) & ((p1 x) = (p3 x)))
		ifTrue: [
			xPos := ((p2 x) - curve).
			yPos := ((p1 y) - curve).
			ang := 270 * 64].
	(((p1 x) < (p2 x)) & ((p1 y) > (p2 y)) & ((p1 y) = (p3 y)))
		ifTrue: [
			xPos := ((p1 x) - curve).
			yPos := ((p2 y) - curve).
			ang := 270 * 64].
	(((p1 x) < (p2 x)) & ((p1 y) > (p2 y)) & ((p1 x) = (p3 x)))
		ifTrue: [
			xPos := (p1 x).
			yPos := (p2 y).
			ang := 90 * 64].
	(((p1 x) < (p2 x)) & ((p1 y) < (p2 y)) & ((p1 y) = (p3 y)))
		ifTrue: [
			xPos := ((p1 x) - curve).
			yPos := (p1 y).
			ang := 0].
	(((p1 x) < (p2 x)) & ((p1 y) < (p2 y)) & ((p1 x) = (p3 x)))
		ifTrue: [
			xPos := (p1 x).
			yPos := ((p1 y) - curve).
			ang := 180 * 64].
	
	r := xPos@yPos extent: (curve * 2)@(curve * 2).
	self drawCircle: r angle1: ang angle2: 90*64
	
]

{ #category : 'Not categorized' }
PacmanWindow >> drawDots [
	
	dotPoints do: [:point |
		(powerPellets includes: point)
			ifFalse: [self drawDotX: (point x) y: ((point y) + 40) radius: 4 color: (self offWhite)]].
]

{ #category : 'Not categorized' }
PacmanWindow >> drawDotX: xVal y: yVal radius: rad color: colr [

	| r |
	r := (xVal - (rad / 2))@(yVal - (rad / 2)) extent: rad@rad.
	self 
		foreground: colr;
		fillCircle: r.
]

{ #category : 'Not categorized' }
PacmanWindow >> drawFruitCollectedText [

	| points |
	(level = 1)
		ifTrue: [points := 100].
	(level = 2)
		ifTrue: [points := 300].
	((level = 3) | (level = 4))
		ifTrue: [points := 500].
	((level = 5) | (level = 6))
		ifTrue: [points := 700].
	((level = 7) | (level = 8))
		ifTrue: [points := 1000].
	((level = 9) | (level = 10))
		ifTrue: [points := 2000].
	((level = 11) | (level = 12))
		ifTrue: [points := 3000].
	(level >= 13) 
		ifTrue: [points := 5000].

	(fruitCollectedTimer > 0)
		ifTrue: [self drawString: (points printString) x: 290 y: 400 scale: 1 color: (self lightPink) align: 'center' space: 2]
		ifFalse: [self drawString: (points printString) x: 290 y: 400 scale: 1 color: (self black) align: 'center' space: 2].
]

{ #category : 'Not categorized' }
PacmanWindow >> drawGalaxianBossX: xVal y: yVal [
	
	| z a b c d|
	
	z := xVal@yVal extent: 30@30.
	a := OrderedCollection new.
	a add: (xVal + 16)@(yVal + 2); add: (xVal + 22)@(yVal + 8); add: (xVal + 26)@(yVal + 8);
		add: (xVal + 26)@(yVal + 12); add: (xVal + 21)@(yVal + 17); add: (xVal + 19)@(yVal + 17);
		add: (xVal + 19)@(yVal + 14); add: (xVal + 16)@(yVal + 14); add: (xVal + 16)@(yVal + 26);
		add: (xVal + 14)@(yVal + 26); add: (xVal + 14)@(yVal + 14); add: (xVal + 11)@(yVal + 14);
		add: (xVal + 11)@(yVal + 17); add: (xVal + 9)@(yVal + 17); add: (xVal + 4)@(yVal + 12);
		add: (xVal + 4)@(yVal + 8); add: (xVal + 8)@(yVal + 8); add: (xVal + 14)@(yVal + 2).
		
	b := OrderedCollection  new.
	b add: (xVal + 16)@(yVal + 2); add: (xVal + 22)@(yVal + 8); add: (xVal + 24)@(yVal + 8);
		add: (xVal + 24)@(yVal + 10); add: (xVal + 20)@(yVal + 10); add: (xVal + 18)@(yVal + 8);
		add: (xVal + 16)@(yVal + 8); add: (xVal + 16)@(yVal + 12); add: (xVal + 14)@(yVal + 12);
		add: (xVal + 14)@(yVal + 8); add: (xVal + 12)@(yVal + 8); add: (xVal + 10)@(yVal + 10);
		add: (xVal + 6)@(yVal + 10); add: (xVal + 6)@(yVal + 8); add: (xVal + 8)@(yVal + 8);
		add: (xVal + 14)@(yVal + 2).
		
	c := OrderedCollection  new.
	c add: (xVal + 26)@(yVal + 4); add: (xVal + 29)@(yVal + 4); add: (xVal + 29)@(yVal + 14);
		add: (xVal + 22)@(yVal + 21); add: (xVal + 19)@(yVal + 20); add: (xVal + 19)@(yVal + 17);
		add: (xVal + 21)@(yVal + 17); add: (xVal + 26)@(yVal + 12).
		
	d := OrderedCollection  new.
	d add: (xVal + 4)@(yVal + 4); add: (xVal + 1)@(yVal + 4); add: (xVal + 1)@(yVal + 14);
		add: (xVal + 8)@(yVal + 21); add: (xVal + 11)@(yVal + 20); add: (xVal + 11)@(yVal + 17);
		add: (xVal + 9)@(yVal + 17); add: (xVal + 4)@(yVal + 12).
		
	self
		foreground: (self black);
		fillRect: z;
		foreground: (self yellow);
		fillPolygon: a;
		foreground: (self red);
		fillPolygon: b;
		foreground: (self darkBlue);
		fillPolygon: c;
		fillPolygon: d
		


		
		

		
		
]

{ #category : 'Not categorized' }
PacmanWindow >> drawGhostAt: point direction: dir color: colr powered: pwr return: rtrn [

	| xPos yPos eyeChange top middle leftSocket rightSocket leftEye rightEye poweredMouth pwrMain pwrExtra flashIntervals|
	xPos := (point x).
	yPos := (point y).
	
	(dir = 1) ifTrue: [eyeChange := 0@-3].
	(dir = 2) ifTrue: [eyeChange := -3@0].
	(dir = 3) ifTrue: [eyeChange := 3@0].
	(dir = 4) ifTrue: [eyeChange := 0@3].
	
	top := (xPos - 15)@(yPos - 15) extent: 30@30.
	middle := OrderedCollection new.
	middle add: (xPos - 15)@yPos; add: (xPos - 15)@(yPos + 15); add: (xPos - 10)@(yPos + 10); 
		add: (xPos - 5)@(yPos + 15); add: xPos@(yPos + 10);
		add: (xPos + 5)@(yPos + 15); add: (xPos + 10)@(yPos + 10); add: (xPos + 15)@(yPos + 15); 
		add: (xPos + 15)@yPos.
	leftSocket := (xPos - 11)@(yPos - 8) extent: 10@12.
	rightSocket := (xPos + 1)@(yPos - 8) extent: 10@12.
	leftEye := ((xPos - 9)@(yPos - 5) + eyeChange) extent: 6@6.
	rightEye := ((xPos + 3)@(yPos - 5) + eyeChange) extent: 6@6.
	
	flashIntervals := OrderedCollection new.
	flashIntervals add: [135 to: 150]; add: [105 to: 120]; add: [75 to: 90]; add: [45 to: 60]; add: [15 to: 30].
	rtrn
		ifFalse: [
			pwr
				ifTrue: [
					(((flashIntervals select: [:a | (a value) includes: poweredTimer]) size) = 0)
						ifTrue: [
							pwrMain := (self blue). 
							pwrExtra := (self offWhite)]
						ifFalse: [
							pwrMain := (self white). 
							pwrExtra := (self red)].
				
					leftEye := (xPos - 6)@(yPos - 5) extent: 4@4.
					rightEye := (xPos + 3)@(yPos - 5) extent: 4@4.
					poweredMouth := OrderedCollection new.
					poweredMouth add: (xPos - 9)@(yPos + 6); add: (xPos - 6)@(yPos + 3); add: (xPos - 3)@(yPos + 6); 
						add: xPos@(yPos + 3); add: (xPos + 3)@(yPos + 6); add: (xPos + 6)@(yPos + 3);
						add: (xPos + 9)@(yPos + 6).
						
					self
						foreground: pwrMain;
						fillCircle: top angle1: 0 angle2: 180*64;
						fillPolygon: middle;
						foreground: pwrExtra;
						fillRect: leftEye;
						fillRect: rightEye;
						changeLineWidth: 2;
						connectedLines: poweredMouth polygon: false curved: false curves: nil]
				ifFalse: [
					self 
						foreground: colr;
						fillCircle: top angle1: 0 angle2: 180*64;
						fillPolygon: middle;
						foreground: (self white);
						fillCircle: leftSocket;
						fillCircle: rightSocket;
						foreground: (self blue);
						fillCircle: leftEye;
						fillCircle:  rightEye]]
		ifTrue: [
			self
				foreground: (self white);
				fillCircle: leftSocket;
				fillCircle: rightSocket;
				foreground: (self blue);
				fillCircle: leftEye;
				fillCircle:  rightEye].
	
]

{ #category : 'Not categorized' }
PacmanWindow >> drawGhosts [

	| dist |
	
	((endTimer < 75) & (winTimer = 0))
		ifTrue: [
			ghostLastPositions do: [:point |
				| r |
				r := ((point x) - 16)@(((point y) - 16) + 40) extent: 32@32.
				self foreground: (self black); fillRect: r].
			ghostPositions do: [:point |
					| r |
					r := ((point x) - 16)@(((point y) - 16) + 40) extent: 32@32.
					self foreground: (self black); fillRect: r].
					
			dist := ((((pacPosition x) - 290) squared) + (((pacPosition y) - 360) squared)) sqrt.
			((dist < 40) & fruitCollectable & (fruitEaten not))
				ifTrue: [self drawCollectableFruitVisible: true].
				
			self 
				drawPacman;
				changeLineWidth: 3;
				foreground: (self offWhite);
				drawLineStartPoint: 270@305 EndPoint: 310@305.
			
			1 to: (ghostPositions size) do: [:a |
				dist := (((((ghostPositions at: a) x) - 290) squared) + ((((ghostPositions at: a) y) - 360) squared)) sqrt.
				((dist < 40) & fruitCollectable & (fruitEaten not))
					ifTrue: [self drawCollectableFruitVisible: true]].
			
			1 to: (ghostPositions size) do: [:a |
				self
					redrawDotsAroundPoint: (ghostPositions at: a);
					drawGhostAt: ((ghostPositions at: a) + (0@40))
						direction: (ghostDirections at: a) 
						color: (ghostColors at: a) 
						powered: (powered at: a) 
						return: (ghostReturn at: a)]]
			ifFalse: [
				ghostLastPositions do: [:point |
					| r |
					r := ((point x) - 16)@(((point y) - 16) + 40) extent: 32@32.
					self foreground: (self black); fillRect: r].
				ghostPositions do: [:point |
					| r |
					r := ((point x) - 16)@(((point y) - 16) + 40) extent: 32@32.
					self foreground: (self black); fillRect: r;
						redrawDotsAroundPoint: point].
				self drawPacman]
			
]

{ #category : 'Not categorized' }
PacmanWindow >> drawHighScore [

	| r |
	r := (290 - (72 / 2))@26 extent: 72@14.
	
	self
		foreground: (self black);
		fillRect: r.
	
	(Highscore > 0)
		ifTrue: [self drawString: (Highscore printString) x: 290 y: 26 scale: 2 color: (self white) align: 'center' space: 2].
	
]

{ #category : 'Not categorized' }
PacmanWindow >> drawingArea [

	"Answer the drawing area widget."

	^self workRegion
]

{ #category : 'Not categorized' }
PacmanWindow >> drawKeyX: xVal y: yVal [
	
	| z a b c d e f g |
	
	z := xVal@yVal extent: 30@30.
	a := (xVal + 6)@(yVal + 1) extent: 18@18.
	b := (xVal + 6)@(yVal + 9) extent: 18@4.
	c := (xVal + 12)@(yVal + 13) extent: 6@14.
	d := (xVal + 12)@(yVal + 23) extent: 6@6.
	e := (xVal + 14)@(yVal + 15) extent: 6@6.
	f := (xVal + 14)@(yVal + 21) extent: 6@6.
	g := (xVal + 11)@(yVal + 3) extent: 8@4.
	
	self
		foreground: (self black);
		fillRect: z;
		foreground: (self white);
		fillRect: c;
		fillCircle: d;
		fillCircle: e;
		fillCircle: f;
		foreground: (self black);
		changeLineWidth: 2;
		drawLineStartPoint: (xVal + 15)@(yVal + 13) EndPoint: (xVal + 15)@(yVal + 27);
		drawLineStartPoint: (xVal + 15)@(yVal + 18) EndPoint: (xVal + 17)@(yVal + 18);
		drawLineStartPoint: (xVal + 15)@(yVal + 24) EndPoint: (xVal + 17)@(yVal + 24);
		foreground: (self skyBlue);
		fillCircle: a angle1: 0 angle2: 180*64;
		fillCircle: b;
		foreground: (self black);
		fillCircle: g
		
		
		

		
		
]

{ #category : 'Not categorized' }
PacmanWindow >> drawLevelFruits [

	| fruits range |
	fruits := OrderedCollection new.
	fruits
		add: [:a | self drawCherryX: a y: 680]; 				"Level 1"
		add: [:a | self drawStrawberryX: a y: 680]; 		"Level 2"
		add: [:a | self drawOrangeX: a y: 680]; 			"Level 3"
		add: [:a | self drawOrangeX: a y: 680]; 			"Level 4"
		add: [:a | self drawAppleX: a y: 680]; 				"Level 5"
		add: [:a | self drawAppleX: a y: 680]; 				"Level 6"
		add: [:a | self drawMelonX: a y: 680]; 				"Level 7"
		add: [:a | self drawMelonX: a y: 680]; 				"Level 8"
		add: [:a | self drawGalaxianBossX: a y: 680]; 	"Level 9"
		add: [:a | self drawGalaxianBossX: a y: 680]; 	"Level 10"
		add: [:a | self drawBellX: a y: 680]; 					"Level 11"
		add: [:a | self drawBellX: a y: 680]; 					"Level 12"
		add: [:a | self drawKeyX: a y: 680]; 					"Level 13"
		add: [:a | self drawKeyX: a y: 680]; 					"Level 14"
		add: [:a | self drawKeyX: a y: 680]; 					"Level 15"
		add: [:a | self drawKeyX: a y: 680]; 					"Level 16"
		add: [:a | self drawKeyX: a y: 680]; 					"Level 17"
		add: [:a | self drawKeyX: a y: 680]; 					"Level 18"
		add: [:a | self drawKeyX: a y: 680].					"Level 19"
		
	(level < 8)
		ifTrue: [range := (1 to: level)].
	((level > 7) & (level < 19))
		ifTrue: [range := ((level - 6) to: level)].
	(level > 18)
		ifTrue: [range := (13 to: 19)].
		
	range doWithIndex: [:b :index |
		(fruits at: b) value: (530 - (index * 35))].
]

{ #category : 'Not categorized' }
PacmanWindow >> drawLineStartPoint: startPoint EndPoint: endPoint [
	
	"Draws a line"

	self drawable
		drawLine: self gc
		x1: startPoint x
		y1: startPoint y
		x2: endPoint x
		y2: endPoint y
	
]

{ #category : 'Not categorized' }
PacmanWindow >> drawLives [

	| r |

	1 to: lives do: [:p |
		r := ((40 * p) + 10)@680 extent: 30@30.
		self 
			foreground: (self yellow);
			fillCircle: r angle1: 225*60 angle2: 320*60].
]

{ #category : 'Not categorized' }
PacmanWindow >> drawMelonX: xVal y: yVal [
	
	| z a b c d e f light dark|
	
	z := xVal@yVal extent: 30@30.
	a := (xVal + 2)@(yVal + 4) extent: 26@26.
	b := (xVal + 14)@(yVal + 3) extent: 2@4.
	c := (xVal + 4)@(yVal - 24) extent: 26@26.
	
	light := OrderedCollection new.
	light add: 16@8; add: 11@ 12; add: 19@14; add: 7@16; add: 15@18; add: 23@18; add: 7@22;
		add: 13@24; add: 18@24.
	dark := OrderedCollection new.
	dark add: 15@10; add: 9@12; add: 13@12; add: 11@14; add: 9@16; add: 7@18; add: 9@20;
		add: 11@22; add: 13@26; add: 11@28; add: 15@24; add: 17@22; add: 15@20; add: 17@18;
		add: 19@16; add: 21@14; add: 23@12; add: 23@16; add: 25@18; add: 20@24; add: 22@26; add: 7@10.
	
	self
		foreground: (self black);
		fillRect: z;
		foreground: (self green);
		fillCircle: a;
		changeLineWidth: 3;
		foreground: (self aqua);
		drawCircle: b angle1: 90*64 angle2: 90*64;
		drawCircle: c angle1: 245*64 angle2: 35*64.
		
	self foreground: (self white).	
	light do: [:point |
		| r |
		r := (xVal + (point x) - 1)@(yVal + (point y) - 1) extent: 2@2.
		self fillRect: r].
		
	self foreground: (self aqua).
	dark do: [:point |
		| r |
		r := (xVal + (point x) - 1)@(yVal + (point y) - 1) extent: 2@2.
		self fillRect: r].
		

		
		
]

{ #category : 'Not categorized' }
PacmanWindow >> drawOrangeX: xVal y: yVal [
	
	| z a b c d e |
	
	z := xVal@yVal extent: 30@30.
	a := (xVal + 2)@(yVal + 8) extent: 26@22.
	b := (xVal + 9)@(yVal + 8) extent: 12@5.
	c := (xVal + 13)@(yVal + 3) extent: 4@10.
	d := (xVal + 16)@(yVal + 2) extent: 6@5.
	e := (xVal + 17)@(yVal + 4) extent: 12@8.
	
	self
		foreground: (self black);
		fillRect: z;
		foreground: (self lightOrange);
		fillCircle: a;
		foreground: (self lightBrown);
		fillCircle: b;
		fillCircle: c;
		foreground: (self green);
		fillCircle: d;
		fillCircle: e

		
		

		
		
]

{ #category : 'Not categorized' }
PacmanWindow >> drawPacman [

	| pacman removeLast removeAll baseAngles angle1 angle2 mouthOpen |
	
	removeLast := ((lastPosition x) - 16)@(((lastPosition y) - 16) + 40) extent: 32@32.
	removeAll := ((pacPosition x) - 18)@(((pacPosition y) - 18) + 40) extent: 36@36.
	pacman := ((pacPosition x) - 15)@(((pacPosition y) - 15) + 40) extent: 30@30.
	
	baseAngles := OrderedCollection 
		with: 0 with: 90*64 with: 180*64 with: 0 with: 270*64.
	
	(endTimer < 100)
		ifTrue: [mouthOpen := (5 - (mouthCount abs)) * 10]
		ifFalse: [
			self
				foreground: (self black);
				fillRect: removeAll.
			mouthOpen := ((5 - (mouthCount abs)) + (endTimer - 100)) * 5].
	
	angle1 := (baseAngles at: (pacDirection + 1)) + (mouthOpen*64).
	angle2 := ((360 - (mouthOpen * 2))*64).
	
	self
		foreground: (self black);
		fillCircle: removeLast.
		
	(endTimer  > 0)
		ifTrue: [			
			self 
				foreground: (self offWhite);
				drawLineStartPoint: 270@305 EndPoint: 310@305.].
		
	(mouthOpen < 180)	
		ifTrue: [
			disappear
				ifTrue: [self foreground: (self black)]
				ifFalse: [self foreground: (self yellow)].
			self drawable
				fillArc: self gc
				x:  pacman origin x
				y:  pacman origin y
				width:  pacman width
				height: pacman height
				angle1: angle1
				angle2: angle2]
		ifFalse: [
			(mouthOpen <= 220)
				ifTrue: [
					self 
						foreground: (self yellow);
						drawLineStartPoint: (pacPosition x)@(((pacPosition y) + 8) + 40) EndPoint: (pacPosition x)@(((pacPosition y) + 12) + 40);
						drawLineStartPoint: (pacPosition x)@(((pacPosition y) - 8) + 40) EndPoint: (pacPosition x)@(((pacPosition y) - 12) + 40);
						drawLineStartPoint: ((pacPosition x) - 8)@((pacPosition y) + 40) EndPoint: ((pacPosition x) - 12)@((pacPosition y) + 40);
						drawLineStartPoint: ((pacPosition x) + 8)@((pacPosition y) + 40) EndPoint: ((pacPosition x) + 12)@((pacPosition y) + 40);
						drawLineStartPoint: ((pacPosition x) + 6)@(((pacPosition y) + 6) + 40) EndPoint: ((pacPosition x) + 8)@(((pacPosition y) + 8) + 40);
						drawLineStartPoint: ((pacPosition x) + 6)@(((pacPosition y) - 6) + 40) EndPoint: ((pacPosition x) + 8)@(((pacPosition y) - 8) + 40);
						drawLineStartPoint: ((pacPosition x) - 6)@(((pacPosition y) + 6) + 40) EndPoint: ((pacPosition x) - 8)@(((pacPosition y) + 8) + 40);
						drawLineStartPoint: ((pacPosition x) - 6)@(((pacPosition y) - 6) + 40) EndPoint: ((pacPosition x) - 8)@(((pacPosition y) - 8) + 40)]
				ifFalse: [
					(mouthOpen > 500)
						ifTrue: [
							(lives > 0)
								ifTrue: [
									lives := lives - 1.
									self reset]
								ifFalse: [
									self 
										drawCollectableFruitVisible: false;
										drawString: 'game  over' x: 290 y: 394 scale: 2 color: (self red) align: 'center' space: 2;
										drawString: 'r to reset' x: 26 y: 690  scale: 2 color: (self white) align: 'left' space: 2]]]].
							
	disappear ifTrue: [self poweredTextColor: (self cyan)].
	
			
			
			
			
			
			
]

{ #category : 'Not categorized' }
PacmanWindow >> drawPellets [

	powerPellets do: [:point |
		(pelletCount > 13)
			ifTrue: [
				self drawDotX: (point x) y: ((point y) + 40) radius: 16 color: (self offWhite)]
			ifFalse: [
				self drawDotX: (point x) y: ((point y) + 40) radius: 16 color: (self black)]].
]

{ #category : 'Not categorized' }
PacmanWindow >> drawRect: r [

	"Fill the rectangle r."

	self drawable
		drawRectangle: self gc
		x: r origin x
		y: r origin y
		width: r width
		height: r height.

]

{ #category : 'Not categorized' }
PacmanWindow >> drawScore [

	| r |
	r := 26@26 extent: 72@14.
	
	self
		foreground: (self black);
		fillRect: r.
	
	(score > 0)
		ifTrue: [self drawString: (score printString) x: 26 y: 26 scale: 2 color: (self white) align: 'left' space: 2].
	
]

{ #category : 'Not categorized' }
PacmanWindow >> drawStrawberryX: xVal y: yVal [
	
	| z a b c d e f spots|
	
	z := xVal@yVal extent: 30@30.
	a := (xVal + 2)@(yVal + 3) extent: 26@18.
	b := (xVal + 2)@(yVal - 6) extent: 26@34.
	c := (xVal + 5)@(yVal - 8) extent: 20@38.
	
	d := (xVal + 7)@(yVal + 2) extent: 16@6.
	e := (xVal + 7)@(yVal - 1) extent: 16@11.
	
	f := (xVal + 14)@(yVal + 1) extent: 2@4.
	
	spots := OrderedCollection new.
	spots add: 15@14; add: 15@20; add: 13@24; add: 8@19; add: 10@14; add: 6@10; 
		add: 19@24; add: 22@17; add: 20@12; add: 24@9.
	
	self
		foreground: (self black);
		fillRect: z;
		foreground: (self red);
		fillCircle: a angle1: 0 angle2: 180*64;
		fillCircle: b angle1: 180*64 angle2: 180*64;
		fillCircle: c angle1: 180*64 angle2: 180*64;
		foreground: (self green);
		fillCircle: d angle1: 0 angle2: 180*64;
		fillCircle: e angle1: 180*64 angle2: 180*64;
		foreground: (self white);
		fillRect: f.
	
	spots do: [:point |
		| r |
		r := (xVal + (point x) - 1)@(yVal + (point y) - 1) extent: 2@2.
		self fillRect: r].
		
		

		
		
]

{ #category : 'Not categorized' }
PacmanWindow >> drawString: str x: xVal y: yVal scale: s color: clr align: align space: spc [

	str doWithIndex: [:char :index | | xPos|
		(align = 'left')
			ifTrue: [xPos := xVal].
		(align = 'center')
			ifTrue: [xPos := ((xVal -  (((str size) * ((7 + spc) * s)) / 2)) asInteger)].		
		(align = 'right')
			ifTrue: [xPos := ((xVal -  ((str size) * ((7 + spc) * s))) asInteger)].
		self drawCharacter: char x: (xPos + ((index - 1) * ((7 + spc) * s))) y: yVal scale: s color: clr].
		
]

{ #category : 'Not categorized' }
PacmanWindow >> eatDots [

	| dist |
	dotPoints do: [:point |
		(point ~= nil)
			ifTrue: [
				dist := ((((point x) - (pacPosition x)) squared) + (((point y) - (pacPosition y)) squared)) sqrt.
				(dist <= 15)
					ifTrue: [
						self drawDotX: (point x) y: ((point y) + 40) radius: 6 color: (self black).
						(powerPellets includes: point)
							ifTrue: [
								self drawDotX: (point x) y: ((point y) + 40) radius: 16 color: (self black).
								powerPellets remove: point.
								pointsPerGhost := 100.
								poweredTimer := powerTime.
								score := score + 50]
							ifFalse: [score := score + 10].
						(score > Highscore)
							ifTrue: [Highscore := score].
						self 
							drawScore;
							drawHighScore.
						dotPoints remove: point]]].
		
	((((dotPoints size) = 174) | ((dotPoints size) = 74)) & (fruitCollectable not) & (fruitEaten not))
		ifTrue: [
			fruitCollectable := true.
			collectableTimer := collectableTime.
			self drawCollectableFruitVisible: true].

	dist := (((290 - (pacPosition x)) squared) + ((360 - (pacPosition y)) squared)) sqrt.
	(fruitCollectable & (fruitEaten not) & (dist <= 15))
		ifTrue: [
			fruitEaten := true.
			fruitCollectable := false.
			fruitCollectable := false.
			self drawCollectableFruitVisible: false.
			self addFruitPoints.
			fruitCollectedTimer := 100].
			
	((dotPoints size) = 0) 
		ifTrue: [winTimer := 1].
]

{ #category : 'Not categorized' }
PacmanWindow >> endAnimation [
	
	| white blue |
	
	white := OrderedCollection new.
	white add: 20; add: 60; add: 100.
	blue := OrderedCollection new.
	blue add: 40; add: 80; add: 120.

	(white includes: winTimer)
		ifTrue: [
			self 
				drawBackgroundColor: (self white);
				drawPacman;
				drawLevelFruits;
				drawLives].
	(blue includes: winTimer)
		ifTrue: [
			self 
				drawBackgroundColor: (self blue);
				drawPacman;
				drawLevelFruits;
				drawLives].
				
	(winTimer = 200)
		ifTrue: [
		level := level + 1.
		(collectableTime > 200)	
			ifTrue: [collectableTime := collectableTime - 20].
		(powerTime > 160)	
			ifTrue: [powerTime := powerTime - 20].
			self
				addDots;
				reset].
		
]

{ #category : 'Not categorized' }
PacmanWindow >> fillCircle: r [

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
PacmanWindow >> fillCircle: r angle1: ang1 angle2: ang2 [

	"Fill the circle r."

	self drawable
		fillArc: self gc
		x:  r origin x
		y:  r origin y
		width:  r width
		height: r height
		angle1: ang1
		angle2: ang2
]

{ #category : 'Not categorized' }
PacmanWindow >> fillPolygon: pointList [

	"Fill the polygon given by the list of points"

	self drawable
		fillPolygon: self gc
		points: pointList
		shape: Complex
		mode: CoordModeOrigin
	
]

{ #category : 'Not categorized' }
PacmanWindow >> fillRect: r [

	"Fill the rectangle r."

	self drawable
		fillRectangle: self gc
		x: r origin x
		y: r origin y
		width: r width
		height: r height.
]

{ #category : 'Not categorized' }
PacmanWindow >> foreground: anInteger [

	"Set the foreground colour to anInteger."

	self gc
		setForeground: anInteger
]

{ #category : 'Not categorized' }
PacmanWindow >> gc [

	"Answer the CgGC to use for the test."

	^gc
]

{ #category : 'Not categorized' }
PacmanWindow >> green [

	"Color Darkened Blue"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 71 green: 167 blue: 47)
]

{ #category : 'Not categorized' }
PacmanWindow >> initializeGraphics [

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
			background: (self black).
			
	gc :=
		self drawingArea window 
			createGC: GCForeground | GCBackground
			values: (CgGCValues new 
							foreground: fg;
							background: bg).
]

{ #category : 'Not categorized' }
PacmanWindow >> initializeVars [

	lives := 5.
	level := 1.
	powerTime := 400.
	collectableTime := 800.
	score := 0.
	self
		addIntersections;
		addDots;
		reset
]

{ #category : 'Not categorized' }
PacmanWindow >> isRealized [

	"Answer a Boolean indicating whether the drawing area widget has been realized."

	| widget |
	^(widget := self drawingArea) notNil
		and: [widget isRealized]
]

{ #category : 'Not categorized' }
PacmanWindow >> keyPress: area clientData: clientData event: event [

	"Takes the key input and updates the snakes direction"

	area hasFocus ifFalse: [^self].
	(endTimer = 0)
		ifTrue: [
			(pacIntersections includes: pacPosition)
				ifTrue: [| num |
					num := pacDecisions at: (pacIntersections indexOf: pacPosition).
					(#(1 2 3 4 5 6) includes: num)
						ifTrue: [
							(event keysym = XKUp) 
								ifTrue: [
									pacDirection := 1.
									nextDirection := 1.
									currentDirections at: 1 put: 1.
									currentDirections  at: 2 put: 4]].
					(#(1 2 4 5 7 8) includes: num)
						ifTrue: [
							(event keysym = XKLeft) 
								ifTrue: [
									pacDirection := 2.
									nextDirection := 2.
									currentDirections at: 1 put: 2.
									currentDirections  at: 2 put: 3]].
					(#(2 3 5 6 8 9) includes: num)
						ifTrue: [
							(event keysym = XKRight) 
								ifTrue: [
									pacDirection := 3.
									nextDirection := 3.
									currentDirections at: 1 put: 2.
									currentDirections  at: 2 put: 3]].
					(#(4 5 6 7 8 9) includes: num)
						ifTrue: [
							(event keysym = XKDown) 
								ifTrue: [
									pacDirection := 4.
									nextDirection := 4.
									currentDirections at: 1 put: 1.
									currentDirections  at: 2 put: 4]]]
				ifFalse: [
					(event keysym = XKUp) 
						ifTrue: [
							(currentDirections includes: 1)
								ifTrue: [
									nextDirection := 1.
									pacDirection := 1]
								ifFalse: [nextDirection := 1]].
					(event keysym = XKLeft) 
						ifTrue: [
							(currentDirections includes: 2)
								ifTrue: [
									nextDirection := 2.
									pacDirection := 2]
								ifFalse: [nextDirection := 2]].
					(event keysym = XKRight) 
						ifTrue: [
							(currentDirections includes: 3)
								ifTrue: [
									nextDirection := 3.
									pacDirection := 3]
								ifFalse: [nextDirection := 3]].
					(event keysym = XKDown) 
						ifTrue: [
							(currentDirections includes: 4)
								ifTrue: [
									nextDirection := 4.
									pacDirection := 4]
								ifFalse: [nextDirection := 4]]].
			self drawPacman]
		ifFalse: [
			(event keysym = XKr) 
				ifTrue: [self initializeVars]].
			
			
			
			
			
]

{ #category : 'Not categorized' }
PacmanWindow >> lightBlue [
	"Color Blue"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 0 green: 153 blue: 255)
]

{ #category : 'Not categorized' }
PacmanWindow >> lightBrown [

	"Color Darkened Blue"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 220 green: 156 blue: 86)
]

{ #category : 'Not categorized' }
PacmanWindow >> lightOrange [

	"Color Darkened Blue"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 255 green: 190 blue: 86)
]

{ #category : 'Not categorized' }
PacmanWindow >> lightPink [

	"Color Darkened Blue"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 253 green: 194 blue: 212)
]

{ #category : 'Not categorized' }
PacmanWindow >> mainWindowArgs [

	"Answer an argBlock containing some default width and height settings."
	
	^[:w | w width: 580; height: 720]
]

{ #category : 'Not categorized' }
PacmanWindow >> moveAwayGhost: ghost [

	| scatter directions opposite num possible xDiff yDiff decision|
	
	directions := OrderedCollection 
		with: 0@-5 with: -5@0 with: 5@0 with: 0@5.
	opposite := OrderedCollection 
		with: 4 with: 3 with: 2 with: 1.
	scatter := OrderedCollection
		with: 90@80 with: 530@80 with: 170@610 with: 410@610.
	possible := OrderedCollection new.
	xDiff := ((ghostPositions at: ghost) x) - ((scatter at: ghost) x).
	yDiff := ((ghostPositions at: ghost) y) - ((scatter at: ghost) y).
	decision := nil.

	ghostLastPositions at: ghost put: (ghostPositions at: ghost).
	
	(pacIntersections includes: (ghostPositions at: ghost))
		ifTrue: [
			num := (pacDecisions at: (pacIntersections indexOf: (ghostPositions at: ghost))).
			(#(1 2 3 4 5 6) includes: num) ifTrue: [possible add: 1].
			(#(0 1 2 4 5 7 8) includes: num) ifTrue: [possible add: 2].
			(#(0 2 3 5 6 8 9) includes: num) ifTrue: [possible add: 3].
			(#(4 5 6 7 8 9) includes: num) ifTrue: [possible add: 4].
			possible remove: (opposite at: (ghostDirections at: ghost)) ifAbsent: [].
			
			((xDiff >= 0) & (yDiff >= 0))
				ifTrue: [
					((xDiff abs) > (yDiff abs))
						ifTrue: [
							((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2].
							((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1]] 
						ifFalse: [
							((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1].
							((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2]].
					((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3].
					((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4]].
			((xDiff < 0) & (yDiff >= 0))
				ifTrue: [
					((xDiff abs) > (yDiff abs))
						ifTrue: [
							((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3].
							((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1]] 
						ifFalse: [
							((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1].
							((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3]].
					((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2].
					((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4]].
			((xDiff >= 0) & (yDiff < 0))
				ifTrue: [
					((xDiff abs) > (yDiff abs))
						ifTrue: [
							((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2].
							((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4]] 
						ifFalse: [
							((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4].
							((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2]].
					((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3].
					((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1]].
			((xDiff < 0) & (yDiff < 0))
				ifTrue: [
					((xDiff abs) > (yDiff abs))
						ifTrue: [
							((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3].
							((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4]] 
						ifFalse: [
							((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4].
							((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3]].
					((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2].
					((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1]].
			
			ghostDirections at: ghost put: decision].
					
	ghostPositions at: ghost put: ((ghostPositions at: ghost) + (directions at: (ghostDirections at: ghost))).
				
	(((ghostPositions at: ghost) x) < -20)
		ifTrue: [ghostPositions at: ghost put: 600@((ghostPositions at: ghost) y)].
	(((ghostPositions at: ghost) x) > 600)
		ifTrue: [ghostPositions at: ghost put: -20@((ghostPositions at: ghost) y)].
		
		
		
		
		
]

{ #category : 'Not categorized' }
PacmanWindow >> moveCyan [

	| directions opposite num possible xDiff yDiff decision rand pick|
	
	directions := OrderedCollection 
		with: 0@-5 with: -5@0 with: 5@0 with: 0@5.
	opposite := OrderedCollection 
		with: 4 with: 3 with: 2 with: 1.
	possible := OrderedCollection new.
	rand := EsRandom new.
	xDiff := ((ghostPositions at: 3) x) - (pacPosition x).
	yDiff := ((ghostPositions at: 3) y) - (pacPosition y).
	decision := nil.
	
	ghostLastPositions at: 3 put: (ghostPositions at: 3).
	
	(pacIntersections includes: (ghostPositions at: 3))
		ifTrue: [
			num := (pacDecisions at: (pacIntersections indexOf: (ghostPositions at: 3))).
			(#(1 2 3 4 5 6) includes: num) ifTrue: [possible add: 1].
			(#(0 1 2 4 5 7 8) includes: num) ifTrue: [possible add: 2].
			(#(0 2 3 5 6 8 9) includes: num) ifTrue: [possible add: 3].
			(#(4 5 6 7 8 9) includes: num) ifTrue: [possible add: 4].
			possible remove: (opposite at: (ghostDirections at: 3)) ifAbsent: [].
			
			((rand nextInt: 4) = 1)
				ifTrue: [
					((xDiff >= 0) & (yDiff >= 0))
						ifTrue: [
							((xDiff abs) > (yDiff abs))
								ifTrue: [
									((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2].
									((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1]] 
								ifFalse: [
									((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1].
									((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2]].
							((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3].
							((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4]].
					((xDiff < 0) & (yDiff >= 0))
						ifTrue: [
							((xDiff abs) > (yDiff abs))
								ifTrue: [
									((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3].
									((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1]] 
								ifFalse: [
									((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1].
									((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3]].
							((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2].
							((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4]].
					((xDiff >= 0) & (yDiff < 0))
						ifTrue: [
							((xDiff abs) > (yDiff abs))
								ifTrue: [
									((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2].
									((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4]] 
								ifFalse: [
									((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4].
									((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2]].
							((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3].
							((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1]].
					((xDiff < 0) & (yDiff < 0))
						ifTrue: [
							((xDiff abs) > (yDiff abs))
								ifTrue: [
									((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3].
									((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4]] 
								ifFalse: [
									((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4].
									((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3]].
							((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2].
							((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1]].
					ghostDirections at: 3 put: decision]
				ifFalse: [
					pick := (ghostDirections at: 3).
					(pick = 4)
						ifTrue: [pick := 1] 
						ifFalse: [pick := pick + 1].
					(possible includes: pick)
						ifTrue: [ghostDirections at: 3 put: pick]
						ifFalse: [ghostDirections at: 3 put: (possible at: (rand nextInt: (possible size)))]]].
					
	ghostPositions at: 3 put: ((ghostPositions at: 3) + (directions at: (ghostDirections at: 3))).
				
	(((ghostPositions at: 3) x) < -20)
		ifTrue: [ghostPositions at: 3 put: 600@((ghostPositions at: 3) y)].
	(((ghostPositions at: 3) x) > 600)
		ifTrue: [ghostPositions at: 3 put: -20@((ghostPositions at: 3) y)].
		
		
		
		
		
]

{ #category : 'Not categorized' }
PacmanWindow >> moveOrange [

	| directions opposite num possible rand |
	
	directions := OrderedCollection 
		with: 0@-5 with: -5@0 with: 5@0 with: 0@5.
	opposite := OrderedCollection 
		with: 4 with: 3 with: 2 with: 1.
	possible := OrderedCollection new.
	rand := EsRandom new.

	ghostLastPositions at: 4 put: (ghostPositions at: 4).
	
	(pacIntersections includes: (ghostPositions at: 4))
		ifTrue: [
			num := (pacDecisions at: (pacIntersections indexOf: (ghostPositions at: 4))).
			(#(1 2 3 4 5 6) includes: num) ifTrue: [possible add: 1].
			(#(0 1 2 4 5 7 8) includes: num) ifTrue: [possible add: 2].
			(#(0 2 3 5 6 8 9) includes: num) ifTrue: [possible add: 3].
			(#(4 5 6 7 8 9) includes: num) ifTrue: [possible add: 4].
			possible remove: (opposite at: (ghostDirections at: 4)) ifAbsent: [].
			ghostDirections at: 4 put: (possible at: (rand nextInt: (possible size)))].
					
	ghostPositions at: 4 put: ((ghostPositions at: 4) + (directions at: (ghostDirections at: 4))).
				
	(((ghostPositions at: 4) x) < -20)
		ifTrue: [ghostPositions at: 4 put: 600@((ghostPositions at: 4) y)].
	(((ghostPositions at: 4) x) > 600)
		ifTrue: [ghostPositions at: 4 put: -20@((ghostPositions at: 4) y)].
		
		
		
		
		
]

{ #category : 'Not categorized' }
PacmanWindow >> movePacman [

	| directions |
	
	directions := OrderedCollection 
		with: 0@-5 with: -5@0 with: 5@0 with: 0@5.

	lastPosition := pacPosition.
	
	(pacIntersections includes: pacPosition)
		ifTrue: [
			(nextDirection = 1)
				ifTrue: [
					(#(1 2 3 4 5 6) includes: (pacDecisions at: (pacIntersections indexOf: pacPosition)))
						ifTrue: [pacDirection := nextDirection]].
			(nextDirection = 2)
				ifTrue: [
					(#(0 1 2 4 5 7 8) includes: (pacDecisions at: (pacIntersections indexOf: pacPosition)))
						ifTrue: [pacDirection := nextDirection]].
			(nextDirection = 3)
				ifTrue: [
					(#(0 2 3 5 6 8 9) includes: (pacDecisions at: (pacIntersections indexOf: pacPosition)))
						ifTrue: [pacDirection := nextDirection]].
			(nextDirection = 4)
				ifTrue: [
					(#(4 5 6 7 8 9) includes: (pacDecisions at: (pacIntersections indexOf: pacPosition)))
						ifTrue: [pacDirection := nextDirection]]].
	
	(pacDirection = 1)
		ifTrue: [
			currentDirections at: 1 put: 1.
			currentDirections  at: 2 put: 4.
			(pacIntersections includes: pacPosition)
				ifTrue: [
					(#(1 2 3 4 5 6) includes: (pacDecisions at: (pacIntersections indexOf: pacPosition)))
						ifTrue: [
							pacPosition := pacPosition + (directions at: pacDirection).
							moving := true]
						ifFalse: [moving := false]]
				ifFalse: [
					pacPosition := pacPosition + (directions at: pacDirection).
					moving := true]].
	(pacDirection = 2)
		ifTrue: [
			currentDirections at: 1 put: 2.
			currentDirections  at: 2 put: 3.
			(pacIntersections includes: pacPosition)
				ifTrue: [
					(#(0 1 2 4 5 7 8) includes: (pacDecisions at: (pacIntersections indexOf: pacPosition)))
						ifTrue: [
							pacPosition := pacPosition + (directions at: pacDirection).
							moving := true]
						ifFalse: [moving := false]]
				ifFalse: [
					pacPosition := pacPosition + (directions at: pacDirection).
					moving := true]].
	(pacDirection = 3)
		ifTrue: [
			currentDirections at: 1 put: 2.
			currentDirections  at: 2 put: 3.
			(pacIntersections includes: pacPosition)
				ifTrue: [
					(#(0 2 3 5 6 8 9) includes: (pacDecisions at: (pacIntersections indexOf: pacPosition)))
						ifTrue: [
							pacPosition := pacPosition + (directions at: pacDirection).
							moving := true]
						ifFalse: [moving := false]]
				ifFalse: [
					pacPosition := pacPosition + (directions at: pacDirection).
					moving := true]].
	(pacDirection = 4)
		ifTrue: [
			currentDirections at: 1 put: 1.
			currentDirections  at: 2 put: 4.
			(pacIntersections includes: pacPosition)
				ifTrue: [
					(#(4 5 6 7 8 9) includes: (pacDecisions at: (pacIntersections indexOf: pacPosition)))
						ifTrue: [
							pacPosition := pacPosition + (directions at: pacDirection).
							moving := true]
						ifFalse: [moving := false]]
				ifFalse: [
					pacPosition := pacPosition + (directions at: pacDirection).
					moving := true]].
				
	((pacPosition x) < -20)
		ifTrue: [pacPosition := 600@(pacPosition y)].
	((pacPosition x) > 600)
		ifTrue: [pacPosition := -20@(pacPosition y)].
		
		
		
		
		
]

{ #category : 'Not categorized' }
PacmanWindow >> movePink [

	| closestIntersection directions opposite num possible xDiff yDiff decision|
	
	directions := OrderedCollection 
		with: 0@-5 with: -5@0 with: 5@0 with: 0@5.
	opposite := OrderedCollection 
		with: 4 with: 3 with: 2 with: 1.
	possible := OrderedCollection new. 
	
	closestIntersection := self closestPacmanIntersection.
	
	xDiff := ((ghostPositions at: 2) x) - (closestIntersection x).
	yDiff := ((ghostPositions at: 2) y) - (closestIntersection y).
	decision := nil.

	ghostLastPositions at: 2 put: (ghostPositions at: 2).
	
	(pacIntersections includes: (ghostPositions at: 2))
		ifTrue: [
			num := (pacDecisions at: (pacIntersections indexOf: (ghostPositions at: 2))).
			(#(1 2 3 4 5 6) includes: num) ifTrue: [possible add: 1].
			(#(0 1 2 4 5 7 8) includes: num) ifTrue: [possible add: 2].
			(#(0 2 3 5 6 8 9) includes: num) ifTrue: [possible add: 3].
			(#(4 5 6 7 8 9) includes: num) ifTrue: [possible add: 4].
			possible remove: (opposite at: (ghostDirections at: 2)) ifAbsent: [].
			
			((xDiff >= 0) & (yDiff >= 0))
				ifTrue: [
					((xDiff abs) > (yDiff abs))
						ifTrue: [
							((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2].
							((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1]] 
						ifFalse: [
							((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1].
							((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2]].
					((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3].
					((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4]].
			((xDiff < 0) & (yDiff >= 0))
				ifTrue: [
					((xDiff abs) > (yDiff abs))
						ifTrue: [
							((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3].
							((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1]] 
						ifFalse: [
							((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1].
							((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3]].
					((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2].
					((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4]].
			((xDiff >= 0) & (yDiff < 0))
				ifTrue: [
					((xDiff abs) > (yDiff abs))
						ifTrue: [
							((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2].
							((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4]] 
						ifFalse: [
							((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4].
							((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2]].
					((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3].
					((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1]].
			((xDiff < 0) & (yDiff < 0))
				ifTrue: [
					((xDiff abs) > (yDiff abs))
						ifTrue: [
							((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3].
							((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4]] 
						ifFalse: [
							((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4].
							((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3]].
					((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2].
					((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1]].
			
			ghostDirections at: 2 put: decision].
					
	ghostPositions at: 2 put: ((ghostPositions at: 2) + (directions at: (ghostDirections at: 2))).
				
	(((ghostPositions at: 2) x) < -20)
		ifTrue: [ghostPositions at: 2 put: 600@((ghostPositions at: 2) y)].
	(((ghostPositions at: 2) x) > 600)
		ifTrue: [ghostPositions at: 2 put: -20@((ghostPositions at: 2) y)].
		
		
		
		
		
]

{ #category : 'Not categorized' }
PacmanWindow >> moveRed [

	| directions opposite num possible xDiff yDiff decision|
	
	directions := OrderedCollection 
		with: 0@-5 with: -5@0 with: 5@0 with: 0@5.
	opposite := OrderedCollection 
		with: 4 with: 3 with: 2 with: 1.
	possible := OrderedCollection new.
	xDiff := ((ghostPositions at: 1) x) - (pacPosition x).
	yDiff := ((ghostPositions at: 1) y) - (pacPosition y).
	decision := nil.

	ghostLastPositions at: 1 put: (ghostPositions at: 1).
	
	(pacIntersections includes: (ghostPositions at: 1))
		ifTrue: [
			num := (pacDecisions at: (pacIntersections indexOf: (ghostPositions at: 1))).
			(#(1 2 3 4 5 6) includes: num) ifTrue: [possible add: 1].
			(#(0 1 2 4 5 7 8) includes: num) ifTrue: [possible add: 2].
			(#(0 2 3 5 6 8 9) includes: num) ifTrue: [possible add: 3].
			(#(4 5 6 7 8 9) includes: num) ifTrue: [possible add: 4].
			possible remove: (opposite at: (ghostDirections at: 1)) ifAbsent: [].
			
			((xDiff >= 0) & (yDiff >= 0))
				ifTrue: [
					((xDiff abs) > (yDiff abs))
						ifTrue: [
							((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2].
							((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1]] 
						ifFalse: [
							((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1].
							((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2]].
					((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3].
					((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4]].
			((xDiff < 0) & (yDiff >= 0))
				ifTrue: [
					((xDiff abs) > (yDiff abs))
						ifTrue: [
							((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3].
							((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1]] 
						ifFalse: [
							((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1].
							((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3]].
					((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2].
					((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4]].
			((xDiff >= 0) & (yDiff < 0))
				ifTrue: [
					((xDiff abs) > (yDiff abs))
						ifTrue: [
							((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2].
							((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4]] 
						ifFalse: [
							((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4].
							((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2]].
					((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3].
					((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1]].
			((xDiff < 0) & (yDiff < 0))
				ifTrue: [
					((xDiff abs) > (yDiff abs))
						ifTrue: [
							((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3].
							((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4]] 
						ifFalse: [
							((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4].
							((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3]].
					((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2].
					((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1]].
			
			ghostDirections at: 1 put: decision].
					
	ghostPositions at: 1 put: ((ghostPositions at: 1) + (directions at: (ghostDirections at: 1))).
				
	(((ghostPositions at: 1) x) < -20)
		ifTrue: [ghostPositions at: 1 put: 600@((ghostPositions at: 1) y)].
	(((ghostPositions at: 1) x) > 600)
		ifTrue: [ghostPositions at: 1 put: -20@((ghostPositions at: 1) y)].
		
		
		
		
		
]

{ #category : 'Not categorized' }
PacmanWindow >> moveUnreleased [

	| directions |
	
	directions := OrderedCollection 
		with: 0@-5 with: -5@0 with: 5@0 with: 0@5.
	
	1 to: (ghostPositions size) do: [:a |
		((a ~= beingReleased) & ((ghostOnBoard at: a) = false))
			ifTrue: [
				ghostLastPositions at: a put: (ghostPositions at: a).
				(((ghostPositions at: a) y) < 295)
					ifTrue: [ghostDirections at: a put: 4].
				(((ghostPositions at: a) y) > 305)
					ifTrue: [ghostDirections at: a put: 1].
				ghostPositions at: a put: ((ghostPositions at: a) + (directions at: (ghostDirections at: a))).]].
]

{ #category : 'Not categorized' }
PacmanWindow >> offWhite [

	"Color White"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 253 green: 189 blue: 150)
]

{ #category : 'Not categorized' }
PacmanWindow >> open [

	super open.
	
	shell x: 30.
	shell y: 30.
	
	(Highscore isNil)
		ifTrue: [Highscore := 0].
	
	self
		initializeVars;
		registerTimeoutIn: 0
]

{ #category : 'Not categorized' }
PacmanWindow >> poweredTextColor: color [

	| r s |
	r := ((pacPosition x) - 15)@(((pacPosition y) - 15) + 40) extent: 30@30.
	s := ((posText x) - 15)@(((posText y) - 15) + 40) extent: 30@30.

	self 
		foreground: (self black);
		fillRect: s;
		fillRect: r.
	
	1 to: (ghostPositions size) do: [:a |
		((ghostPositions at: a) = posText)
			ifFalse: [
				self
					drawGhostAt: ((ghostPositions at: a) + (0@40))
						direction: (ghostDirections at: a) 
						color: (ghostColors at: a) 
						powered: (powered at: a) 
						return: (ghostReturn at: a)]].
	
	self drawString: (pointsPerGhost printString) x: (posText x) y: ((posText y) + 40) scale: 1 color: color align: 'center' space: 1.
]

{ #category : 'Not categorized' }
PacmanWindow >> red [

	"Color Darkened Blue"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red)
]

{ #category : 'Not categorized' }
PacmanWindow >> redrawDotsAroundPoint: point [

	dotPoints do: [:dot |
		| dist |
		dist := ((((dot x) - (point x)) squared) + (((dot y) - (point y)) squared)) sqrt.
		(dist < 40)
			ifTrue: [
				(powerPellets includes: dot)
					ifTrue: [
						(pelletCount > 8)
							ifTrue: [self drawDotX: (point x) y: ((point y) + 40) radius: 16 color: (self offWhite)]
							ifFalse: [self drawDotX: (point x) y: ((point y) + 40) radius: 16 color: (self black)]]
					ifFalse: [self drawDotX: (dot x) y: ((dot y) + 40) radius: 4 color: (self offWhite)]]].

	
]

{ #category : 'Not categorized' }
PacmanWindow >> registerTimeoutIn: ms [

	timerProcId :=
		CwAppContext default
			addTimeout: ms
			receiver: self
			selector: #timerProc:
			clientData: nil
]

{ #category : 'Not categorized' }
PacmanWindow >> releaseGhost [

	| direction |

	(beingReleased <= 4)
		ifTrue: [
			(ghostOnBoard at: beingReleased)
				ifFalse: [
					"pink"
					(beingReleased = 2)
						ifTrue: [
							ghostLastPositions at: 2 put: (ghostPositions at: 2).
							(releaseCount = 0)
								ifTrue: [
									ghostPositions at: 2 put: 290@300.
									ghostDirections at: beingReleased put: 1.
									ghostOnBoard at: beingReleased put: true]].
					"cyan"
					(beingReleased = 3)
						ifTrue: [
							ghostLastPositions at: 3 put: (ghostPositions at: 3).
							(releaseCount = 0)
								ifTrue: [ghostPositions at: 3 put: 255@300].
							(releaseCount < 7)
								ifTrue: [
									direction := 5@0.
									ghostPositions at: 3 put: ((ghostPositions at: 3) + direction).
									ghostDirections at: beingReleased put: 3]
								ifFalse: [
									ghostDirections at: beingReleased put: 1.
									ghostOnBoard at: beingReleased put: true].
							releaseCount := releaseCount + 1].
					"orange"
					(beingReleased = 4)
						ifTrue: [
							ghostLastPositions at: 4 put: (ghostPositions at: 4).
							(releaseCount = 0)
								ifTrue: [ghostPositions at: 4 put: 325@300].
							(releaseCount < 7)
								ifTrue: [
									direction := -5@0.
									ghostPositions at: 4 put: ((ghostPositions at: 4) + direction).
									ghostDirections at: beingReleased put: 2]
								ifFalse: [
									ghostDirections at: beingReleased put: 1.
									ghostOnBoard at: beingReleased put: true].
							releaseCount := releaseCount + 1]]].
]

{ #category : 'Not categorized' }
PacmanWindow >> removeTimeout [
	"Remove the current timeout."

	CwAppContext default
		removeTimeout: timerProcId.
]

{ #category : 'Not categorized' }
PacmanWindow >> reset [

	lastPosition := 290@480.
	pacPosition := 290@480.
	
	ghostPositions := OrderedCollection 
		with: 290@240 with: 290 @300 with: 255@300 with: 325@300.
	ghostLastPositions := OrderedCollection 
		with: 290@240 with: 290@300 with: 255@300 with: 325@300.
	ghostColors := OrderedCollection 
		with: (self red) with: (self lightPink) with: (self cyan) with: (self lightOrange).	
	ghostDirections := OrderedCollection 
		with: 2 with: 1 with: 4 with: 4.
	ghostOnBoard := OrderedCollection 
		with: true with: false with: false with: false.
	ghostReturn := OrderedCollection 
		with: false with: false with: false with: false.
	powered := OrderedCollection 
		with: false with: false with: false with: false.
	ghostMove := OrderedCollection 
		with: [self moveRed] with: [self movePink] with: [self moveCyan] with: [self moveOrange].
	
	pelletCount := 0. 
	mouthCount := -5.
	enemyCount := 0.
	pacCount := 0.
	pacDirection := 0.
	poweredTimer := 0.
	releaseTimer := 0.
	releaseCount := 0.
	beingReleased := 1.
	ghostWaitingCount := 0.
	startTimer := 0.
	endTimer := 0.
	winTimer := 0.
	collectableTimer := 0.
	fruitCollectedTimer := 0.
	posText := 0@0.
	pointsPerGhost := 100.
	
	moving := false.
	ghostEat := false.
	fruitCollectable := false.
	fruitEaten := false.
	disappear := false.
	
	
	currentDirections := OrderedCollection 
		with: 2 with: 3.
		
	self
		drawBackgroundColor: (self blue);
		drawLevelFruits;
		drawLives;
		drawScore;
		drawHighScore;
		drawString: 'ready!' x: 296 y: 394 scale: 2 color: (self yellow) align: 'center' space: 2;
		drawDots;
		drawPacman;
		drawGhosts
]

{ #category : 'Not categorized' }
PacmanWindow >> returnToBase: ghost [

	| directions opposite num possible xDiff yDiff decision|
	
	directions := OrderedCollection 
		with: 0@-5 with: -5@0 with: 5@0 with: 0@5.
	opposite := OrderedCollection 
		with: 4 with: 3 with: 2 with: 1.
	possible := OrderedCollection new.
	xDiff := ((ghostPositions at: ghost) x) - 290.
	yDiff := ((ghostPositions at: ghost) y) - 240.
	decision := nil.
		
	((((ghostPositions at: ghost) x) = 290) & (((ghostPositions at: ghost) y) = 310))
		ifTrue: [
			ghostDirections at: ghost put: 1.
			ghostReturn at: ghost put: false.
			powered at: ghost put: false].

	ghostLastPositions at: ghost put: (ghostPositions at: ghost).
	
	(pacIntersections includes: (ghostPositions at: ghost))
		ifTrue: [
			num := (pacDecisions at: (pacIntersections indexOf: (ghostPositions at: ghost))).
			(#(1 2 3 4 5 6) includes: num) ifTrue: [possible add: 1].
			(#(0 1 2 4 5 7 8) includes: num) ifTrue: [possible add: 2].
			(#(0 2 3 5 6 8 9) includes: num) ifTrue: [possible add: 3].
			(#(4 5 6 7 8 9) includes: num) ifTrue: [possible add: 4].
			possible remove: (opposite at: (ghostDirections at: ghost)) ifAbsent: [].
			
			((xDiff >= 0) & (yDiff >= 0))
				ifTrue: [
					((xDiff abs) > (yDiff abs))
						ifTrue: [
							((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2].
							((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1]] 
						ifFalse: [
							((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1].
							((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2]].
					((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3].
					((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4]].
			((xDiff < 0) & (yDiff >= 0))
				ifTrue: [
					((xDiff abs) > (yDiff abs))
						ifTrue: [
							((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3].
							((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1]] 
						ifFalse: [
							((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1].
							((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3]].
					((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2].
					((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4]].
			((xDiff >= 0) & (yDiff < 0))
				ifTrue: [
					((xDiff abs) > (yDiff abs))
						ifTrue: [
							((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2].
							((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4]] 
						ifFalse: [
							((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4].
							((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2]].
					((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3].
					((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1]].
			((xDiff < 0) & (yDiff < 0))
				ifTrue: [
					((xDiff abs) > (yDiff abs))
						ifTrue: [
							((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3].
							((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4]] 
						ifFalse: [
							((decision isNil) & (possible includes: 4)) ifTrue: [decision := 4].
							((decision isNil) & (possible includes: 3)) ifTrue: [decision := 3]].
					((decision isNil) & (possible includes: 2)) ifTrue: [decision := 2].
					((decision isNil) & (possible includes: 1)) ifTrue: [decision := 1]].
			((xDiff = 0) & (yDiff = 0))
				ifTrue: [
					decision := 4].
			
			ghostDirections at: ghost put: decision].
					
	ghostPositions at: ghost put: ((ghostPositions at: ghost) + (directions at: (ghostDirections at: ghost))).
				
	(((ghostPositions at: ghost) x) < -20)
		ifTrue: [ghostPositions at: ghost put: 600@((ghostPositions at: ghost) y)].
	(((ghostPositions at: ghost) x) > 600)
		ifTrue: [ghostPositions at: ghost put: -20@((ghostPositions at: ghost) y)].
		
		
		
		
		
]

{ #category : 'Not categorized' }
PacmanWindow >> shellName [

	"Answer the name of the receiver's shell.
	This is used as the default label of the window."

	^'Pacman'
]

{ #category : 'Not categorized' }
PacmanWindow >> skyBlue [
	"Color Blue"
	
	^ shell window getPalette 
		nearestPixelValue: (Color red: 19 green: 191 blue: 227).
]

{ #category : 'Not categorized' }
PacmanWindow >> timerProc: value [
	"This is the timer proc.  Update the display with
	 the current time and register a new timeout."
		
	self drawingArea isDestroyed ifTrue: [^self].
			
	((endTimer = 0) & (winTimer = 0) & (startTimer > 80))
		ifTrue: [
			(pelletCount > 26)
				ifTrue: [pelletCount := 0]
				ifFalse: [pelletCount := pelletCount + 1].
			
			(mouthCount > 5)
				ifTrue: [mouthCount := -5]
				ifFalse: [
					moving
						ifTrue: [mouthCount := mouthCount + 1]].
				
			1 to: 4 do: [:b | | interval |
				((((ghostLastPositions at: b) y) = 300) & ((((ghostLastPositions at: b) x) < 80) | (((ghostLastPositions at: b) x) > 500)))
					ifTrue: [interval := 4] 
					ifFalse: [interval := 3].
				(ghostReturn at: b)
					ifTrue: [
						((enemyCount \\ 1) = 0)
							ifTrue: [self returnToBase: b]]
					ifFalse: [
						(powered at: b)
							ifTrue: [
								((enemyCount \\ 4) = 0)
									ifTrue: [
										(ghostOnBoard at: b) ifTrue: [self moveAwayGhost: b]]]
							ifFalse: [
								((enemyCount \\ interval) = 0)
									ifTrue: [
										(ghostOnBoard at: b) ifTrue: [(ghostMove at: b) value]]]]].
			((enemyCount \\ 4) = 0)
				ifTrue: [
					self 
						releaseGhost;
						moveUnreleased].
			enemyCount := enemyCount + 1.
				
			 (pacCount = 1)
				ifTrue: [
					self movePacman.
					pacCount := 0] 
				ifFalse: [pacCount := pacCount + 1].
						
			(poweredTimer = powerTime)
				ifTrue: [
					powered := powered collect: [: a | true]].
			(poweredTimer = 0)
				ifTrue: [
					powered := powered collect: [: a | false].
					pointsPerGhost := 100].
			poweredTimer := poweredTimer - 1.
				
			((releaseTimer\\ 480) = 10)
				ifTrue: [
					releaseCount := 0.
					beingReleased := beingReleased + 1].
			releaseTimer := releaseTimer + 1.
			
			(collectableTimer > 0)
				ifTrue: [collectableTimer := collectableTimer - 1]
				ifFalse: [
					fruitCollectable := false.
					self drawCollectableFruitVisible: false].
					
			(fruitCollectedTimer > 1)
				ifTrue: [
					fruitCollectedTimer := fruitCollectedTimer - 1.
					self drawFruitCollectedText]
				ifFalse: [
					(fruitCollectedTimer = 1)
						ifTrue: [
							fruitCollectedTimer := fruitCollectedTimer - 1.
							self drawFruitCollectedText]
						ifFalse: [fruitEaten := false]].
				
			self
				eatDots;
				drawPellets].
				
	(endTimer > 0)
		ifTrue: [endTimer := endTimer + 1].
	(winTimer > 0)
		ifTrue: [
			winTimer := winTimer + 1.
			self endAnimation].
	startTimer := startTimer + 1.
	
	disappear := false.
	self drawGhosts.
			
	((endTimer = 0) & (winTimer = 0) & (startTimer > 80))
		ifTrue: [
			self checkForCollision].
			
	(startTimer = 80)
		ifTrue: [self drawString: 'ready!' x: 296 y: 394 scale: 2 color: (self black) align: 'center' space: 2].
				
	ghostEat
		ifTrue: [
			self registerTimeoutIn: 500.
			self poweredTextColor: (self cyan).
			disappear := true.
			ghostEat := false]
		ifFalse: [self registerTimeoutIn: 15].
]

{ #category : 'Not categorized' }
PacmanWindow >> white [

	"Color White"
	
	^ shell window getPalette 
		nearestPixelValue: Color white
]

{ #category : 'Not categorized' }
PacmanWindow >> yellow [

	"Color Red"
	
	^ shell window getPalette 
		nearestPixelValue: Color yellow
			
			
			
			
			
			
]
