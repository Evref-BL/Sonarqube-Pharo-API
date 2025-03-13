Class {
	#name : 'SonarqubeRessource',
	#superclass : 'Object',
	#instVars : [
		'sonarqubeApi'
	],
	#category : 'SonarqubePharoAPI',
	#package : 'SonarqubePharoAPI'
}

{ #category : 'as yet unclassified' }
SonarqubeRessource >> getAll: itemName inEndpoint: endpoint withParams: paramsDict [

	| items results page |
	sonarqubeApi prepareClient.
	sonarqubeApi client path: sonarqubeApi basePath , endpoint.

	paramsDict keysAndValuesDo: [ :key :value |
		sonarqubeApi client queryAt: key put: value ].

	items := OrderedCollection new.
	page := 1.

	[
	| newItems |
	"Sonarqube api can't return more than 10000 values"
	items size = 10000 ifTrue: [ ^ items ].

	results := sonarqubeApi client get.
	results := (NeoJSONReader on: results readStream) next.
	newItems := results at: itemName.
	items addAll: newItems.

	page := page + 1.
	sonarqubeApi client queryAt: #p put: page.

	newItems isNotEmpty ] whileTrue.

	^ items
]

{ #category : 'accessing' }
SonarqubeRessource >> sonarqubeApi: anObject [

	sonarqubeApi := anObject
]
