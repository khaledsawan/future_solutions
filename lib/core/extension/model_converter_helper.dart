import 'package:built_value/serializer.dart';
import 'package:injectable/injectable.dart';

@singleton
class ModelConverterHelper {
  final Serializers serializers;
  ModelConverterHelper(this.serializers);

  Map<String, dynamic> toJson<T>(T object, Serializer<T> serializer) {
    return serializers.serializeWith(serializer, object)
        as Map<String, dynamic>;
  }

  T fromJson<T>(Map<String, dynamic> json, Serializer<T> serializer) {
    return serializers.deserializeWith(serializer, json)!;
  }

  /// Converts any object to a cache-storable representation.
  ///
  /// For built_value models this returns the serialized object graph
  /// (Map/List primitives). For plain Dart values it returns the value as-is.
  dynamic toCacheValue(dynamic value) {
    if (value == null ||
        value is String ||
        value is num ||
        value is bool ||
        value is List ||
        value is Map) {
      return value;
    }

    try {
      return serializers.serialize(value);
    } catch (_) {
      try {
        return (value as dynamic).toJson();
      } catch (_) {
        // Last fallback: keep original object for in-memory cache usage.
        return value;
      }
    }
  }

  /// Converts cached representation back to requested type [T].
  T? fromCacheValue<T>(dynamic value) {
    if (value == null) return null;
    if (value is T) return value;

    try {
      return serializers.deserialize(
            value,
            specifiedType: FullType(T),
          )
          as T?;
    } catch (_) {
      try {
        return value as T?;
      } catch (_) {
        return null;
      }
    }
  }
}
