"
A SonarqubeIssuesTest is a test class for testing the behavior of SonarqubeIssues
"
Class {
	#name : 'SonarqubeIssuesTest',
	#superclass : 'TestCase',
	#category : 'SonarqubePharoAPI-Tests',
	#package : 'SonarqubePharoAPI-Tests'
}

{ #category : 'tests' }
SonarqubeIssuesTest >> testSearchWithParams [


	| hostUrl client endpoint response result params sonarqubeApi sonarqubeIssues |
	
	"Given"
	hostUrl := 'www.url.com'.
	client := Mock new.

	sonarqubeApi := SonarqubeApi new
		                privateToken: 'token';
		                host: hostUrl;
		                client: client.

	sonarqubeIssues := SonarqubeIssues new
		                            sonarqubeApi: sonarqubeApi.


	params := { (#project -> 'test') } asDictionary.

	endpoint := '/issues/search'.

	response := { (#message -> 'message') } asDictionary.

	(sonarqubeIssues stub
		 getAll: 'issues'
		 inEndpoint: endpoint
		 withParams: params) willReturn: response.

	"When"
	result := sonarqubeIssues searchWithParams: params.

	"Then"
	self assert: result equals: response
]
