Class {
	#name : 'TowerOfHanoiDisk',
	#superclass : 'Object',
	#instVars : [
		'number',
		'width',
		'color'
	],
	#category : 'TowerOfHanoi'
}

{ #category : 'Not categorized' }
TowerOfHanoiDisk >> color [

	^color
]

{ #category : 'Not categorized' }
TowerOfHanoiDisk >> number [

	^number
]

{ #category : 'Not categorized' }
TowerOfHanoiDisk >> number: num width: w color: c [

	number := num.
	width := w.
	color := c.
]

{ #category : 'Not categorized' }
TowerOfHanoiDisk >> width [

	^width
]
