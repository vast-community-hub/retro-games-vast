Class {
	#name : 'TetrisRightStepBlock',
	#superclass : 'TetrisBlock',
	#category : 'VATetris'
}

{ #category : 'API' }
TetrisRightStepBlock >> colour [

	^10
]

{ #category : 'API' }
TetrisRightStepBlock >> footprint [
	"Answer an Array, indicating the occupied/empty cells related to the receiver,
	  relative to the receiver's location (top left corner)."

	^( orientation odd )
		ifTrue: [ #(#(0 1 1) #(1 1 0)) ]
		ifFalse: [ #(#(1 0) #(1 1) #(0 1)) ]
]
