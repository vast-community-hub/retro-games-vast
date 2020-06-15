Class {
	#name : 'VATetris',
	#superclass : 'Application',
	#classVars : [
		'Snapshots'
	],
	#category : 'VATetris'
}

{ #category : '-',
 #vaCategories : ['-','AbtEdit','AutoGen'],
  #vaVisibility : 'private' }
VATetris class >> abtIsViewApplication [

	^true
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
VATetris class >> restartSavedSnapshots: aTimer [

	Snapshots do: [:snapshot | snapshot restart].
	Snapshots := OrderedCollection new
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
VATetris class >> saving [

	Snapshots := OrderedCollection new.

	self tetrisWindows do: [:window |
		Snapshots add: (
			CwWidgetHierarchySnapshot
				getSnapshot: #defaultResourceSnapshotInfo
				forWidgets: window snapshotWidgets
				owner: window
				restartSelector: #restartWindowFromSnapshot:)]
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
VATetris class >> startUp [
	"Start the development environment user interface."

	Snapshots size = 0 "nil or empty"
		ifFalse: [
			CwAppContext default addWorkProc: self selector: #restartSavedSnapshots: clientData: nil]
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
VATetris class >> tetrisWindows [
	"Answer a collection of all instances that have realized shells."

	| result |

	result := OrderedCollection new.
	CwTopLevelShell all do: [:x |
		(('VA Blox' match: x title) and: [x isRealized]) ifTrue: [result add: x userData]].
	^result
]
