Class {
	#name : 'TetrisRightAngleBlock',
	#superclass : 'TetrisBlock',
	#category : 'VATetris'
}

{ #category : 'API' }
TetrisRightAngleBlock >> colour [

	^5
]

{ #category : 'API' }
TetrisRightAngleBlock >> footprint [
	"Answer an Array, indicating the occupied/empty cells related to the receiver,
	  relative to the receiver's location (top left corner)."

	( orientation = 1 ) ifTrue: [ ^#(#(1 0) #(1 0) #(1 1) ) ].
	( orientation = 2 ) ifTrue: [ ^#(#(1 1 1) #(1 0 0)) ].
	( orientation = 3 ) ifTrue: [ ^#(#(1 1) #(0 1) #(0 1)) ].
	( orientation = 4 ) ifTrue: [ ^#(#(0 0 1) #(1 1 1)) ].

	^nil
]
