// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Cart extends Cart {
  @override
  final int? id;
  @override
  final int? userId;
  @override
  final BuiltList<Product>? products;

  factory _$Cart([void Function(CartBuilder)? updates]) =>
      (CartBuilder()..update(updates))._build();

  _$Cart._({this.id, this.userId, this.products}) : super._();
  @override
  Cart rebuild(void Function(CartBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CartBuilder toBuilder() => CartBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Cart &&
        id == other.id &&
        userId == other.userId &&
        products == other.products;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, products.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Cart')
          ..add('id', id)
          ..add('userId', userId)
          ..add('products', products))
        .toString();
  }
}

class CartBuilder implements Builder<Cart, CartBuilder> {
  _$Cart? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _userId;
  int? get userId => _$this._userId;
  set userId(int? userId) => _$this._userId = userId;

  ListBuilder<Product>? _products;
  ListBuilder<Product> get products =>
      _$this._products ??= ListBuilder<Product>();
  set products(ListBuilder<Product>? products) => _$this._products = products;

  CartBuilder() {
    Cart._defaults(this);
  }

  CartBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
      _products = $v.products?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Cart other) {
    _$v = other as _$Cart;
  }

  @override
  void update(void Function(CartBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Cart build() => _build();

  _$Cart _build() {
    _$Cart _$result;
    try {
      _$result = _$v ??
          _$Cart._(
            id: id,
            userId: userId,
            products: _products?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'products';
        _products?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Cart', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
