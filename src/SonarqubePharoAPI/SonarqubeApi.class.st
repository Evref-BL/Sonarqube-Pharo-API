Class {
	#name : 'SonarqubeApi',
	#superclass : 'Object',
	#instVars : [
		'host',
		'privateToken',
		'client',
		'basePath'
	],
	#category : 'SonarqubePharoAPI',
	#package : 'SonarqubePharoAPI'
}

{ #category : 'accessing' }
SonarqubeApi >> basePath [

	^ basePath
]

{ #category : 'accessing' }
SonarqubeApi >> basePath: anObject [

	basePath := anObject
]

{ #category : 'accessing' }
SonarqubeApi >> client [

	^ client
]

{ #category : 'accessing' }
SonarqubeApi >> client: anObject [

	client := anObject
]

{ #category : 'accessing' }
SonarqubeApi >> host: anObject [

	host := anObject
]

{ #category : 'initialization' }
SonarqubeApi >> initialize [

	client := (ZnClient new
			 accept: ZnMimeType applicationJson;
			 yourself).
			
	basePath := 'api'
]

{ #category : 'ressources' }
SonarqubeApi >> issues [
	"https://next.sonarqube.com/sonarqube/web_api/api/issues"

	^SonarqubeIssues new sonarqubeApi: self.
]

{ #category : 'private' }
SonarqubeApi >> prepareClient [

	client host: host.
	client https.

	privateToken ifNotNil: [ :anApiKey |
		client
			headerAt: #Authorization
			put: 'Basic ' , (privateToken , ':') utf8Encoded base64Encoded ]
]

{ #category : 'accessing' }
SonarqubeApi >> privateToken: anObject [

	privateToken := anObject
]

{ #category : 'ressources' }
SonarqubeApi >> projectAnalyses [
	"https://next.sonarqube.com/sonarqube/web_api/api/project_analyses"

	^SonarqubeProjectAnalyses new sonarqubeApi: self.
]
