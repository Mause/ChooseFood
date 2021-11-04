# supabase_client.model.Decision

## Load the model package
```dart
import 'package:supabase_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** | Note: This is a Primary Key.<pk/> |
**createdAt** | **String** |  | [optional] [default to 'now()']
**sessionId** | **String** | Note: This is a Foreign Key to `session.id`.<fk table='session' column='id'/> | [optional]
**decision** | **bool** |  | [optional]
**placeReference** | **String** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
