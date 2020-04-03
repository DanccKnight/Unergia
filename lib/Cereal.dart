import 'package:json_annotation/json_annotation.dart';

part 'Cereal.g.dart';

@JsonSerializable()
class Cereal {
  String name;
  double calories;
  double carbo;
  double fat;
  double protein;
  double rating;
  double sodium;
  double sugars;
  double vitamins;
  String colorVal;

  Cereal(
      {this.name,
      this.calories,
      this.carbo,
      this.fat,
      this.protein,
      this.rating,
      this.sodium,
      this.sugars,
      this.vitamins,
      this.colorVal});

  factory Cereal.fromJson(Map<String, dynamic> json) => _$CerealFromJson(json);

  Map<String, dynamic> toJson() => _$CerealToJson(this);
}
