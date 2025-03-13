"
A SonarqubeApiTest is a test class for testing the behavior of SonarqubeApi
"
Class {
	#name : 'SonarqubeApiTest',
	#superclass : 'TestCase',
	#category : 'SonarqubePharoAPI-Tests',
	#package : 'SonarqubePharoAPI-Tests'
}

{ #category : 'tests' }
SonarqubeApiTest >> testFormatDate [

	| date sonarqubeApi sonarDate |
	"Given"
	date := '2025-09-26T13:35:18+00:00' asDateAndTime.

	sonarqubeApi := SonarqubeApi new.


	"When"
	sonarDate := sonarqubeApi formatDate: date.


	"Then"
	self assert: sonarDate equals: '2025-09-26T13:35:18+0000'
]

{ #category : 'tests' }
SonarqubeApiTest >> testFormatDate2 [

	| date sonarqubeApi sonarDate |
	"Given"
	date := '2025-03-06T15:44:10.507+01:00' asDateAndTime.

	sonarqubeApi := SonarqubeApi new.


	"When"
	sonarDate := sonarqubeApi formatDate: date.


	"Then"
	self assert: sonarDate equals: '2025-03-06T15:44:11+0100'
]
