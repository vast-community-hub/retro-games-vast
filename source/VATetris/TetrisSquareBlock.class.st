Class {
	#name : 'TetrisSquareBlock',
	#superclass : 'TetrisBlock',
	#category : 'VATetris'
}

{ #category : 'API' }
TetrisSquareBlock >> colour [

	^9
]

{ #category : 'API' }
TetrisSquareBlock >> footprint [
	"Answer an Array, indicating the occupied/empty cells related to the receiver,
	  relative to the receiver's location (top left corner)."

	"We do not need to consider the orientation for a square."
	^#(#(1 1) #(1 1))
]
