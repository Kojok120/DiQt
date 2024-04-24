import 'package:booqs_mobile/models/drill.dart';
import 'package:booqs_mobile/models/quiz.dart';
import 'package:booqs_mobile/utils/sanitizer.dart';
import 'package:booqs_mobile/components/drill/icon.dart';
import 'package:booqs_mobile/components/quiz/item/drill_title.dart';
import 'package:booqs_mobile/components/quiz/item/hint_button.dart';
import 'package:booqs_mobile/components/quiz/item/question_text.dart';
import 'package:booqs_mobile/components/shared/tts_button.dart';
import 'package:flutter/material.dart';

class QuizItemQuestionPart extends StatelessWidget {
  const QuizItemQuestionPart({
    Key? key,
    required this.quiz,
    required this.drill,
  }) : super(key: key);
  final Quiz quiz;
  final Drill drill;

  @override
  Widget build(BuildContext context) {
    Widget ttsBtn() {
      if (quiz.questionReadAloud) {
        // TTSできちんと読み上げるためにDiQtリンクを取り除いた平文をつくる
        final String questionPlainText =
            Sanitizer.removeDiQtLink(quiz.question);
        return Container(
          margin: const EdgeInsets.only(top: 4),
          alignment: Alignment.bottomLeft,
          child: TtsButton(
            speechText: questionPlainText,
            langNumber: quiz.langNumberOfQuestion,
          ),
        );
      }
      return Container();
    }

    return Row(
      children: [
        DrillIcon(drill: drill),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            QuizItemDrillTitle(drill: drill),
            QuizItemQuestionText(
              quiz: quiz,
            ),
            const SizedBox(height: 8),
            ttsBtn(),
            QuizItemHintButton(quiz: quiz),
          ]),
        ),
      ],
    );
  }
}
