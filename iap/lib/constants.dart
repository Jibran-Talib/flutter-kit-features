// TODO: Replace product IDs with your actual App Store / Google Play product identifiers.
// These must match exactly what you configured in App Store Connect / Google Play Console.

class InAppConstants {
  // TODO: Replace with your product IDs
  // static const yourProduct1 = 'your_product_1';
  // static const premiumMonthly = 'premium_monthly';
  // static const premiumAnnual = 'premium_annual';
  // static const premiumLifetime = 'premium_lifetime';

  // TODO: Populate with your actual product IDs
  static const Set<String> productIds = {
    // 'your_product_1',
    // 'premium_monthly',
    // 'premium_annual',
    // 'premium_lifetime',
  };

  // Set which product IDs are non-consumable (one-time purchase / lifetime unlock).
  // Consumable = can be bought multiple times (coins, credits).
  // Non-consumable = bought once, never expires (premium lifetime, feature unlock).
  static const Set<String> nonConsumableProductIds = {
    // 'premium_lifetime',
  };

  static bool isNonConsumable(String productId) =>
      nonConsumableProductIds.contains(productId);
}
