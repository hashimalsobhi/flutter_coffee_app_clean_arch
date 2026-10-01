import 'package:json_annotation/json_annotation.dart';
import 'coffee_product_model.dart';

part 'coffee_response_model.g.dart';

@JsonSerializable()
class CoffeeResponseModel {
  final List<CoffeeProductModel> products;
  final int total;
  final int skip;
  final int limit;

  const CoffeeResponseModel({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory CoffeeResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CoffeeResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CoffeeResponseModelToJson(this);
}
