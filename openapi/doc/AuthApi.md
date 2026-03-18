# openapi.api.AuthApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *https://fakestoreapi.com*

Method | HTTP request | Description
------------- | ------------- | -------------
[**loginUser**](AuthApi.md#loginuser) | **POST** /auth/login | Login


# **loginUser**
> LoginResponse loginUser(login)

Login

Authenticate a user.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthApi();
final Login login = ; // Login | 

try {
    final response = api.loginUser(login);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->loginUser: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **login** | [**Login**](Login.md)|  | 

### Return type

[**LoginResponse**](LoginResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

