// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Cereal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cereal _$CerealFromJson(Map<String, dynamic> json) {
  return Cereal(
    name: json['name'] as String,
    calories: (json['calories'] as num)?.toDouble(),
    carbo: (json['carbo'] as num)?.toDouble(),
    fat: (json['fat'] as num)?.toDouble(),
    protein: (json['protein'] as num)?.toDouble(),
    rating: (json['rating'] as num)?.toDouble(),
    sodium: (json['sodium'] as num)?.toDouble(),
    sugars: (json['sugars'] as num)?.toDouble(),
    vitamins: (json['vitamins'] as num)?.toDouble(),
    colorVal: json['colorVal'] as String,
  );
}

Map<String, dynamic> _$CerealToJson(Cereal instance) => <String, dynamic>{
      'name': instance.name,
      'calories': instance.calories,
      'carbo': instance.carbo,
      'fat': instance.fat,
      'protein': instance.protein,
      'rating': instance.rating,
      'sodium': instance.sodium,
      'sugars': instance.sugars,
      'vitamins': instance.vitamins,
      'colorVal': instance.colorVal,
    };
