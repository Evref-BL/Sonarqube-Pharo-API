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

	client stub get willReturnYourself.
	client stub response willReturn:
		(ZnResponse ok: (ZnEntity json: (NeoJSONWriter toString: response))).

	"When"
	result := sonarqubeRessource
		          getAll: itemName
		          inEndpoint: endpoint
		          withParams: params.

	"Then"
	self assert: result size equals: 0
]

{ #category : 'tests' }
SonarqubeRessourceTest >> testGetWithRetries [

	| hostUrl client endpoint params itemName sonarqubeApi sonarqubeRessource description response stdout |
	hostUrl := 'https://www.url.com'.
	client := ZnClient new.

	sonarqubeApi := SonarqubeApi new
		                privateToken: 'token';
		                host: hostUrl;
		                client: client.

	endpoint := '/endpoint'.
	itemName := 'issues'.
	params := Dictionary new.

	sonarqubeRessource := SonarqubeRessource new sonarqubeApi:
		                      sonarqubeApi.

	stdout := String new writeStream.
	description := 'Results are unavailable.'.
	response := { ('errors'
	             -> { { ('msg' -> description) } asDictionary }) }
		            asDictionary.

	sonarqubeRessource stub initialRetryDelay willReturn: 0 seconds.
	sonarqubeRessource stub stdout willReturn: stdout.
	client stub get willReturnYourself.
	client stub response willReturn:
		(ZnResponse serviceUnavailable: (NeoJSONWriter toString: response)).

	self
		should: [
			sonarqubeRessource
				getAll: itemName
				inEndpoint: endpoint
				withParams: params ]
		raise: Error
		withExceptionDo: [ :error |
			self assert: (error messageText includesSubstring: description) ].

	"3 retries"
	self assert: (stdout contents occurrencesOf: Character lf) equals: 3
]
