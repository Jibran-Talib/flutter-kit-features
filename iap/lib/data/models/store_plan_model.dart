import '../../domain/entities/store_plan_entity.dart';

class StorePlanModel {
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

  StorePlanModel({
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

  StorePlanModel copyWith({
    String? id,
    String? key,
    DateTime? createdAt,
    String? currency,
    String? description,
    bool? isActive,
    String? label,
    num? price,
    String? skuApple,
    String? skuGoogle,
    DateTime? updatedAt,
  }) => StorePlanModel(
    id: id ?? this.id,
    key: key ?? this.key,
    createdAt: createdAt ?? this.createdAt,
    currency: currency ?? this.currency,
    description: description ?? this.description,
    isActive: isActive ?? this.isActive,
    label: label ?? this.label,
    price: price ?? this.price,
    skuApple: skuApple ?? this.skuApple,
    skuGoogle: skuGoogle ?? this.skuGoogle,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory StorePlanModel.fromJson(Map<String, dynamic> json) => StorePlanModel(
    id: json['_id'] as String?,
    key: json['key'] as String?,
    createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
    currency: json['currency'] as String?,
    description: json['description'] as String?,
    isActive: json['isActive'] as bool?,
    label: json['label'] as String?,
    price: json['price'] as num?,
    skuApple: json['skuApple'] as String?,
    skuGoogle: json['skuGoogle'] as String?,
    updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'key': key,
    'createdAt': createdAt?.toIso8601String(),
    'currency': currency,
    'description': description,
    'isActive': isActive,
    'label': label,
    'price': price,
    'skuApple': skuApple,
    'skuGoogle': skuGoogle,
    'updatedAt': updatedAt?.toIso8601String(),
  };

  StorePlanEntity toEntity() {
    return StorePlanEntity(
      id: id,
      key: key,
      createdAt: createdAt,
      currency: currency,
      description: description,
      isActive: isActive,
      label: label,
      price: price,
      skuApple: skuApple,
      skuGoogle: skuGoogle,
      updatedAt: updatedAt,
    );
  }
}
