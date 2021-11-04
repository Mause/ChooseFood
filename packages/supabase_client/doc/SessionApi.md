# supabase_client.api.SessionApi

## Load the API package
```dart
import 'package:supabase_client/api.dart';
```

All URIs are relative to *http://0.0.0.0:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**sessionDelete**](SessionApi.md#sessiondelete) | **DELETE** /session | 
[**sessionGet**](SessionApi.md#sessionget) | **GET** /session | 
[**sessionPatch**](SessionApi.md#sessionpatch) | **PATCH** /session | 
[**sessionPost**](SessionApi.md#sessionpost) | **POST** /session | 


# **sessionDelete**
> sessionDelete(id, createdAt, prefer)



### Example
```dart
import 'package:supabase_client/api.dart';

final api_instance = SessionApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final createdAt = createdAt_example; // String | 
final prefer = prefer_example; // String | Preference

try {
    api_instance.sessionDelete(id, createdAt, prefer);
} catch (e) {
    print('Exception when calling SessionApi->sessionDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | [optional] 
 **createdAt** | **String**|  | [optional] 
 **prefer** | **String**| Preference | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sessionGet**
> List<Session> sessionGet(id, createdAt, select, order, range, rangeUnit, offset, limit, prefer)



### Example
```dart
import 'package:supabase_client/api.dart';

final api_instance = SessionApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final createdAt = createdAt_example; // String | 
final select = select_example; // String | Filtering Columns
final order = order_example; // String | Ordering
final range = range_example; // String | Limiting and Pagination
final rangeUnit = rangeUnit_example; // String | Limiting and Pagination
final offset = offset_example; // String | Limiting and Pagination
final limit = limit_example; // String | Limiting and Pagination
final prefer = prefer_example; // String | Preference

try {
    final result = api_instance.sessionGet(id, createdAt, select, order, range, rangeUnit, offset, limit, prefer);
    print(result);
} catch (e) {
    print('Exception when calling SessionApi->sessionGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | [optional] 
 **createdAt** | **String**|  | [optional] 
 **select** | **String**| Filtering Columns | [optional] 
 **order** | **String**| Ordering | [optional] 
 **range** | **String**| Limiting and Pagination | [optional] 
 **rangeUnit** | **String**| Limiting and Pagination | [optional] [default to 'items']
 **offset** | **String**| Limiting and Pagination | [optional] 
 **limit** | **String**| Limiting and Pagination | [optional] 
 **prefer** | **String**| Preference | [optional] 

### Return type

[**List<Session>**](Session.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/vnd.pgrst.object+json, text/csv

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sessionPatch**
> sessionPatch(id, createdAt, prefer, session)



### Example
```dart
import 'package:supabase_client/api.dart';

final api_instance = SessionApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final createdAt = createdAt_example; // String | 
final prefer = prefer_example; // String | Preference
final session = Session(); // Session | session

try {
    api_instance.sessionPatch(id, createdAt, prefer, session);
} catch (e) {
    print('Exception when calling SessionApi->sessionPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | [optional] 
 **createdAt** | **String**|  | [optional] 
 **prefer** | **String**| Preference | [optional] 
 **session** | [**Session**](Session.md)| session | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, application/vnd.pgrst.object+json, text/csv
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sessionPost**
> sessionPost(select, prefer, session)



### Example
```dart
import 'package:supabase_client/api.dart';

final api_instance = SessionApi();
final select = select_example; // String | Filtering Columns
final prefer = prefer_example; // String | Preference
final session = Session(); // Session | session

try {
    api_instance.sessionPost(select, prefer, session);
} catch (e) {
    print('Exception when calling SessionApi->sessionPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **select** | **String**| Filtering Columns | [optional] 
 **prefer** | **String**| Preference | [optional] 
 **session** | [**Session**](Session.md)| session | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, application/vnd.pgrst.object+json, text/csv
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

