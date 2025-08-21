import 'package:flutter/material.dart';

import '../../../../../core/constants/text_style.dart';
import '../../../../../core/widgets/app_layout.dart';
import '../../../../../core/widgets/app_text.dart';

class ConsultScreen extends StatelessWidget {
  const ConsultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: Center(
        child: AppText(text: "Consult Section", style: regular()),
      ),
    );
  }
}
