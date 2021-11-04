# supabase_client
standard public schema

This Dart package is automatically generated by the [OpenAPI Generator](https://openapi-generator.tech) project:

- API version: 9.0.0
- Build package: org.openapitools.codegen.languages.DartClientCodegen

## Requirements

Dart 2.0 or later

## Installation & Usage

### Github
If this Dart package is published to Github, add the following dependency to your pubspec.yaml
```
dependencies:
  supabase_client:
    git: https://github.com/GIT_USER_ID/GIT_REPO_ID.git
```

### Local
To use the package in your local drive, add the following dependency to your pubspec.yaml
```
dependencies:
  supabase_client:
    path: /path/to/supabase_client
```

## Tests

TODO

## Getting Started

Please follow the [installation procedure](#installation--usage) and then run the following:

```dart
import 'package:supabase_client/api.dart';


final api_instance = DecisionApi();
final id = id_example; // String | 
final createdAt = createdAt_example; // String | 
final sessionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final decision = decision_example; // bool | 
final placeReference = placeReference_example; // String | 
final prefer = prefer_example; // String | Preference

try {
    api_instance.decisionDelete(id, createdAt, sessionId, decision, placeReference, prefer);
} catch (e) {
    print('Exception when calling DecisionApi->decisionDelete: $e\n');
}

```

## Documentation for API Endpoints

All URIs are relative to *http://0.0.0.0:3000*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*DecisionApi* | [**decisionDelete**](doc//DecisionApi.md#decisiondelete) | **DELETE** /decision | 
*DecisionApi* | [**decisionGet**](doc//DecisionApi.md#decisionget) | **GET** /decision | 
*DecisionApi* | [**decisionPatch**](doc//DecisionApi.md#decisionpatch) | **PATCH** /decision | 
*DecisionApi* | [**decisionPost**](doc//DecisionApi.md#decisionpost) | **POST** /decision | 
*IntrospectionApi* | [**rootGet**](doc//IntrospectionApi.md#rootget) | **GET** / | OpenAPI description (this document)
*SessionApi* | [**sessionDelete**](doc//SessionApi.md#sessiondelete) | **DELETE** /session | 
*SessionApi* | [**sessionGet**](doc//SessionApi.md#sessionget) | **GET** /session | 
*SessionApi* | [**sessionPatch**](doc//SessionApi.md#sessionpatch) | **PATCH** /session | 
*SessionApi* | [**sessionPost**](doc//SessionApi.md#sessionpost) | **POST** /session | 


## Documentation For Models

 - [Decision](doc//Decision.md)
 - [Session](doc//Session.md)


## Documentation For Authorization

 All endpoints do not require authorization.


## Author


