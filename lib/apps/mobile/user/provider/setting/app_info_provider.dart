import 'dart:core';

import 'package:astrology_app/core/utils/custom_toast.dart';
import 'package:flutter/cupertino.dart';

import '../../services/settings/app_info_service.dart';

class AppInfoProvider extends ChangeNotifier {
  List termsAndCondition = [];
  List<FaqModel> faqs = [];
  List<SpiritualDisclaimerModel> spiritualDisclaimers = [];
  PrivacyPolicyModel? privacyPolicy;

  Future<void> init({required BuildContext context}) async {
    await Future.wait([
      getSpiritualDisclaimers(context: context),
      getFaqs(context: context),
      getTermsAndCondition(context: context),
    ]);
  }

  bool isTermsAndConditionLoading = false;
  Future<void> getTermsAndCondition({required BuildContext context}) async {
    isTermsAndConditionLoading = true;
    notifyListeners();
    final result = await AppInfoService.instance.getTermsAndCondition();
    result.fold(
      (l) {
        AppToast.error(context: context, message: l.errorMessage);
      },
      (r) {
        termsAndCondition = r["data"]["sections"];
        termsAndCondition.removeLast();
        termsAndCondition.removeLast();
        isFAQLoading = false;
        notifyListeners();
      },
    );
  }

  bool isFAQLoading = false;
  Future<void> getFaqs({required BuildContext context}) async {
    isFAQLoading = true;
    faqs = [];
    notifyListeners();
    final result = await AppInfoService.instance.getFaqs();
    result.fold(
      (l) {
        AppToast.error(context: context, message: l.errorMessage);
      },
      (r) {
        faqs = (r["data"]["faqs"] as List)
            .map((e) => FaqModel.fromJson(e))
            .toList();
        isFAQLoading = false;
        notifyListeners();
      },
    );
  }

  bool isSpiritualDisclaimersLoading = false;
  Future<void> getSpiritualDisclaimers({required BuildContext context}) async {
    isSpiritualDisclaimersLoading = true;

    notifyListeners();
    final result = await AppInfoService.instance.getSpiritualDisclaimers();
    result.fold(
      (l) {
        AppToast.error(context: context, message: l.errorMessage);
      },
      (r) {
        spiritualDisclaimers = (r["data"]["sections"] as List)
            .map((e) => SpiritualDisclaimerModel.fromJson(e))
            .toList();
        isSpiritualDisclaimersLoading = false;
        notifyListeners();
      },
    );
  }

  bool isPrivacyPolicyLoading = false;

  Future<void> getPrivacyPolicy({required BuildContext context}) async {
    isPrivacyPolicyLoading = true;
    notifyListeners();

    final result = await AppInfoService.instance.getPrivacyPolicy();

    result.fold(
      (l) {
        AppToast.error(context: context, message: l.errorMessage);
        isPrivacyPolicyLoading = false;
        notifyListeners();
      },
      (r) {
        privacyPolicy = PrivacyPolicyModel.fromJson(r["data"]);
        isPrivacyPolicyLoading = false;
        notifyListeners();
      },
    );
  }
}

class FaqModel {
  String question;
  String answer;

  FaqModel({required this.question, required this.answer});

  factory FaqModel.fromJson(Map<String, dynamic> json) =>
      FaqModel(question: json["question"], answer: json["answer"]);
}

class SpiritualDisclaimerModel {
  String topic;
  String details;

  SpiritualDisclaimerModel({required this.topic, required this.details});

  factory SpiritualDisclaimerModel.fromJson(Map<String, dynamic> json) =>
      SpiritualDisclaimerModel(
        topic: json["heading"],
        details: json["content"],
      );
}

class PrivacyPolicyModel {
  final String title;
  final List<PrivacySection> sections;

  PrivacyPolicyModel({required this.title, required this.sections});

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyModel(
      title: json['title'] ?? '',
      sections: (json['sections'] as List)
          .map((e) => PrivacySection.fromJson(e))
          .toList(),
    );
  }
}

class PrivacySection {
  final String heading;
  final dynamic
  content; // Can be String, List<String>, or List<PrivacySectionContent>

  PrivacySection({required this.heading, required this.content});

  factory PrivacySection.fromJson(Map<String, dynamic> json) {
    final rawContent = json['content'];

    if (rawContent is String) {
      return PrivacySection(heading: json['heading'], content: rawContent);
    } else if (rawContent is List) {
      if (rawContent.isEmpty) {
        return PrivacySection(heading: json['heading'], content: []);
      } else if (rawContent.first is String) {
        return PrivacySection(
          heading: json['heading'],
          content: List<String>.from(rawContent),
        );
      } else if (rawContent.first is Map<String, dynamic>) {
        return PrivacySection(
          heading: json['heading'],
          content: rawContent
              .map((e) => PrivacySectionContent.fromJson(e))
              .toList(),
        );
      }
    }

    return PrivacySection(heading: json['heading'], content: null);
  }
}

class PrivacySectionContent {
  final String type;
  final String details;

  PrivacySectionContent({required this.type, required this.details});

  factory PrivacySectionContent.fromJson(Map<String, dynamic> json) {
    return PrivacySectionContent(
      type: json['type'] ?? '',
      details: json['details'] ?? '',
    );
  }
}
