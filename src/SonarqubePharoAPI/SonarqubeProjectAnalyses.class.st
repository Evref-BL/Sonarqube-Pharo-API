Class {
	#name : 'SonarqubeProjectAnalyses',
	#superclass : 'SonarqubeRessource',
	#category : 'SonarqubePharoAPI',
	#package : 'SonarqubePharoAPI'
}

{ #category : 'api - get' }
SonarqubeProjectAnalyses >> searchWithParams: paramsDictionary [
	"https://next.sonarqube.com/sonarqube/web_api/api/project_analyses/search"
	
	| endpoint |
	endpoint := '/project_analyses/search'.
	
	^self getAll: 'analyses' inEndpoint: endpoint withParams: paramsDictionary.
]
