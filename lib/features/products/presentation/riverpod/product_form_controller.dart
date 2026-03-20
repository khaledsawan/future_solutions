import 'package:future_solutions/features/products/domain/usecases/add_product_use_case/add_product_params.dart';
import 'package:future_solutions/features/products/domain/usecases/update_product_use_case/update_product_params.dart';
import 'package:openapi/openapi.dart';

class ProductFormValues {
  const ProductFormValues({
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  final String title;
  final String price;
  final String description;
  final String category;
  final String image;
}

class ProductFormController {
  static String? requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'products.validation.required';
    }
    return null;
  }

  static String? priceValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'products.validation.price_required';
    }

    final parsedValue = double.tryParse(value.trim());
    if (parsedValue == null) {
      return 'products.validation.price_invalid';
    }

    if (parsedValue <= 0) {
      return 'products.validation.price_positive';
    }

    return null;
  }

  static Product buildProduct({required ProductFormValues values, int? id}) {
    return Product(
      (builder) => builder
        ..id = id
        ..title = values.title.trim()
        ..price = double.parse(values.price.trim())
        ..description = values.description.trim()
        ..category = values.category.trim()
        ..image = values.image.trim(),
    );
  }

  static AddProductParams toAddParams(Product product) =>
      AddProductParams(product);

  static UpdateProductParams toUpdateParams({
    required int id,
    required Product product,
  }) => UpdateProductParams(id, product);

  static ProductFormValues initialValues(Product? product) {
    return ProductFormValues(
      title: product?.title ?? '',
      price: product?.price?.toString() ?? '',
      description: product?.description ?? '',
      category: product?.category ?? '',
      image: product?.image ?? '',
    );
  }
}
