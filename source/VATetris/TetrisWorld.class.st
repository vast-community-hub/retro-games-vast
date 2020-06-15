Class {
	#name : 'TetrisWorld',
	#superclass : 'Object',
	#instVars : [
		'gameGrid',
		'frameTimer',
		'frameInterval',
		'currentFrameInterval',
		'fallingBlock',
		'blockQueue',
		'randomNumberGenerator',
		'level',
		'score',
		'blockCount',
		'gameOn'
	],
	#category : 'VATetris'
}

{ #category : 'IS_generated',
  #vaVisibility : 'private' }
TetrisWorld class >> _PRAGMA_IS_ [

	"%%PRAGMA DECLARE
	(name: IS_TetrisWorld isPool: true isConstant: false)
	(pool: IS_TetrisWorld declarations: (
		(name: IS_gameEnded isConstant: false)
		(name: IS_score isConstant: false)
		(name: IS_frameAdvanced isConstant: false)
		(name: IS_newBlockAdded isConstant: false)
		(name: IS_level isConstant: false)
		(name: IS_instanceInterfaceSpec isConstant: false)
	))"
]

{ #category : 'IS_generated',
  #vaVisibility : 'private' }
TetrisWorld class >> abtPrimFlushInterfaceSpecCache [

	IS_TetrisWorld associationsDo: [: poolDictionaryAssoc | poolDictionaryAssoc value: nil].
	super abtPrimFlushInterfaceSpecCache
]

{ #category : 'IS_generated',
  #vaVisibility : 'private' }
TetrisWorld class >> IS_frameAdvanced [
	"Private - ** Warning ** This method is generated by VisualAge and should not
	be modified or deleted. This method is responsible for returning a featureSpec
	that describes the implementation of a particular feature of the receiver"

	^IS_TetrisWorld::IS_frameAdvanced notNil
		ifTrue: [IS_TetrisWorld::IS_frameAdvanced]
		ifFalse: [
		IS_TetrisWorld::IS_frameAdvanced := (AbtEventSpec new
		 symbol: #frameAdvanced)]
]

{ #category : 'IS_generated',
  #vaVisibility : 'private' }
TetrisWorld class >> IS_gameEnded [
	"Private - ** Warning ** This method is generated by VisualAge and should not
	be modified or deleted. This method is responsible for returning a featureSpec
	that describes the implementation of a particular feature of the receiver"

	^IS_TetrisWorld::IS_gameEnded notNil
		ifTrue: [IS_TetrisWorld::IS_gameEnded]
		ifFalse: [
		IS_TetrisWorld::IS_gameEnded := (AbtEventSpec new
		 symbol: #gameEnded)]
]

{ #category : 'IS_generated',
  #vaVisibility : 'private' }
TetrisWorld class >> IS_instanceInterfaceSpec [
	"Private - ** Warning ** This method is generated by VisualAge and should not
	be modified or deleted. This method is responsible for returning a featureSpec
	that describes the implementation of a particular feature of the receiver"

	^IS_TetrisWorld::IS_instanceInterfaceSpec notNil
		ifTrue: [IS_TetrisWorld::IS_instanceInterfaceSpec]
		ifFalse: [
		IS_TetrisWorld::IS_instanceInterfaceSpec := AbtInterfaceSpec new
		featureNamed: #gameEnded put: self IS_gameEnded;
		featureNamed: #score put: self IS_score;
		featureNamed: #frameAdvanced put: self IS_frameAdvanced;
		featureNamed: #newBlockAdded put: self IS_newBlockAdded;
		featureNamed: #level put: self IS_level]
]

{ #category : 'IS_generated',
  #vaVisibility : 'private' }
TetrisWorld class >> IS_level [
	"Private - ** Warning ** This method is generated by VisualAge and should not
	be modified or deleted. This method is responsible for returning a featureSpec
	that describes the implementation of a particular feature of the receiver"

	^IS_TetrisWorld::IS_level notNil
		ifTrue: [IS_TetrisWorld::IS_level]
		ifFalse: [
		IS_TetrisWorld::IS_level := (AbtAttributeSpec new
		 attributeType: Integer;
		 setSelector: #level:;
		 getSelector: #level;
		 changeSymbol: #level)]
]

{ #category : 'IS_generated',
  #vaVisibility : 'private' }
TetrisWorld class >> IS_newBlockAdded [
	"Private - ** Warning ** This method is generated by VisualAge and should not
	be modified or deleted. This method is responsible for returning a featureSpec
	that describes the implementation of a particular feature of the receiver"

	^IS_TetrisWorld::IS_newBlockAdded notNil
		ifTrue: [IS_TetrisWorld::IS_newBlockAdded]
		ifFalse: [
		IS_TetrisWorld::IS_newBlockAdded := (AbtEventSpec new
		 symbol: #newBlockAdded)]
]

{ #category : 'IS_generated',
  #vaVisibility : 'private' }
TetrisWorld class >> IS_score [
	"Private - ** Warning ** This method is generated by VisualAge and should not
	be modified or deleted. This method is responsible for returning a featureSpec
	that describes the implementation of a particular feature of the receiver"

	^IS_TetrisWorld::IS_score notNil
		ifTrue: [IS_TetrisWorld::IS_score]
		ifFalse: [
		IS_TetrisWorld::IS_score := (AbtAttributeSpec new
		 attributeType: Integer;
		 setSelector: #score:;
		 getSelector: #score;
		 changeSymbol: #score)]
]

{ #category : 'API' }
TetrisWorld class >> new [

	^super new initialize
]

{ #category : 'API' }
TetrisWorld class >> on: aTetrisDrawablePart [

	^self new
		gameGrid: aTetrisDrawablePart;
		yourself
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
TetrisWorld >> advanceFrame: aClient [

	( gameGrid notNil ) ifFalse: [ ^nil ].
	( self gameOn = true ) ifFalse: [ ^nil ].

	"If there is currently no falling block, create a new one, and set it to start in the middle of the gameGrid."
	( fallingBlock notNil ) ifFalse: [
		fallingBlock := self getNextBlock.
		gameGrid registerFallingBlock: fallingBlock.
		self signalEvent: #newBlockAdded.
	].

	"Move the block down one row, and redraw."
	self stepFallingBlockDown.

	( self gameOn )
		ifTrue: [
			self startFrameTimer.
			self signalEvent: #frameAdvanced.
		]
		ifFalse: [ self signalEvent: #gameEnded ].

	^aClient
]

{ #category : 'Accessors' }
TetrisWorld >> blockCount [

	^blockCount
]

{ #category : 'Accessors' }
TetrisWorld >> blockCount: anInteger [

	blockCount := anInteger
]

{ #category : 'API' }
TetrisWorld >> ccwRotateFallingBlock [

	| testBlock |

	( fallingBlock notNil ) ifFalse: [ ^nil ].

	"Make a copy of the fallingBlock, and move it appropriately,
	  so we can check the viability of its next position.
	  If the next position is viable, then we apply the move to the
	  actual fallingBlock."
	testBlock := fallingBlock copy
		rotateCCW;
		yourself.

	( gameGrid checkViabilityOf: testBlock ) ifTrue: [
		fallingBlock rotateCCW.
		self refreshGameGrid.
	].

	^fallingBlock
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
TetrisWorld >> createNewBlock [

	^TetrisBlock randomTypeUsing: randomNumberGenerator
]

{ #category : 'API' }
TetrisWorld >> cwRotateFallingBlock [

	| testBlock |

	( fallingBlock notNil ) ifFalse: [ ^nil ].

	"Make a copy of the fallingBlock, and move it appropriately,
	  so we can check the viability of its next position.
	  If the next position is viable, then we apply the move to the
	  actual fallingBlock."
	testBlock := fallingBlock copy
		rotateCW;
		yourself.

	( gameGrid checkViabilityOf: testBlock ) ifTrue: [
		fallingBlock rotateCW.
		self refreshGameGrid.
	].

	^fallingBlock
]

{ #category : 'API' }
TetrisWorld >> dropFallingBlock [

	( fallingBlock notNil ) ifFalse: [ ^nil ].

	self removeFrameTimer.
	currentFrameInterval := 5.
	self startFrameTimer.

	^fallingBlock
]

{ #category : 'Accessors' }
TetrisWorld >> frameTimer [

	^frameTimer
]

{ #category : 'Accessors' }
TetrisWorld >> gameGrid [

	^gameGrid
]

{ #category : 'Accessors' }
TetrisWorld >> gameGrid: aTetrisDrawablePart [

	gameGrid := aTetrisDrawablePart
]

{ #category : 'Accessors' }
TetrisWorld >> gameOn [

	^gameOn
]

{ #category : 'Accessors' }
TetrisWorld >> gameOn: aBoolean [

	gameOn := aBoolean
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
TetrisWorld >> getNextBlock [

	| nextBlock newBlock |
	newBlock := self createNewBlock.

	"Set the location of the new block to be centered left to write, and above the grid by its own height."
	nextBlock := blockQueue removeFirst.
	nextBlock location: (((gameGrid columnCount - nextBlock width) // 2) @ nextBlock height negated).

	blockQueue addLast: newBlock.

	^nextBlock
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
TetrisWorld >> incrementLevel [

	self level: (self level + 1).

	frameInterval := frameInterval // 2.
	currentFrameInterval := frameInterval.

	^self level
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
TetrisWorld >> initialize [

	^self
		blockCount: 0;
		level: 1;
		score: 0;
		yourself
]

{ #category : 'Accessors' }
TetrisWorld >> level [
	"Return the value of level."

	^level
]

{ #category : 'Accessors' }
TetrisWorld >> level: anInteger [
	"Save the value of level."

	level := anInteger.
	self signalEvent: #level
		 with: anInteger.
]

{ #category : 'API' }
TetrisWorld >> pauseGame [

	self removeFrameTimer.

	^self
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
TetrisWorld >> refreshGameGrid [

	^gameGrid ifNotNil: [ :part | part refresh ]
]

{ #category : 'Timer',
  #vaVisibility : 'private' }
TetrisWorld >> removeFrameTimer [

	( frameTimer notNil ) ifFalse: [ ^nil ].

	^CwAppContext default removeTimeout: frameTimer
]

{ #category : 'API' }
TetrisWorld >> resetGame [

	frameInterval := nil.
	blockQueue := nil.
	fallingBlock := nil.

	self gameGrid ifNotNil: [ :part | part reset ].

	^self
		blockCount: 0;
		score: 0;
		level: 1;
		gameOn: nil;
		yourself
]

{ #category : 'Accessors' }
TetrisWorld >> score [
	"Return the value of score."

	^score
]

{ #category : 'Accessors' }
TetrisWorld >> score: anInteger [
	"Save the value of score."

	score := anInteger.
	self signalEvent: #score
		 with: anInteger.
]

{ #category : 'API' }
TetrisWorld >> shiftFallingBlockLeft [

	| testBlock |

	( fallingBlock notNil ) ifFalse: [ ^nil ].

	"Make a copy of the fallingBlock, and move it appropriately,
	  so we can check the viability of its next position.
	  If the next position is viable, then we apply the move to the
	  actual fallingBlock."
	testBlock := fallingBlock copy
		shiftLeft;
		yourself.

	( gameGrid checkViabilityOf: testBlock ) ifTrue: [
		fallingBlock shiftLeft.
		self refreshGameGrid.
	].

	^fallingBlock
]

{ #category : 'API' }
TetrisWorld >> shiftFallingBlockRight [

	| testBlock |

	( fallingBlock notNil ) ifFalse: [ ^nil ].

	"Make a copy of the fallingBlock, and move it appropriately,
	  so we can check the viability of its next position.
	  If the next position is viable, then we apply the move to the
	  actual fallingBlock."
	testBlock := fallingBlock copy
		shiftRight;
		yourself.

	( gameGrid checkViabilityOf: testBlock ) ifTrue: [
		fallingBlock shiftRight.
		self refreshGameGrid.
	].

	^fallingBlock
]

{ #category : 'Timer',
  #vaVisibility : 'private' }
TetrisWorld >> startFrameTimer [

	frameTimer := CwAppContext default
		addTimeout: currentFrameInterval
		receiver: self
		selector: #advanceFrame:
		clientData: nil.
]

{ #category : 'API' }
TetrisWorld >> startGame [

	"We can only start/restart a game, if the current game has not already ended...meaning
	  <gameOn> has not yet been set to false."
	( self gameOn = false ) ifTrue: [ ^nil ].

	( frameInterval notNil ) ifFalse: [ frameInterval := 1000 ].
	currentFrameInterval := frameInterval.

	( randomNumberGenerator notNil ) ifFalse: [ randomNumberGenerator := EsRandom new ].
	( blockQueue notNil ) ifFalse: [ blockQueue := OrderedCollection new: 3 ].

	3 timesRepeat: [ blockQueue addLast: self createNewBlock ].

	self gameOn: true.
	self startFrameTimer.

	^self
]

{ #category : 'API' }
TetrisWorld >> stepFallingBlockDown [

	| testBlock |

	( fallingBlock notNil ) ifFalse: [ ^nil ].

	"Make a copy of the fallingBlock, and move it appropriately,
	  so we can check the viability of its next position.
	  If the next position is viable, then we apply the move to the
	  actual fallingBlock."
	testBlock := fallingBlock copy
		stepDown;
		yourself.

	"If viability fails on the downward step, then we are likely going to
	  lock that block in place.  We do want to give the user another chance,
	  though, to move it into a better position."
	( gameGrid checkViabilityOf: testBlock )
		ifTrue: [
			fallingBlock stepDown.
			self refreshGameGrid.
		]
		ifFalse: [ | clearedRowCount |
			( fallingBlock isStuck )
				ifTrue: [
					"Reset the currentFrameInterval to be the normal value.
					  This may have been changed to drop a block."
					currentFrameInterval := frameInterval.

					"We increase the level every 20 objects."
					self blockCount: (self blockCount + 1).
					( (self blockCount \\ 20) = 0 ) ifTrue: [ self incrementLevel ].

					gameGrid setFallingBlockAsStationary.

					"If the fallingBlock has become stationary, but is not fully on the
					  gameGrid, then the game is over."
					( fallingBlock location y < 0 ) ifTrue: [
						self gameOn: false.
						^nil
					].

					fallingBlock := nil.

					( (clearedRowCount := gameGrid clearFullRows) > 0 )
						ifTrue: [ self score: (self score + (clearedRowCount * 10 * self level)) ].
				]
				ifFalse: [ fallingBlock isStuck: true ].
		].

	^fallingBlock
]

{ #category : 'API' }
TetrisWorld >> upcomingBlocks [

	^blockQueue
]