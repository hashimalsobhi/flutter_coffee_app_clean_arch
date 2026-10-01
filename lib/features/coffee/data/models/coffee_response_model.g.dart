// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coffee_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoffeeResponseModel _$CoffeeResponseModelFromJson(Map<String, dynamic> json) =>
    CoffeeResponseModel(
      products: (json['products'] as List<dynamic>)
          .map((e) => CoffeeProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      skip: (json['skip'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$CoffeeResponseModelToJson(
  CoffeeResponseModel instance,
) => <String, dynamic>{
  'products': instance.products,
  'total': instance.total,
  'skip': instance.skip,
  'limit': instance.limit,
};
