import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toastification/toastification.dart';

import 'apps.dart';
import 'apps/mobile/user/services/settings/locale_storage_service.dart';

ValueNotifier<bool> isNetworkConnected = ValueNotifier(true);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Future.wait([LocaleStoaregService.init()]);
  runApp(ToastificationWrapper(child: const MyApp()));
}

//todo app changes :
/*

todo Vimaal

sandbox password:
-> Test.dds123@

todo vimal

flutter: Logger --- com.innerpeacepath.tier2com.innerpeacepath.tier2
flutter: Logger --- appAccountToken : c04412ce-b848-40cd-a31c-d82d61b2422d
flutter: Logger --- App is resumed
[ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception: PlatformException(unknown, StoreKitError, Stacktrace: ["0   in_app_purchase_storekit            0x00000001011855c0 $s24in_app_purchase_storekit9wrapError33_BC2CAEBD20FEC9FF40EE5DB65CBC2405LLySayypSgGypF + 596", "1   in_app_purchase_storekit            0x000000010118ae14 $s24in_app_purchase_storekit22InAppPurchase2APISetupC5setUp15binaryMessenger3api20messageChannelSuffixySo013FlutterBinaryL0_p_AA0efG3API_pSgSStFZyypSg_yAKctcfU1_ys6ResultOyAA018SK2ProductPurchaseT7MessageOs5Error_pGcfU_ + 108", "2   in_app_purchase_storekit            0x0000000101180608 $s24in_app_purchase_storekit19InAppPurchasePluginC0C02id7options10completionySS_AA010SK2ProductG14OptionsMessageVSgys6ResultOyAA0lmgpO0Os5Error_pGctFyyYacfU_TY6_ + 112", "3   in_app_purchase_storekit            0x0000000101184a15 $s24in_app_purchase_storekit19InAppPurchasePluginC11countryCode10completionyys6ResultOySSs5Error_pGc_tFyyYacfU_TATQ0_ + 1", "4   in_app_purchase_storekit <…>
flutter: Logger --- App is resumed
*/
