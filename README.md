# Sonarqube-Pharo-API

[![Continuous](https://github.com/Evref-BL/Gitlab-Pharo-API/actions/workflows/continuous.yml/badge.svg)](https://github.com/Evref-BL/Sonarqube-Pharo-API/actions/workflows/continuous.yml)
[![Coverage Status](https://coveralls.io/repos/github/Evref-BL/Sonarqube-Pharo-API/badge.svg?branch=develop)](https://coveralls.io/github/Evref-BL/Sonarqube-Pharo-API?branch=develop)

This is a Pharo client for the [Sonarqube Web API](https://next.sonarqube.com/sonarqube/web_api)

### Usage

### Installation

```st
Metacello new
  githubUser: 'Evref-BL' project: 'Sonarqube-Pharo-API' commitish: 'develop' path: 'src';
  baseline: 'SonarqubePharoAPI';
  onConflict: [ :ex | ex useIncoming ];
  load
```

### Client

To start using the API, you need to create a client instance with your Soanrqube host and a pivate token for authentication. Here’s an example:

```st
sonarApi := SonarqubeApi new host: '<your sonarqube domain>.com';
privateToken: '<token>'.
```

Replace `<your sonarqube domain>` with your Sonarqube domain and `<token>` with your private token.

### Ressources

The API is divided into several resources, each corresponding to a specific part of the Sonarqube API. Here are the current available resources:

- projectAnalyses
- issues

Each resource provides methods for interacting with the corresponding Bitbucket resource. You can access them like this:

```st
sonarApi projectAnalyses <method>
```

### Examples

#### Get all analyses of a project

```st
params := {
    'project' -> '<projectKey>'
} asDictionary.

sonarApi projectAnalyses searchWithParams: params.
```

Replace `<projectKey>` with the key of the project you want to get the analyses of.

### Utils

DateAndTime's `printString` does not return the correct format required by the Sonarqube API. To convert a Pharo `DateAndTime` into the appropriate format for Sonarqube, use the method `formatDate: aDateAndTime`.

For exemple if you want to get all the analyses of a project durring the last 7 days you can use this code:

```st
params := {
    'project' -> '<project key>'.
    'from' -> (sonarApi formatDate: (DateAndTime now - 7 days))
} asDictionary.

sonarApi projectAnalyses searchWithParams: params.
```

replace `<project key>` with the key of the project you want to get the analyses of.
