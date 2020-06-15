Class {
	#name : 'TetrisBlock',
	#superclass : 'Object',
	#instVars : [
		'orientation',
		'location',
		'isStuck'
	],
	#category : 'VATetris'
}

{ #category : 'API' }
TetrisBlock class >> new [

	^super new initialize
]

{ #category : 'API' }
TetrisBlock class >> ofTypeIndex: anInteger [

	^(self allSubclasses at: anInteger) new
]

{ #category : 'API' }
TetrisBlock class >> randomTypeUsing: anEsRandom [

	| index |
	index := anEsRandom nextInt: self allSubclasses size.

	^self ofTypeIndex: index
]

{ #category : 'API' }
TetrisBlock >> colour [

	^0
]

{ #category : 'API' }
TetrisBlock >> footprint [
	"Answer an Array, indicating the occupied/empty cells related to the receiver,
	  relative to the receiver's location (top left corner)."

	^self subclassResponsibility
]

{ #category : 'API' }
TetrisBlock >> height [
	"Answer the height of the receiver, as number of cells, in the current orientation."

	^self footprint size
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
TetrisBlock >> initialize [

	^self
		orientation: 1;
		location: (0 @ 0);
		isStuck: false;
		yourself
]

{ #category : 'Accessors' }
TetrisBlock >> isStuck [

	^isStuck
]

{ #category : 'Accessors' }
TetrisBlock >> isStuck: aBoolean [

	isStuck := aBoolean
]

{ #category : 'Accessors' }
TetrisBlock >> location [

	^location
]

{ #category : 'Accessors' }
TetrisBlock >> location: aPoint [

	location := aPoint
]

{ #category : 'API' }
TetrisBlock >> markOccupiedCellsIn: anArray at: aPoint [
	"Mark the receiver's occupied cells in the provided Array,
	  relative to the provided Point."

	"Iterate over each row of the receiver's footprint,
	  checking each row for occupied cells.  When an occupied cell is found,
	  we mark that cell in anArray.
	  We must check the location of each cell we are filling in,
	  since this block may have been stuck in a position such that its top is above
	  the game grid (ie. only the bottom part is showing)."
	self footprint doWithIndex: [ :row :rowIndex |
		row doWithIndex: [ :indicator :columnIndex |
			( indicator = 1 ) ifTrue: [ | cellLocation |
				cellLocation := aPoint + (columnIndex @ rowIndex).
				( cellLocation y > 0 ) ifTrue: [ (anArray at: cellLocation y) at: cellLocation x put: self colour ].
			].
		].
	].

	^anArray
]

{ #category : 'Accessors' }
TetrisBlock >> orientation [

	^orientation
]

{ #category : 'Accessors' }
TetrisBlock >> orientation: anInteger [

	orientation := anInteger
]

{ #category : 'API' }
TetrisBlock >> overlapsCellsIn: anArray at: aPoint [
	"Answer a Boolean, indicating whether or not any occupied cell of the
	  receiver, overlaps with any occupied cell in anArray."

	"Iterate over each row of the receiver's footprint,
	  checking each row for occupied cells.  When an occupied cell is found,
	  we check to see if the corresponding cell in anArray is already occupied."
	self footprint doWithIndex: [ :row :rowIndex |
		row doWithIndex: [ :indicator :columnIndex |
			( indicator = 1 ) ifTrue: [ | cellLocation |
				cellLocation := aPoint + (columnIndex @ rowIndex).

				"Check to see if we are looking above the grid.
				  Since all blocks start above the grid, we must do this check."
				( cellLocation y > 0 )
					ifTrue: [ ( ((anArray at: cellLocation y) at: (cellLocation x)) notNil ) ifTrue: [ ^true ] ].
			].
		].
	].

	^false
]

{ #category : 'API' }
TetrisBlock >> rotateCCW [

	orientation := orientation - 1.
	( orientation > 0 ) ifFalse: [ orientation := 4 ].

	^orientation
]

{ #category : 'API' }
TetrisBlock >> rotateCW [

	orientation := orientation + 1.
	( orientation < 5 ) ifFalse: [ orientation := 1 ].

	^orientation
]

{ #category : 'API' }
TetrisBlock >> shiftLeft [

	self location: (self location + (-1 @ 0)).

	^self location
]

{ #category : 'API' }
TetrisBlock >> shiftRight [

	self location: (self location + (1 @ 0)).

	^self location
]

{ #category : 'API' }
TetrisBlock >> stepDown [

	self location: (self location + (0 @ 1)).

	^self location
]

{ #category : 'API' }
TetrisBlock >> width [
	"Answer the width of the receiver, as number of cells, in the current orientation."

	| width |
	width := 0.

	self footprint do: [ :row | width := width max: row size ].

	^width
]
