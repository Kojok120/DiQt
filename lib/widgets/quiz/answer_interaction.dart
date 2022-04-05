import 'package:booqs_mobile/models/quiz.dart';
import 'package:booqs_mobile/notification/answer.dart';
import 'package:booqs_mobile/widgets/quiz/exp_indicator.dart';
import 'package:booqs_mobile/widgets/quiz/explanation_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider((ref) => 0);

class QuizAnswerInteraction extends ConsumerWidget {
  const QuizAnswerInteraction({Key? key, required this.notification})
      : super(key: key);
  final AnswerNotification notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Quiz _quiz = notification.quiz;
    final bool _correct = notification.correct;
    final String? _correctAnswer = _quiz.correctAnswer;
    final String? _usersAnswer = notification.usersAnswer;

    Widget _correctAnswerWidget() {
      return Container(
        margin: const EdgeInsets.only(bottom: 16, top: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: const Icon(Icons.circle_outlined,
                  color: Colors.white, size: 24),
            ),
            // Expandedを使うと短い文章でも幅全体を埋めてしまい、結果的に左寄せになってしまうので Flexible を使う。
            Flexible(
              child: Text(
                '$_correctAnswer',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      );
    }

    Widget _incorrectFeedback() {
      if (_correct) return Container();

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: const Icon(Icons.clear, color: Colors.white, size: 24),
            ),
            Flexible(
              child: Text(
                '$_usersAnswer',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      );
    }

    Widget _expIndicator() {
      if (_correct == false) return Container();
      //final counter = ref.watch(counterProvider);
      return QuizExpIndicator(initialExp: 9, gainedExp: 3);
    }

    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
      },
      child: Column(
          // 画面一杯にSnackbarが広がるのを防ぐ ref: https://stackoverflow.com/questions/61790405/how-to-avoid-that-a-column-inside-a-snackbar-occupies-100-of-the-height
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _correctAnswerWidget(),
            _incorrectFeedback(),
            _expIndicator(),
            QuizExplanationButton(quiz: _quiz),
            const SizedBox(height: 8),
          ]),
    );
  }
}
