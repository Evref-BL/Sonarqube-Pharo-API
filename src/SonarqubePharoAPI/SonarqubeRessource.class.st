Class {
	#name : 'SonarqubeRessource',
	#superclass : 'Object',
	#instVars : [
		'sonarqubeApi'
	],
	#category : 'SonarqubePharoAPI',
	#package : 'SonarqubePharoAPI'
}

{ #category : 'error handling' }
SonarqubeRessource >> errorResponse: response [

	| reason msg |
	reason := (NeoJSONReader fromString: response contents)
		          at: 'errors'
		          ifPresent: [ :errors | errors first at: 'msg' ].

	msg := String streamContents: [ :s |
		       s << 'SonarQube API error '.
		       s print: response status.
		       reason ifNotNil: [ s << ': ' << reason ] ].

	Error signal: msg
]

{ #category : 'api' }
SonarqubeRessource >> getAll: itemName inEndpoint: endpoint withParams: paramsDict [

	| items page |
	sonarqubeApi prepareClient.
	sonarqubeApi client path: sonarqubeApi basePath , endpoint.

	paramsDict keysAndValuesDo: [ :key :value |
		sonarqubeApi client queryAt: key put: value ].

	items := OrderedCollection new.
	page := 1.

	[
	| newItems response results |
	response := self getWithRetries.
	response status ~= 200 ifTrue: [ self errorResponse: response ].

	results := NeoJSONReader fromString: response contents.
	newItems := results at: itemName.
	items addAll: newItems.

	page := page + 1.
	sonarqubeApi client queryAt: #p put: page.

	"SonarQube api can't return more than 10000 values"
	newItems isEmpty or: [ items size = 10000 ] ] whileFalse.

	^ items
]

{ #category : 'api' }
SonarqubeRessource >> getWithRetries [

	| numberOfRetries retryCount retryDelay response |
	numberOfRetries := 3.
	retryCount := 0.
	retryDelay := self initialRetryDelay.

	[
	sonarqubeApi client get.
	response := sonarqubeApi client response.
	response status ~= 200 and: [ retryCount < numberOfRetries ] ]
		whileTrue: [
			| stdout |
			retryCount := retryCount + 1.

			(stdout := self stdout) << 'Retrying SonarQube API request in '.
			retryDelay printHumanReadableOn: stdout.
			stdout << ' (' << retryCount asString << '/'
			<< numberOfRetries asString << ')'.
			stdout lf.

			retryDelay wait.
			retryDelay := retryDelay * 2 ].

	^ response
]

{ #category : 'constants' }
SonarqubeRessource >> initialRetryDelay [

	^ 1 minute
]

{ #category : 'accessing' }
SonarqubeRessource >> sonarqubeApi: anObject [

	sonarqubeApi := anObject
]

{ #category : 'constants' }
SonarqubeRessource >> stdout [

	^ Stdio stdout
]
