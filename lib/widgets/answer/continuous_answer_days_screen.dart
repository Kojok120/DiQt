import 'package:audioplayers/audioplayers.dart';
import 'package:booqs_mobile/consts/sounds.dart';
import 'package:booqs_mobile/data/provider/answer_setting.dart';
import 'package:booqs_mobile/data/provider/user.dart';
import 'package:booqs_mobile/models/answer_creator.dart';
import 'package:booqs_mobile/models/user.dart';
import 'package:booqs_mobile/utils/diqt_url.dart';
import 'package:booqs_mobile/utils/responsive_values.dart';
import 'package:booqs_mobile/widgets/answer/share_button.dart';
import 'package:booqs_mobile/widgets/button/dialog_close_button.dart';
import 'package:booqs_mobile/widgets/exp/gained_exp_indicator.dart';
import 'package:booqs_mobile/widgets/shared/dialog_confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnswerContinuousAnswerDaysScreen extends ConsumerStatefulWidget {
  const AnswerContinuousAnswerDaysScreen(
      {Key? key, required this.answerCreator})
      : super(key: key);
  final AnswerCreator answerCreator;

  @override
  _AnswerContinuousAnswerDaysScreenState createState() =>
      _AnswerContinuousAnswerDaysScreenState();
}

class _AnswerContinuousAnswerDaysScreenState
    extends ConsumerState<AnswerContinuousAnswerDaysScreen> {
  final _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 効果音
      final bool seEnabled = ref.watch(seEnabledProvider);
      if (seEnabled) {
        _audioPlayer.play(AssetSource(continousSound), volume: 0.8);
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AnswerCreator answerCreator = widget.answerCreator;
    // 開始経験値（初期 + 問題集周回報酬 + 解答日数報酬）
    final int initialExp = answerCreator.startPoint +
        answerCreator.lapClearPoint +
        answerCreator.answerDaysPoint;
    // 獲得経験値
    final int gainedExp = answerCreator.continuousAnswerDaysPoint;
    // 記録
    final int counter = answerCreator.continuousAnswerDaysCount ?? 0;

    Widget _twitterShareButton() {
      final User? user = ref.watch(currentUserProvider);
      if (user == null) return Container();

      final String tweet = '$counter日連続で問題を解きました！！';
      final String url =
          '${DiQtURL.root(context)}/users/${user.publicUid}?continuous=$counter';
      return AnswerShareButton(text: tweet, url: url);
    }

    return Container(
      height: ResponsiveValues.dialogHeight(context),
      width: ResponsiveValues.dialogWidth(context),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      // 閉じるボタンを下端に固定 ref: https://www.choge-blog.com/programming/flutter-bottom-button/
      child: Stack(
        children: [
          Column(children: [
            const SizedBox(height: 16),
            Text('$counter日連続解答',
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange)),
            ExpGainedExpIndicator(
              initialExp: initialExp,
              gainedExp: gainedExp,
            ),
            const SizedBox(height: 16),
            _twitterShareButton()
          ]),
          const DialogCloseButton(),
          const DialogConfetti(),
        ],
      ),
    );
  }
}
