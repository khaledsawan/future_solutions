import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  const CartItemEntity({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    required this.category,
    required this.quantity,
  });

  final int productId;
  final String title;
  final double price;
  final String image;
  final String category;
  final int quantity;

  CartItemEntity copyWith({
    int? productId,
    String? title,
    double? price,
    String? image,
    String? category,
    int? quantity,
  }) {
    return CartItemEntity(
      productId: productId ?? this.productId,
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [
    productId,
    title,
    price,
    image,
    category,
    quantity,
  ];
}
