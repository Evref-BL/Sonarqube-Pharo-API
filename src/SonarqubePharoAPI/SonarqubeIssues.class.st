Class {
	#name : 'SonarqubeIssues',
	#superclass : 'SonarqubeRessource',
	#category : 'SonarqubePharoAPI',
	#package : 'SonarqubePharoAPI'
}

{ #category : 'api - get' }
SonarqubeIssues >> searchWithParams: paramsDictionary [
	"https://next.sonarqube.com/sonarqube/web_api/api/issues/search"
	| endpoint |
	endpoint := '/issues/search'.

	^ self
		  getAll: 'issues'
		  inEndpoint: endpoint
		  withParams: paramsDictionary
]
