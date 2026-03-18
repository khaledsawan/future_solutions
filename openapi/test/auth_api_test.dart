import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for AuthApi
void main() {
  final instance = Openapi().getAuthApi();

  group(AuthApi, () {
    // Login
    //
    // Authenticate a user.
    //
    //Future<LoginResponse> loginUser(Login login) async
    test('test loginUser', () async {
      // TODO
    });

  });
}
