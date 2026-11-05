import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../domain/entities/in_app_product_entity.dart';

class InAppProductModel extends Equatable {
  final ProductDetails productDetails;
  final String id;
  final String title;
  final String description;
  final String price;
  final num rawPrice;
  final String currencyCode;
  final String marketingDescription;

  const InAppProductModel({
    required this.productDetails,
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rawPrice,
    required this.currencyCode,
    required this.marketingDescription,
  });

  factory InAppProductModel.fromProductDetails(ProductDetails productDetails) {
    return InAppProductModel(
      productDetails: productDetails,
      id: productDetails.id,
      title: productDetails.title,
      description: productDetails.description,
      price: productDetails.price,
      rawPrice: productDetails.rawPrice,
      currencyCode: productDetails.currencyCode,
      marketingDescription: productDetails.description,
    );
  }

  InAppProductEntity toEntity() {
    return InAppProductEntity(
      id: id,
      title: title,
      description: description,
      price: price,
      rawPrice: rawPrice,
      currencyCode: currencyCode,
      marketingDescription: marketingDescription,
    );
  }

  @override
  List<Object?> get props => [id, title, description, price, rawPrice, currencyCode, marketingDescription];
}
