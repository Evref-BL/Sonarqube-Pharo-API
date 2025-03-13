"
A SonarqubeProjectAnalysesTest is a test class for testing the behavior of SonarqubeProjectAnalyses
"
Class {
	#name : 'SonarqubeProjectAnalysesTest',
	#superclass : 'TestCase',
	#category : 'SonarqubePharoAPI-Tests',
	#package : 'SonarqubePharoAPI-Tests'
}

{ #category : 'tests' }
SonarqubeProjectAnalysesTest >> testSearchWithParams [

	"Given"

	| hostUrl client endpoint response result params sonarqubeApi sonarqubeProjectAnalyses |
	hostUrl := 'www.url.com'.
	client := Mock new.

	sonarqubeApi := SonarqubeApi new
		                privateToken: 'token';
		                host: hostUrl;
		                client: client.

	sonarqubeProjectAnalyses := SonarqubeProjectAnalyses new sonarqubeApi: sonarqubeApi.


	params := { (#project -> 'test') } asDictionary.

	endpoint := '/project_analyses/search'.

	response := { (#message -> 'message') } asDictionary.

	(sonarqubeProjectAnalyses stub getAll: 'analyses' inEndpoint: endpoint withParams: params)
		willReturn: response.

	"When"
	result := sonarqubeProjectAnalyses
		          searchWithParams: params.
		
	"Then"
	self assert: result equals: response


]
