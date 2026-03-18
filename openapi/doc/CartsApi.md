# openapi.api.CartsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *https://fakestoreapi.com*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addCart**](CartsApi.md#addcart) | **POST** /carts | Add a new cart
[**deleteCart**](CartsApi.md#deletecart) | **DELETE** /carts/{id} | Delete a cart
[**getAllCarts**](CartsApi.md#getallcarts) | **GET** /carts | Get all carts
[**getCartById**](CartsApi.md#getcartbyid) | **GET** /carts/{id} | Get a single cart
[**updateCart**](CartsApi.md#updatecart) | **PUT** /carts/{id} | Update a cart


# **addCart**
> Cart addCart(cart)

Add a new cart

Create a new cart.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCartsApi();
final Cart cart = ; // Cart | 

try {
    final response = api.addCart(cart);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CartsApi->addCart: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cart** | [**Cart**](Cart.md)|  | 

### Return type

[**Cart**](Cart.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteCart**
> deleteCart(id)

Delete a cart

Delete a specific cart by ID.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCartsApi();
final int id = 56; // int | 

try {
    api.deleteCart(id);
} on DioException catch (e) {
    print('Exception when calling CartsApi->deleteCart: $e\n');
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

# **getAllCarts**
> BuiltList<Cart> getAllCarts()

Get all carts

Retrieve a list of all available carts.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCartsApi();

try {
    final response = api.getAllCarts();
    print(response);
} on DioException catch (e) {
    print('Exception when calling CartsApi->getAllCarts: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;Cart&gt;**](Cart.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCartById**
> Cart getCartById(id)

Get a single cart

Retrieve details of a specific cart by ID.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCartsApi();
final int id = 56; // int | 

try {
    final response = api.getCartById(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CartsApi->getCartById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Cart**](Cart.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateCart**
> Cart updateCart(id, cart)

Update a cart

Update an existing cart by ID.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCartsApi();
final int id = 56; // int | 
final Cart cart = ; // Cart | 

try {
    final response = api.updateCart(id, cart);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CartsApi->updateCart: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **cart** | [**Cart**](Cart.md)|  | 

### Return type

[**Cart**](Cart.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

