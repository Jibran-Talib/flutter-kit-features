import 'package:equatable/equatable.dart';

class InAppProductEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String price;
  final num rawPrice;
  final String currencyCode;
  final String marketingDescription;

  const InAppProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rawPrice,
    required this.currencyCode,
    required this.marketingDescription,
  });

  @override
  List<Object?> get props => [id, title, description, price, rawPrice, currencyCode, marketingDescription];
}
