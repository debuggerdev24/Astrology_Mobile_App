/* I have one app which contain three subscription module
 Tier 1, Tier 2,Tier 3
 base on this subscription status i want to show locked contain base on this 3 subscriptions purchase status's variable.
 so can you please make one subscription class with provider(if need)
 and make easy to understand code with moke subscription id for now cause not have client's app account for both platform
 keep in mind that user able to purchase multiple subscription at same time
*/
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:astrology_app/core/utils/custom_toast.dart';
import 'package:astrology_app/core/utils/de_bouncing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../../../../core/enum/app_enums.dart';
import '../../../../../core/utils/logger.dart';
import '../../../../../routes/mobile_routes/user_routes.dart';
import '../../provider/setting/subscription_provider.dart';

class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();

  factory SubscriptionService() => _instance;

  SubscriptionService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final GlobalKey<NavigatorState> globalNavigatorKey =
      GlobalKey<NavigatorState>();

  /// Only Tier 1 & Tier 2
  static const Map<AppEnum, String> productIds = {
    AppEnum.tier1:
        "com.innerpeacepath.tier1_monthly", //com.innerpeacepath.tier1_monthly
    AppEnum.tier2: "com.innerpeacepath.tier2", //com.innerpeacepath.tier2
  };

  List<ProductDetails> availableProducts = [];

  Future<void> initialize(BuildContext context) async {
    try {
      Logger.printInfo("Subscription product fetching");

      final bool available = await _iap.isAvailable();
      Logger.printInfo("is Available $available");

      if (!available) {
        Logger.printInfo("products are not available");
        return;
      }

      await _loadProducts(context);

      _subscription = _iap.purchaseStream.listen(
        (purchases) => _handlePurchaseUpdates(purchases, context),
        onDone: () => _subscription.cancel(),
        onError: (error) {
          Logger.printError("Purchase error: $error");
        },
      );
    } catch (e) {
      Logger.printError("Error inside the initialize function");
    }
  }

  Future<void> _loadProducts(BuildContext context) async {
    try {
      Logger.printInfo(productIds.values.toSet().toString());
      final response = await _iap.queryProductDetails(
        productIds.values.toSet(),
      );
      Logger.printInfo("inside the load products");
      if (response.notFoundIDs.isNotEmpty) {
        Logger.printError("Not found IDs: ${response.notFoundIDs}");
      }
      //
      availableProducts = response.productDetails;
      for (var e in availableProducts) {
        Logger.printInfo(
          "Product Details are below : \ntitle : ${e.title}\nprice : ${e.price}\nid : ${e.id}\ndescription : ${e.description}",
        );
      }
    } catch (e) {
      Logger.printError("Error inside the _loadProducts function");
    }
  }

  //todo buy subscription method
  // late int _planID;

  Future<void> buySubscription({
    required AppEnum tier,
    required int planId,
    required BuildContext context,
    String? appAccountToken,
  }) async {
    try {
      // _planID = planId;
      PurchaseParam param;
      final productId = productIds[tier];
      final product = availableProducts.firstWhere((p) {
        Logger.printInfo(p.id.toString() + productId.toString());
        return p.id == productId;
      }, orElse: () => throw Exception('Product not found'));
      Logger.printInfo(
        "appAccountToken : ${appAccountToken ?? "appAccountToken"}",
      );
      if (Platform.isIOS) {
        param = PurchaseParam(
          productDetails: product,
          applicationUserName: appAccountToken,
        );
      } else {
        param = PurchaseParam(productDetails: product);
      }
      _iap.buyNonConsumable(purchaseParam: param);
    } on PlatformException catch (e) {
      if (e.code == 'storekit2_purchase_cancelled') {
        AppToast.info(
          context: context,
          message: "You have cancelled subscription process",
        );

        context.read<SubscriptionProvider>().setSubscriptionProcessStatus(
          status: false,
        );
      }
    } catch (e, stack) {
      Logger.printError(
        "Error inside the buySubscription function : $e\n$stack",
      );
    }
  }

  Future<void> _handlePurchaseUpdates(
    List<PurchaseDetails> purchases,
    BuildContext context,
  ) async {
    for (final purchase in purchases) {
      Logger.printInfo("-----------------> ${purchase.status}");
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        String serverVerificationData = "";

        final localData = purchase.verificationData.localVerificationData;
        final serverData = purchase.verificationData.serverVerificationData;
        final localDecodedData = jsonDecode(localData);
        Logger.printInfo("Decode data : ${localDecodedData}");
        Logger.printInfo("serverVerificationData : ${serverData}");
        if (Platform.isAndroid) {
          serverVerificationData = localDecodedData["purchaseToken"];
          Logger.printInfo(
            "Purchase Token For Android: \n$serverVerificationData",
          );
        } else if (Platform.isIOS) {
          serverVerificationData = localDecodedData["transactionId"];
          Logger.printInfo("Transaction Id For iOS: \n$serverVerificationData");
        }

        final tier = _getTierFromProductId(purchase.productID);
        // final provider = SubscriptionProvider();
        final provider = Provider.of<SubscriptionProvider>(
          globalNavigatorKey.currentContext!,
          listen: false,
        );

        if (tier != null) {
          await provider.updateSubscriptionInDataBase(
            tier: tier,
            serverVerificationData: serverVerificationData,
            context: globalNavigatorKey.currentContext!,
            isRestore: purchase.status == PurchaseStatus.restored,
            onSuccess: () {
              // context.pushNamed(MobileAppRoutes.userDashBoardScreen.name);
              final ctx = globalNavigatorKey.currentContext;
              if (ctx != null && ctx.mounted) {
                ctx.goNamed(MobileAppRoutes.userDashBoardScreen.name);
              }
            },
          );
        }
        _iap.completePurchase(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        debugPrint("Purchase error: ${purchase.error}");
      } else if (purchase.status == PurchaseStatus.canceled) {
        deBouncer.run(() {
          AppToast.info(
            context: context,
            message: "You have cancelled subscription process",
          );
        });
        final provider = context.read<SubscriptionProvider>();
        provider.setSubscriptionProcessStatus(status: false);
      }
    }
  }

  AppEnum? _getTierFromProductId(String productId) {
    try {
      return productIds.entries
          .firstWhere((entry) => entry.value == productId)
          .key;
    } catch (e) {
      Logger.printError("Error inside the _getTierFromProductId function : $e");
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
        {"tier": "tier1", "isActive": false},
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

  Future<bool> cancelAutoRenewing({
    required BuildContext context,
    required AppEnum tier,
  }) async {
    try {
      final productId = productIds[tier];
      if (productId == null) {
        Logger.printError("Product ID not found for tier: $tier");
        return false;
      }
      if (Platform.isAndroid) {
        // Open Google Play subscription management
        final url =
            'https://play.google.com/store/account/subscriptions?sku=$productId&package=${await _getPackageName()}';
        Logger.printInfo("Opening Android subscription management: $url");
        // You'll need url_launcher package: await launchUrl(Uri.parse(url));
        return true;
      } else if (Platform.isIOS) {
        // Open iOS subscription management
        const url = 'https://apps.apple.com/account/subscriptions';
        Logger.printInfo("Opening iOS subscription management");
        // You'll need url_launcher package: await launchUrl(Uri.parse(url));
        return true;
      }

      return false;
    } catch (e, stack) {
      Logger.printError("Error in cancelAutoRenewing: $e\n$stack");
      return false;
    }
  }

  /// Get package name for Android
  Future<String> _getPackageName() async {
    return "com.inner_peace_path.app";
  }

  ///todo Mark subscription as cancelled in backend
  // Future<bool> markSubscriptionCancelled({
  //   required AppEnum tier,
  //   required BuildContext context,
  // }) async {
  //   try {
  //     // Call your backend API to mark subscription as cancelled
  //     final provider = Provider.of<SubscriptionProvider>(
  //       context,
  //       listen: false,
  //     );
  //
  //     // Update backend
  //     final result = await SubscriptionApiService.instance.cancelSubscription(
  //       tier: tier,
  //     );
  //
  //     return result.fold(
  //       (error) {
  //         Logger.printError(
  //           "Backend cancellation failed: ${error.errorMessage}",
  //         );
  //         return false;
  //       },
  //       (success) {
  //         // Remove from local state
  //         provider.removeSubscription(tier);
  //         Logger.printInfo("Subscription cancelled successfully for: $tier");
  //         return true;
  //       },
  //     );
  //   } catch (e, stack) {
  //     Logger.printError("Error marking subscription cancelled: $e\n$stack");
  //     return false;
  //   }
  // }

  //todo Future<void> cancelAutoRenewing() async {
  //   final Uri url = Platform.isAndroid
  //       ? Uri.parse('https://play.google.com/store/account/subscriptions')
  //       : Uri.parse('https://apps.apple.com/account/subscriptions');
  //
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url, mode: LaunchMode.externalApplication);
  //   } else {
  //     Logger.printError('Could not launch subscription management URL');
  //   }
  // }

  void dispose() {
    _subscription.cancel();
  }
}
