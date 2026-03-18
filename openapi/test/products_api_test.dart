import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for ProductsApi
void main() {
  final instance = Openapi().getProductsApi();

  group(ProductsApi, () {
    // Add a new product
    //
    // Create a new product.
    //
    //Future<Product> addProduct(Product product) async
    test('test addProduct', () async {
      // TODO
    });

    // Delete a product
    //
    // Delete a specific product by ID.
    //
    //Future deleteProduct(int id) async
    test('test deleteProduct', () async {
      // TODO
    });

    // Get all products
    //
    // Retrieve a list of all available products.
    //
    //Future<BuiltList<Product>> getAllProducts() async
    test('test getAllProducts', () async {
      // TODO
    });

    // Get a single product
    //
    // Retrieve details of a specific product by ID.
    //
    //Future<Product> getProductById(int id) async
    test('test getProductById', () async {
      // TODO
    });

    // Update a product
    //
    // Update an existing product by ID.
    //
    //Future<Product> updateProduct(int id, Product product) async
    test('test updateProduct', () async {
      // TODO
    });

  });
}
