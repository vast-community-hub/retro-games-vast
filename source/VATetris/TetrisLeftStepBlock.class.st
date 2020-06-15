Class {
	#name : 'TetrisLeftStepBlock',
	#superclass : 'TetrisBlock',
	#category : 'VATetris'
}

{ #category : 'API' }
TetrisLeftStepBlock >> colour [

	^7
]

{ #category : 'API' }
TetrisLeftStepBlock >> footprint [
	"Answer an Array, indicating the occupied/empty cells related to the receiver,
	  relative to the receiver's location (top left corner)."

	^( orientation odd )
		ifTrue: [ #(#(1 1 0) #(0 1 1)) ]
		ifFalse: [ #(#(0 1) #(1 1) #(1 0)) ]
]
