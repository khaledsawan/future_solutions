import 'package:future_solutions/features/carts/domain/entities/cart_item_entity.dart';

class LocalCartItemModel {
  const LocalCartItemModel({
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

  factory LocalCartItemModel.fromMap(Map<dynamic, dynamic> map) {
    return LocalCartItemModel(
      productId: map['productId'] as int? ?? 0,
      title: map['title'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      image: map['image'] as String? ?? '',
      category: map['category'] as String? ?? '',
      quantity: map['quantity'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'image': image,
      'category': category,
      'quantity': quantity,
    };
  }

  CartItemEntity toEntity() {
    return CartItemEntity(
      productId: productId,
      title: title,
      price: price,
      image: image,
      category: category,
      quantity: quantity,
    );
  }

  factory LocalCartItemModel.fromEntity(CartItemEntity entity) {
    return LocalCartItemModel(
      productId: entity.productId,
      title: entity.title,
      price: entity.price,
      image: entity.image,
      category: entity.category,
      quantity: entity.quantity,
    );
  }
}
