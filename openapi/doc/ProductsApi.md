# openapi.api.ProductsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *https://fakestoreapi.com*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addProduct**](ProductsApi.md#addproduct) | **POST** /products | Add a new product
[**deleteProduct**](ProductsApi.md#deleteproduct) | **DELETE** /products/{id} | Delete a product
[**getAllProducts**](ProductsApi.md#getallproducts) | **GET** /products | Get all products
[**getProductById**](ProductsApi.md#getproductbyid) | **GET** /products/{id} | Get a single product
[**updateProduct**](ProductsApi.md#updateproduct) | **PUT** /products/{id} | Update a product


# **addProduct**
> Product addProduct(product)

Add a new product

Create a new product.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getProductsApi();
final Product product = ; // Product | 

try {
    final response = api.addProduct(product);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProductsApi->addProduct: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **product** | [**Product**](Product.md)|  | 

### Return type

[**Product**](Product.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteProduct**
> deleteProduct(id)

Delete a product

Delete a specific product by ID.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getProductsApi();
final int id = 56; // int | 

try {
    api.deleteProduct(id);
} on DioException catch (e) {
    print('Exception when calling ProductsApi->deleteProduct: $e\n');
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

# **getAllProducts**
> BuiltList<Product> getAllProducts()

Get all products

Retrieve a list of all available products.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getProductsApi();

try {
    final response = api.getAllProducts();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProductsApi->getAllProducts: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;Product&gt;**](Product.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getProductById**
> Product getProductById(id)

Get a single product

Retrieve details of a specific product by ID.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getProductsApi();
final int id = 56; // int | 

try {
    final response = api.getProductById(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProductsApi->getProductById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Product**](Product.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateProduct**
> Product updateProduct(id, product)

Update a product

Update an existing product by ID.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getProductsApi();
final int id = 56; // int | 
final Product product = ; // Product | 

try {
    final response = api.updateProduct(id, product);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProductsApi->updateProduct: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **product** | [**Product**](Product.md)|  | 

### Return type

[**Product**](Product.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

