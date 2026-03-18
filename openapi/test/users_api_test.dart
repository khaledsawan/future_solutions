import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for UsersApi
void main() {
  final instance = Openapi().getUsersApi();

  group(UsersApi, () {
    // Add a new user
    //
    // Create a new user.
    //
    //Future<User> addUser(User user) async
    test('test addUser', () async {
      // TODO
    });

    // Delete a user
    //
    // Delete a specific user by ID.
    //
    //Future deleteUser(int id) async
    test('test deleteUser', () async {
      // TODO
    });

    // Get all users
    //
    // Retrieve a list of all users.
    //
    //Future<BuiltList<User>> getAllUsers() async
    test('test getAllUsers', () async {
      // TODO
    });

    // Get a single user
    //
    // Retrieve details of a specific user by ID.
    //
    //Future<User> getUserById(int id) async
    test('test getUserById', () async {
      // TODO
    });

    // Update a user
    //
    // Update an existing user by ID.
    //
    //Future<User> updateUser(int id, User user) async
    test('test updateUser', () async {
      // TODO
    });

  });
}
