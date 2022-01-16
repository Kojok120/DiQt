import 'package:booqs_mobile/models/user.dart';
import 'package:booqs_mobile/utils/level_calculator.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class UserExpIndicator extends StatelessWidget {
  const UserExpIndicator({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    final int? exp = user.amountOfExp;
    final int level = LevelCalculator.levelForExp(exp!).floor();
    // Web版BooQsのusers/show.html.erbに書いたRubyの処理のDart版。
    final int requiredExp =
        LevelCalculator.requiredExpForTheLevel(level).floor();

    final int digestedExp = LevelCalculator.digestedExp(level).floor();
    final int progress = exp - digestedExp;
    // 次のレベルアップまでの獲得経験値のパーセンテージ
    double percent = progress / requiredExp;
    int percentInt = (percent * 100.0).floor();
    // 次のレベルアップに必要な経験値
    int expForNextLevel = requiredExp - progress;
    // 小数点以下の微妙な差で、レベルアップに必要な残り経験値が０になってしまう問題への対処。
    if (expForNextLevel == 0) {
      expForNextLevel = 1;
    }
    // 小数点以下の微妙な差で、表示レベルが繰り上がってしまう問題の対処。
    final digestedExpOnTheNextLevel = LevelCalculator.digestedExp(level + 1);
    if (exp == digestedExpOnTheNextLevel.toInt() &&
        exp < digestedExpOnTheNextLevel) {
      percent = 0.99;
      expForNextLevel = 1;
    }

    Widget _levelLabel() {
      return Container(
        padding: const EdgeInsets.only(bottom: 10),
        alignment: Alignment.centerLeft,
        child: Text(
          'Lv.$level',
          style: const TextStyle(
              color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      );
    }

    Widget _expIndicator() {
      return LinearPercentIndicator(
        animation: true,
        animateFromLastPercent: true,
        lineHeight: 40.0,
        animationDuration: 500,
        percent: percent,
        center: Text(
          "$percentInt%",
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        linearStrokeCap: LinearStrokeCap.roundAll,
        progressColor: Colors.orange,
        padding: const EdgeInsets.symmetric(horizontal: 16),
      );
    }

    Widget _expForNextLevel() {
      return Container(
        padding: const EdgeInsets.only(top: 16),
        alignment: Alignment.centerLeft,
        child: Text('次のレベルまであと${expForNextLevel}EXP',
            style: const TextStyle(color: Colors.black87, fontSize: 16)),
      );
    }

    Widget _status() {
      const textStyle = TextStyle(color: Colors.black87, fontSize: 16);
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('獲得経験値：${exp}EXP', style: textStyle),
              Text('解答回数：${user.answerHistoriesCount}回', style: textStyle),
              Text('解答日数：${user.answerDaysCount}日', style: textStyle),
            ]),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: <Widget>[
          _levelLabel(),
          _expIndicator(),
          _expForNextLevel(),
          _status(),
        ],
      ),
    );
  }
}
