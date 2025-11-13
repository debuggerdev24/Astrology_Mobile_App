import 'dart:io';

import 'package:astrology_app/apps/mobile/user/model/settings/subscription_plan_model.dart';
import 'package:astrology_app/apps/mobile/user/services/settings/subscription_api_service.dart';
import 'package:astrology_app/core/utils/custom_toast.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/enum/app_enums.dart';
import '../../../../../core/utils/logger.dart';
import '../../services/subscription/subscription_service.dart';

class SubscriptionProvider extends ChangeNotifier {
  //todo ----------------> Subscription API service
  List<SubscriptionPlanModel>? subscriptionPlans;
  ActiveSubscriptionPlanModel? activeSubscriptionPlan;

  Future<void> getSubscriptionPlans() async {
    final result = await SubscriptionApiService.instance.getPlans();
    result.fold(
      (l) {
        Logger.printError(l.errorMessage);
      },
      (r) {
        subscriptionPlans = (r["data"] as List)
            .map((e) => SubscriptionPlanModel.fromJson(e))
            .toList();
        notifyListeners();
      },
    );
  }

  Future<void> cancelSubscriptionPlan({required BuildContext context}) async {
    final result = await SubscriptionApiService.instance.cancelPlans();
    result.fold(
      (l) {
        Logger.printError(l.errorMessage);
      },
      (r) {
        AppToast.success(
          context: context,
          message: "Subscription cancelled successfully.",
        );
        notifyListeners();
      },
    );
  }

  bool isActivePlanLoading = true;
  Future<void> getActiveSubscriptionPlan({
    required BuildContext context,
  }) async {
    activeSubscriptionPlan = null;
    isActivePlanLoading = true;
    notifyListeners();
    final result = await SubscriptionApiService.instance
        .getCurrentActivePlans();

    result.fold(
      (l) {
        Logger.printError(l.errorMessage);
      },
      (r) {
        activeSubscriptionPlan = ActiveSubscriptionPlanModel.fromJson(
          r["data"],
        );
        _activeSubscriptions.clear();
        if (r["data"]["price"] == "20") {
          addSubscription(AppEnum.tier1);
          addSubscription(AppEnum.tier2);
        }
        if (r["data"]["price"] == "10") {
          addSubscription(AppEnum.tier1);
        }
        isActivePlanLoading = false;
        notifyListeners();
      },
    );
  }

  //todo -----------------> Subscription account service
  final Set<AppEnum> _activeSubscriptions = {};

  Set<AppEnum> get activeSubscriptions => _activeSubscriptions;

  bool isTier1Subscribed = false,
      isTier2Subscribed = false,
      isTier3Subscribed = false;

  // Add a subscription and update flags
  void addSubscription(AppEnum tier) {
    _activeSubscriptions.add(tier);
    _updateTierFlags();
    notifyListeners();
  }

  bool isSubscriptionLoading = false;
  Future<void> manageSubscriptionToDB({
    required AppEnum tier,
    required int planId,
    required String serverVerificationToken,
  }) async {
    final initApiData = {
      "plan_id": planId,
      "platform": Platform.isAndroid ? AppEnum.android.name : AppEnum.ios.name,
    };

    final validateApiData = {
      "platform": (Platform.isAndroid)
          ? AppEnum.android.name
          : AppEnum.ios.name,
      (Platform.isAndroid) ? "purchase_token" : "receipt_data":
          (Platform.isAndroid) ? serverVerificationToken : AppEnum.ios.name,
    };

    await SubscriptionApiService.instance.initiateSubscription(
      data: initApiData,
    );
    final result = await SubscriptionApiService.instance.validateSubscription(
      data: validateApiData,
    );
    result.fold(
      (l) {
        Logger.printError(l.errorMessage.toString());
      },
      (r) {
        setSubscriptionProcessStatus(status: false);
      },
    );
  }

  void setSubscriptionProcessStatus({required bool status}) {
    isSubscriptionLoading = status;
    notifyListeners();
  }

  Future<void> buySubscription({
    required AppEnum tier,
    required int planId,
    required String planName,
  }) async {
    setSubscriptionProcessStatus(status: true);
    final res = await SubscriptionService().buySubscription(
      tier: tier,
      planId: planId,
      planName: planName,
    );
  }

  // Remove a subscription and update flags
  void removeSubscription(AppEnum tier) {
    _activeSubscriptions.remove(tier);
    _updateTierFlags();
    notifyListeners();
  }

  // Internal: Update boolean flags
  void _updateTierFlags() {
    isTier1Subscribed = _activeSubscriptions.contains(AppEnum.tier1);
    isTier2Subscribed = _activeSubscriptions.contains(AppEnum.tier2);
    isTier3Subscribed = _activeSubscriptions.contains(AppEnum.tier3);
    notifyListeners();
  }

  // Optional: fine-grained feature-level access
  bool hasAccessTo(String feature) {
    switch (feature) {
      case 'daily_mantras':
      case 'history':
      case 'basic_remedies':
        return isTier1Subscribed;
      case 'palmistry':
      case 'birth_chart':
      case 'detailed_remedies':
        return isTier2Subscribed;
      case 'consult':
      case 'all_features':
        return _activeSubscriptions.contains(AppEnum.tier3);
      default:
        return false;
    }
  }

  Future<void> cancelAutoRenewing({
    required BuildContext context,
    required AppEnum tier,
  }) async {
    await SubscriptionService().cancelAutoRenewing(
      context: context,
      tier: tier,
    );
  }

  bool hasSubscription(AppEnum tier) {
    return _activeSubscriptions.contains(tier);
  }
}
