Class {
	#name : 'TetrisStraightBlock',
	#superclass : 'TetrisBlock',
	#category : 'VATetris'
}

{ #category : 'API' }
TetrisStraightBlock >> colour [

	^1
]

{ #category : 'API' }
TetrisStraightBlock >> footprint [
	"Answer an Array, indicating the occupied/empty cells related to the receiver,
	  relative to the receiver's location (top left corner)."

	^( orientation odd )
		ifTrue: [ #(#(1) #(1) #(1) #(1)) ]
		ifFalse: [ #(#(1 1 1 1)) ]
]
