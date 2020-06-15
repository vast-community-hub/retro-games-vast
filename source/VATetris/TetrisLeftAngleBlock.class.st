Class {
	#name : 'TetrisLeftAngleBlock',
	#superclass : 'TetrisBlock',
	#category : 'VATetris'
}

{ #category : 'API' }
TetrisLeftAngleBlock >> colour [

	^11
]

{ #category : 'API' }
TetrisLeftAngleBlock >> footprint [
	"Answer an Array, indicating the occupied/empty cells related to the receiver,
	  relative to the receiver's location (top left corner)."

	( orientation = 1 ) ifTrue: [ ^#(#(0 1) #(0 1) #(1 1) ) ].
	( orientation = 2 ) ifTrue: [ ^#(#(1 0 0) #(1 1 1)) ].
	( orientation = 3 ) ifTrue: [ ^#(#(1 1) #(1 0) #(1 0)) ].
	( orientation = 4 ) ifTrue: [ ^#(#(1 1 1) #(0 0 1)) ].

	^nil
]
