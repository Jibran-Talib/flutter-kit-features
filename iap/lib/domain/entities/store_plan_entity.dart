import 'in_app_product_entity.dart';

class StorePlanEntity {
  final String? id;
  final String? key;
  final DateTime? createdAt;
  final String? currency;
  final String? description;
  final bool? isActive;
  final String? label;
  final num? price;
  final String? skuApple;
  final String? skuGoogle;
  final DateTime? updatedAt;

  const StorePlanEntity({
    this.id,
    this.key,
    this.createdAt,
    this.currency,
    this.description,
    this.isActive,
    this.label,
    this.price,
    this.skuApple,
    this.skuGoogle,
    this.updatedAt,
  });

  InAppProductEntity toInAppProduct() {
    return InAppProductEntity(
      id: key ?? id ?? '',
      title: label ?? '',
      description: description ?? '',
      price: price?.toString() ?? '0',
      rawPrice: (price ?? 0).toDouble(),
      currencyCode: currency ?? '',
      marketingDescription: description ?? '',
    );
  }
}
