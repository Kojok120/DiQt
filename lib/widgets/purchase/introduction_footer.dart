import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// 購入ボタンの下に表示する注意書きなど
class PurchaseIntroductionFooter extends StatelessWidget {
  const PurchaseIntroductionFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      width: MediaQuery.of(context).size.width,
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 10,
            color: Colors.black54,
          ),
          children: [
            const TextSpan(text: "・プレミアム契約期間は開始日から起算して1ヶ月または1年ごとの自動更新となります\n"),
            const TextSpan(text: "・"),
            TextSpan(
              text: "プライバシーポリシー",
              style: const TextStyle(decoration: TextDecoration.underline),
              // テキスト内リンクの実装方法：ref: https://qiita.com/chooyan_eng/items/9e8f6ca2af55ea0e683a
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launch("https://www.booqs.net/ja/privacy_policy",
                      forceSafariVC: true);
                },
            ),
            const TextSpan(
              text: " / ",
            ),
            TextSpan(
              text: "利用規約",
              style: const TextStyle(decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launch("https://www.booqs.net/ja/terms_of_service",
                      forceSafariVC: true);
                },
            ),
            const TextSpan(
              text: " / ",
            ),
            TextSpan(
              text: "特定商取引法に基づく表示",
              style: const TextStyle(decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launch("https://www.booqs.net/ja/legal", forceSafariVC: true);
                },
            ),
            const TextSpan(
              text: " / ",
            ),
            TextSpan(
              text: "EULA",
              style: const TextStyle(decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launch(
                      "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/",
                      forceSafariVC: true);
                },
            ),
            const TextSpan(
              text: "をご確認のうえ登録してください\n",
            ),
            const TextSpan(
              text: "・プレミアム契約期間の終了日の24時間以上前に解約しない限り契約期間が自動更新されます\n",
            ),
          ],
        ),
      ),
    );
  }
}
