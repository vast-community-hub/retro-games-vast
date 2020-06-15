Class {
	#name : 'Snake',
	#superclass : 'Application',
	#instVars : [
		'gc'
	],
	#classInstVars : [
		'board'
	],
	#category : 'Snake'
}

{ #category : 'Not categorized' }
Snake >> gc [
	"Answer the CgGC to use for the test."

	^gc
]

{ #category : 'Not categorized' }
Snake >> isRealized [
	"Answer a Boolean indicating whether the
	 drawing area widget has been realized."

	| widget |

	^(widget := self drawingArea) notNil
		and: [widget isRealized]
]

{ #category : 'Not categorized' }
Snake >> mainWindowArgs [
	"Answer an argBlock containing some default width and height settings."

	^[:w | w width: 500; height: 365]
]
