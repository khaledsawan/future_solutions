import 'package:future_solutions/core/model/i_params.dart';
import 'package:openapi/openapi.dart';

class AddProductToCartParams extends Params {
  const AddProductToCartParams(this.product);

  final Product product;
}
