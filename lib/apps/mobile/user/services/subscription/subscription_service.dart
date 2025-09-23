/* I have one app which contain three subscription module
 Tier 1, Tier 2,Tier 3
 base on this subscription status i want to show locked contain base on this 3 subscriptions purchase status's variable.
 so can you please make one subscription class with provider(if need)
 and make easy to understand code with moke subscription id for now cause not have client's app account for both platform
 keep in mind that user able to purchase multiple subscription at same time
*/
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../../../../core/enum/app_enums.dart';
import '../../provider/setting/subscription_provider.dart';

class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  /// Only Tier 1 & Tier 2
  static const Map<AppEnum, String> productIds = {
    AppEnum.tier1: 'mock_tier1_id',
    AppEnum.tier2: 'mock_tier2_id',
  };

  List<ProductDetails> availableProducts = [];

  Future<void> initialize(BuildContext context) async {
    final bool available = await _iap.isAvailable();
    if (!available) {
      debugPrint("Store not available");
      return;
    }

    await _loadProducts();

    _subscription = _iap.purchaseStream.listen(
      (purchases) => _handlePurchaseUpdates(purchases, context),
      onDone: () => _subscription.cancel(),
      onError: (error) {
        debugPrint("Purchase error: $error");
      },
    );
  }

  Future<void> _loadProducts() async {
    final response = await _iap.queryProductDetails(productIds.values.toSet());

    if (response.notFoundIDs.isNotEmpty) {
      debugPrint("Not found IDs: ${response.notFoundIDs}");
    }

    availableProducts = response.productDetails;
  }

  /// Call this when user taps “Choose Plan”
  Future<void> buySubscription(AppEnum tier) async {
    final productId = productIds[tier];
    final product = availableProducts.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw Exception('Product not found'),
    );
    final param = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  void _handlePurchaseUpdates(
    List<PurchaseDetails> purchases,
    BuildContext context,
  ) {
    final provider = Provider.of<SubscriptionProvider>(context, listen: false);

    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        final tier = _getTierFromProductId(purchase.productID);
        if (tier != null) {
          provider.addSubscription(tier);
        }
        _iap.completePurchase(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        debugPrint("Purchase error: ${purchase.error}");
      }
    }
  }

  AppEnum? _getTierFromProductId(String productId) {
    try {
      return productIds.entries
          .firstWhere((entry) => entry.value == productId)
          .key;
    } catch (_) {
      return null;
    }
  }

  Future<void> checkBackendSubscriptionStatus(BuildContext context) async {
    try {
      // Replace this with your actual API call logic
      final response = await _fakeFetchFromBackend();

      final provider = Provider.of<SubscriptionProvider>(
        context,
        listen: false,
      );

      for (var sub in response["subscriptions"]) {
        final tier = _parseTier(sub["tier"]);
        final isActive = sub["isActive"] == true;

        if (tier != null) {
          if (isActive) {
            provider.addSubscription(tier);
          } else {
            provider.removeSubscription(tier);
          }
        }
      }
    } catch (e) {
      debugPrint("Subscription check failed: $e");
    }
  }

  /// Simulate API response
  Future<Map<String, dynamic>> _fakeFetchFromBackend() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network
    return {
      "subscriptions": [
        {"tier": "tier1", "isActive": true},
        {"tier": "tier2", "isActive": false},
      ],
    };
  }

  AppEnum? _parseTier(String tierStr) {
    switch (tierStr.toLowerCase()) {
      case 'tier1':
        return AppEnum.tier1;
      case 'tier2':
        return AppEnum.tier2;
      case 'tier3':
        return AppEnum.tier3;
      default:
        return null;
    }
  }

  void dispose() {
    _subscription.cancel();
  }
}
