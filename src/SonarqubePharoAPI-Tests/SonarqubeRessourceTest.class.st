"
A SonarqubeRessourceTest is a test class for testing the behavior of SonarqubeRessource
"
Class {
	#name : 'SonarqubeRessourceTest',
	#superclass : 'TestCase',
	#category : 'SonarqubePharoAPI-Tests',
	#package : 'SonarqubePharoAPI-Tests'
}

{ #category : 'tests' }
SonarqubeRessourceTest >> testGetAllInEndpointWithParams [

	| hostUrl client endpoint params result response itemName item sonarqubeApi sonarqubeRessource |
	"Given"
	hostUrl := 'https://www.url.com'.
	client := ZnClient new.

	sonarqubeApi := SonarqubeApi new
		                privateToken: 'token';
		                host: hostUrl;
		                client: client.

	endpoint := '/endpoint'.
	params := { ('param' -> 'value') } asDictionary.
	itemName := 'issues'.

	item := { (#id -> 1) } asDictionary.



	sonarqubeRessource := SonarqubeRessource new sonarqubeApi:
		                      sonarqubeApi.

	response := {
		            (#page -> 4).
		            (itemName -> {  }) } asDictionary.

	client stub get willReturn: (NeoJSONWriter toString: response).


	"When"
	result := sonarqubeRessource
		          getAll: itemName
		          inEndpoint: endpoint
		          withParams: params.

	"Then"
	self assert: result size equals: 0.
]
