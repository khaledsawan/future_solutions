import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for CartsApi
void main() {
  final instance = Openapi().getCartsApi();

  group(CartsApi, () {
    // Add a new cart
    //
    // Create a new cart.
    //
    //Future<Cart> addCart(Cart cart) async
    test('test addCart', () async {
      // TODO
    });

    // Delete a cart
    //
    // Delete a specific cart by ID.
    //
    //Future deleteCart(int id) async
    test('test deleteCart', () async {
      // TODO
    });

    // Get all carts
    //
    // Retrieve a list of all available carts.
    //
    //Future<BuiltList<Cart>> getAllCarts() async
    test('test getAllCarts', () async {
      // TODO
    });

    // Get a single cart
    //
    // Retrieve details of a specific cart by ID.
    //
    //Future<Cart> getCartById(int id) async
    test('test getCartById', () async {
      // TODO
    });

    // Update a cart
    //
    // Update an existing cart by ID.
    //
    //Future<Cart> updateCart(int id, Cart cart) async
    test('test updateCart', () async {
      // TODO
    });

  });
}
