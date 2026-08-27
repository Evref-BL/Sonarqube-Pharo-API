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

	| client endpoint params result item page1 page2 itemName sonarqubeApi resource |
	"Given"
	client := ZnClient new.
	sonarqubeApi := SonarqubeApi new client: client.
	resource := SonarqubeRessource new sonarqubeApi: sonarqubeApi.

	itemName := 'issues'.
	endpoint := '/endpoint'.
	params := Dictionary with: 'param' -> 'value'.

	item := { (#id -> 1) } asDictionary.
	page1 := Dictionary with: #page -> 1 with: itemName -> { item }.
	page2 := Dictionary with: #page -> 2 with: itemName -> {  }. "Stops at empty page"

	resource stub getWithRetries willReturnValueFrom:
		((Array with: page1 with: page2) collect: [ :page |
			 ZnResponse ok: (ZnEntity json: (NeoJSONWriter toString: page)) ]).

	"When"
	result := resource
		          getAll: itemName
		          inEndpoint: endpoint
		          withParams: params.

	"Then"
	self assert: result size equals: 1.
	self assert: result first equals: item
]

{ #category : 'tests' }
SonarqubeRessourceTest >> testGetWithRetries [

	| client result response sonarqubeApi resource |
	"Given"
	client := ZnClient new.
	sonarqubeApi := SonarqubeApi new client: client.
	resource := SonarqubeRessource new sonarqubeApi: sonarqubeApi.

	response := Dictionary with: #page -> 4 with: 'issues' -> #(  ).
	response := NeoJSONWriter toString: response.

	client stub get willReturnYourself.
	client stub response willReturn:
		(ZnResponse ok: (ZnEntity json: response)).

	"When"
	result := resource getWithRetries.

	"Then"
	self assert: result contents equals: response
]

{ #category : 'tests' }
SonarqubeRessourceTest >> testGetWithRetriesDoesNotRetryClientErrors [

	| client sonarqubeApi resource itemName endpoint params stdout description response |
	client := ZnClient new.
	sonarqubeApi := SonarqubeApi new client: client.
	resource := SonarqubeRessource new sonarqubeApi: sonarqubeApi.

	itemName := 'issues'.
	endpoint := '/endpoint'.
	params := Dictionary new.

	stdout := String new writeStream.
	description := 'Client is a potato.'.
	response := Dictionary with:
		            'errors' -> { (Dictionary with: 'msg' -> description) }.

	resource stub stdout willReturn: stdout.
	client stub get willReturnYourself.
	client stub response willReturn: (ZnResponse
			 badRequest: nil
			 entity: (ZnEntity text: (NeoJSONWriter toString: response))).

	self
		should: [
		resource getAll: itemName inEndpoint: endpoint withParams: params ]
		raise: Error
		withExceptionDo: [ :error |
			self assert: (error messageText includesSubstring: description) ].

	"0 retries"
	self assert: (stdout contents occurrencesOf: Character lf) equals: 0
]

{ #category : 'tests' }
SonarqubeRessourceTest >> testGetWithRetriesServerErrors [

	| client sonarqubeApi resource itemName endpoint params stdout description response |
	client := ZnClient new.
	sonarqubeApi := SonarqubeApi new client: client.
	resource := SonarqubeRessource new sonarqubeApi: sonarqubeApi.

	itemName := 'issues'.
	endpoint := '/endpoint'.
	params := Dictionary new.

	stdout := String new writeStream.
	description := 'Results are unavailable.'.
	response := Dictionary with:
		            'errors' -> { (Dictionary with: 'msg' -> description) }.

	resource stub initialRetryDelay willReturn: 0 seconds.
	resource stub stdout willReturn: stdout.
	client stub get willReturnYourself.
	client stub response willReturn:
		(ZnResponse serviceUnavailable: (NeoJSONWriter toString: response)).

	self
		should: [
		resource getAll: itemName inEndpoint: endpoint withParams: params ]
		raise: Error
		withExceptionDo: [ :error |
			self assert: (error messageText includesSubstring: description) ].

	"3 retries"
	self assert: (stdout contents occurrencesOf: Character lf) equals: 3
]
