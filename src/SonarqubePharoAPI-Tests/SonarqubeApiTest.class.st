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
SonarqubeApiTest >> testChangePharoDateTimeIntoSonarDateTime [

	| date sonarqubeApi sonarDate |
	
	"Given"
	date := DateAndTime year: 2025 month: 09 day:  26 hour: 13 minute: 35 second: 18.
	
	sonarqubeApi := SonarqubeApi new.
	
	
	"When"
	sonarDate := sonarqubeApi changePharoDateTimeIntoSonarDateTime: date.
	
	
	"Then"
	self assert: sonarDate equals: '2025-09-26T13:35:18+0100'.
	
	
]
