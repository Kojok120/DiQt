import 'package:booqs_mobile/pages/user/premium_plan.dart';
import 'package:booqs_mobile/utils/responsive_values.dart';
import 'package:booqs_mobile/components/button/dialog_close_button.dart';
import 'package:flutter/material.dart';

class AnswerPaywallScreen extends StatelessWidget {
  const AnswerPaywallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveValues.dialogHeight(context),
      width: ResponsiveValues.dialogWidth(context),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      // 閉じるボタンを下端に固定 ref: https://www.choge-blog.com/programming/flutter-bottom-button/
      child: Stack(
        children: [
          Column(children: [
            const SizedBox(height: 16),
            // heading
            const Text('😵スタミナ切れ😵',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange)),
            const SizedBox(height: 16),
            // explanation
            const Text('無料プランで解けるのは、１日に１００問までです。',
                style: TextStyle(fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 32),
            // premiumButton
            Container(
              padding: const EdgeInsets.only(bottom: 16, right: 8, left: 8),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    minimumSize: const Size(double.infinity,
                        48), // 親要素まで横幅を広げる。参照： https://stackoverflow.com/questions/50014342/how-to-make-button-width-match-parent
                  ),
                  onPressed: () {
                    PremiumPlanPage.push(context);
                  },
                  icon: const Icon(Icons.grade, color: Colors.white),
                  label: const Text(
                    'プレミアムプランを見る',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
          ]),
          const DialogCloseButton(),
        ],
      ),
    );
  }
}
