Class {
	#name : 'BaselineOfSonarqubePharoAPI',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfSonarqubePharoAPI',
	#package : 'BaselineOfSonarqubePharoAPI'
}

{ #category : 'baselines' }
BaselineOfSonarqubePharoAPI >> baseline: spec [

	<baseline>
	spec for: #common do: [
		self defineDependencies: spec.
		self definePackages: spec.
		self defineGroups: spec ]
]

{ #category : 'baselines' }
BaselineOfSonarqubePharoAPI >> defineDependencies: spec [
	spec
		baseline: 'NeoJSON'
		with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].

	spec
		baseline: 'Mocketry'
		with: [ spec repository: 'github://dionisiydk/Mocketry' ]
]

{ #category : 'baselines' }
BaselineOfSonarqubePharoAPI >> defineGroups: spec [
]

{ #category : 'baselines' }
BaselineOfSonarqubePharoAPI >> definePackages: spec [

	spec package: 'SonarqubePharoAPI'.
	
	spec
		package: 'SonarqubePharoAPI-Tests'
		with: [ spec requires: #( 'SonarqubePharoAPI' 'Mocketry' ) ]
]
