import 'dart:io';

import 'package:astrology_app/apps/mobile/user/model/settings/subscription_plan_model.dart';
import 'package:astrology_app/apps/mobile/user/services/settings/subscription_api_service.dart';
import 'package:astrology_app/core/utils/custom_toast.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/enum/app_enums.dart';
import '../../../../../core/utils/de_bouncing.dart';
import '../../../../../core/utils/logger.dart';
import '../../screens/user_dashboard.dart';
import '../../services/subscription/subscription_service.dart';

class SubscriptionProvider extends ChangeNotifier {
  //todo ----------------> Subscription API service
  List<SubscriptionPlanModel>? subscriptionPlans;
  ActiveSubscriptionPlanModel? activeSubscriptionPlan;
  String appAccountToken = "";

  bool isPlansLoading = true;
  Future<void> getSubscriptionPlans() async {
    isPlansLoading = true;
    notifyListeners();
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
    isPlansLoading = false;
    notifyListeners();
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
        //todo must be need to change right side if in the API price format get changes
        if (r["data"]["price"] == "5 USD") {
          addSubscription(AppEnum.tier1);
          addSubscription(AppEnum.tier2);
        }
        if (r["data"]["price"] == "2 USD") {
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

  Future<void> updateSubscriptionInDataBase({
    required AppEnum tier,
    required String serverVerificationData,
    required BuildContext context,
    required bool isRestore,
    required VoidCallback onSuccess,
  }) async {
    final validateApiData = {
      "platform": (Platform.isAndroid)
          ? AppEnum.android.name
          : AppEnum
                .ios
                .name, //ilkminbcnljcgigbmpaocgfl.AO-J1Oxs5qEbs7hlOEdwcbFJbVKs-5kXWcejsJKWQvvEVuRS1baXZXHcYGlhGk1CO7ThQkUwQrUNNrcwq5uf6Rm9_X3VRmKC0VEgD5TzWGTNecIHEj9G22U
      (Platform.isAndroid) ? "purchase_token" : "receipt_data":
          serverVerificationData,
    };
    // todo validation API
    final result = await SubscriptionApiService.instance.validateSubscription(
      data: validateApiData,
    );

    result.fold(
      (l) {
        Logger.printError(l.errorMessage.toString());
      },
      (r) {
        deBouncer.run(() {
          setSubscriptionProcessStatus(status: false);
          AppToast.success(
            context: context,
            message: (tier == AppEnum.tier1)
                ? "Tier 1 Purchased Successfully"
                : "Tier 2 Purchased Successfully",
          );
          indexTabUser.value = 0;
          onSuccess.call();
        });
      },
    );
  }

  void setSubscriptionProcessStatus({required bool status}) {
    Logger.printInfo("Updating loading status");
    isSubscriptionLoading = status;
    notifyListeners();
  }

  Future<void> buySubscription({
    required AppEnum tier,
    required int planId,
    required BuildContext context,
  }) async {
    setSubscriptionProcessStatus(status: true);
    final initApiData = {
      "plan_id": planId,
      "platform": Platform.isAndroid ? AppEnum.android.name : AppEnum.ios.name,
    };
    final result = await SubscriptionApiService.instance.initiateSubscription(
      data: initApiData,
    );
    if (Platform.isIOS) {
      result.fold(
        (l) {
          Logger.printInfo(
            "Error in initiate-subscription API ${l.errorMessage}",
          );
        },
        (r) {
          appAccountToken =
              "c04412ce-b848-40cd-a31c-d82d61b2422d"; //r["data"]["app_account_token"];
        },
      );
    }

    if (Platform.isIOS) {
      await SubscriptionService().buySubscription(
        tier: tier,
        planId: planId,
        context: context,
        appAccountToken: appAccountToken,
      );
    } else {
      await SubscriptionService().buySubscription(
        tier: tier,
        planId: planId,
        context: context,
      );
    }
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
