# openapi.api.UsersApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *https://fakestoreapi.com*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addUser**](UsersApi.md#adduser) | **POST** /users | Add a new user
[**deleteUser**](UsersApi.md#deleteuser) | **DELETE** /users/{id} | Delete a user
[**getAllUsers**](UsersApi.md#getallusers) | **GET** /users | Get all users
[**getUserById**](UsersApi.md#getuserbyid) | **GET** /users/{id} | Get a single user
[**updateUser**](UsersApi.md#updateuser) | **PUT** /users/{id} | Update a user


# **addUser**
> User addUser(user)

Add a new user

Create a new user.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getUsersApi();
final User user = ; // User | 

try {
    final response = api.addUser(user);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->addUser: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **user** | [**User**](User.md)|  | 

### Return type

[**User**](User.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteUser**
> deleteUser(id)

Delete a user

Delete a specific user by ID.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getUsersApi();
final int id = 56; // int | 

try {
    api.deleteUser(id);
} on DioException catch (e) {
    print('Exception when calling UsersApi->deleteUser: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAllUsers**
> BuiltList<User> getAllUsers()

Get all users

Retrieve a list of all users.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getUsersApi();

try {
    final response = api.getAllUsers();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->getAllUsers: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;User&gt;**](User.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserById**
> User getUserById(id)

Get a single user

Retrieve details of a specific user by ID.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getUsersApi();
final int id = 56; // int | 

try {
    final response = api.getUserById(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->getUserById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**User**](User.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateUser**
> User updateUser(id, user)

Update a user

Update an existing user by ID.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getUsersApi();
final int id = 56; // int | 
final User user = ; // User | 

try {
    final response = api.updateUser(id, user);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->updateUser: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **user** | [**User**](User.md)|  | 

### Return type

[**User**](User.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

