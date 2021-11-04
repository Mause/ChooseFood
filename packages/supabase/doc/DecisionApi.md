# Supabase.api.DecisionApi

## Load the API package
```dart
import 'package:Supabase/api.dart';
```

All URIs are relative to *http://0.0.0.0:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**decisionDelete**](DecisionApi.md#decisiondelete) | **DELETE** /decision | 
[**decisionGet**](DecisionApi.md#decisionget) | **GET** /decision | 
[**decisionPatch**](DecisionApi.md#decisionpatch) | **PATCH** /decision | 
[**decisionPost**](DecisionApi.md#decisionpost) | **POST** /decision | 


# **decisionDelete**
> decisionDelete(id, createdAt, sessionId, decision, placeReference, prefer)



### Example
```dart
import 'package:Supabase/api.dart';

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

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | [optional] 
 **createdAt** | **String**|  | [optional] 
 **sessionId** | **String**|  | [optional] 
 **decision** | **bool**|  | [optional] 
 **placeReference** | **String**|  | [optional] 
 **prefer** | **String**| Preference | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **decisionGet**
> List<Decision> decisionGet(id, createdAt, sessionId, decision, placeReference, select, order, range, rangeUnit, offset, limit, prefer)



### Example
```dart
import 'package:Supabase/api.dart';

final api_instance = DecisionApi();
final id = id_example; // String | 
final createdAt = createdAt_example; // String | 
final sessionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final decision = decision_example; // bool | 
final placeReference = placeReference_example; // String | 
final select = select_example; // String | Filtering Columns
final order = order_example; // String | Ordering
final range = range_example; // String | Limiting and Pagination
final rangeUnit = rangeUnit_example; // String | Limiting and Pagination
final offset = offset_example; // String | Limiting and Pagination
final limit = limit_example; // String | Limiting and Pagination
final prefer = prefer_example; // String | Preference

try {
    final result = api_instance.decisionGet(id, createdAt, sessionId, decision, placeReference, select, order, range, rangeUnit, offset, limit, prefer);
    print(result);
} catch (e) {
    print('Exception when calling DecisionApi->decisionGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | [optional] 
 **createdAt** | **String**|  | [optional] 
 **sessionId** | **String**|  | [optional] 
 **decision** | **bool**|  | [optional] 
 **placeReference** | **String**|  | [optional] 
 **select** | **String**| Filtering Columns | [optional] 
 **order** | **String**| Ordering | [optional] 
 **range** | **String**| Limiting and Pagination | [optional] 
 **rangeUnit** | **String**| Limiting and Pagination | [optional] [default to 'items']
 **offset** | **String**| Limiting and Pagination | [optional] 
 **limit** | **String**| Limiting and Pagination | [optional] 
 **prefer** | **String**| Preference | [optional] 

### Return type

[**List<Decision>**](Decision.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/vnd.pgrst.object+json, text/csv

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **decisionPatch**
> decisionPatch(id, createdAt, sessionId, placeReference, prefer, decision)



### Example
```dart
import 'package:Supabase/api.dart';

final api_instance = DecisionApi();
final id = id_example; // String | 
final createdAt = createdAt_example; // String | 
final sessionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final placeReference = placeReference_example; // String | 
final prefer = prefer_example; // String | Preference
final decision = Decision(); // Decision | decision

try {
    api_instance.decisionPatch(id, createdAt, sessionId, placeReference, prefer, decision);
} catch (e) {
    print('Exception when calling DecisionApi->decisionPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | [optional] 
 **createdAt** | **String**|  | [optional] 
 **sessionId** | **String**|  | [optional] 
 **placeReference** | **String**|  | [optional] 
 **prefer** | **String**| Preference | [optional] 
 **decision** | [**Decision**](Decision.md)| decision | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, application/vnd.pgrst.object+json, text/csv
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **decisionPost**
> decisionPost(select, prefer, decision)



### Example
```dart
import 'package:Supabase/api.dart';

final api_instance = DecisionApi();
final select = select_example; // String | Filtering Columns
final prefer = prefer_example; // String | Preference
final decision = Decision(); // Decision | decision

try {
    api_instance.decisionPost(select, prefer, decision);
} catch (e) {
    print('Exception when calling DecisionApi->decisionPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **select** | **String**| Filtering Columns | [optional] 
 **prefer** | **String**| Preference | [optional] 
 **decision** | [**Decision**](Decision.md)| decision | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, application/vnd.pgrst.object+json, text/csv
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

