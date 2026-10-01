// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coffee_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoffeeProductModel _$CoffeeProductModelFromJson(Map<String, dynamic> json) =>
    CoffeeProductModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String?,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      stock: (json['stock'] as num?)?.toInt() ?? 50,
      thumbnail: json['thumbnail'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      brand: json['brand'] as String?,
    );

Map<String, dynamic> _$CoffeeProductModelToJson(CoffeeProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'price': instance.price,
      'rating': instance.rating,
      'stock': instance.stock,
      'thumbnail': instance.thumbnail,
      'images': instance.images,
      'tags': instance.tags,
      'brand': instance.brand,
    };
