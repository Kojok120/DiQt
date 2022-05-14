import 'package:booqs_mobile/models/answer_analysis.dart';
import 'package:booqs_mobile/models/drill.dart';
import 'package:booqs_mobile/models/note.dart';
import 'package:booqs_mobile/models/review.dart';
import 'package:booqs_mobile/models/weakness.dart';

class Quiz {
  Quiz({
    required this.id,
    required this.drillId,
    this.wordId,
    this.referenceWordId,
    this.sentenceId,
    required this.question,
    required this.langNumberOfQuestion,
    required this.questionReadAloud,
    required this.correctAnswer,
    required this.langNumberOfAnswer,
    required this.answerReadAloud,
    this.distractors,
    required this.flashcard,
    this.explanation,
    this.hint,
    this.drill,
    this.review,
    this.note,
    this.answerAnalysis,
    this.weakness,
  });

  int id;
  int drillId;
  int? wordId;
  int? referenceWordId;
  int? sentenceId;
  String question;
  int langNumberOfQuestion;
  bool questionReadAloud;
  String correctAnswer;
  int langNumberOfAnswer;
  bool answerReadAloud;
  String? distractors;
  bool flashcard;
  String? explanation;
  String? hint;
  Drill? drill;
  Review? review;
  Note? note;
  AnswerAnalysis? answerAnalysis;
  Weakness? weakness;

  Quiz.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        drillId = json['drill_id'],
        wordId = json['word_id'],
        referenceWordId = json['reference_word_id'],
        sentenceId = json['sentence_id'],
        question = json['question'],
        langNumberOfQuestion = json['lang_number_of_question'],
        questionReadAloud = json['question_read_aloud'],
        correctAnswer = json['correct_answer'],
        langNumberOfAnswer = json['lang_number_of_answer'],
        answerReadAloud = json['answer_read_aloud'],
        distractors = json['distractors'],
        flashcard = json['flashcard'],
        explanation = json['explanation'],
        hint = json['hint'],
        drill = json['drill'] == null ? null : Drill.fromJson(json['drill']),
        review =
            json['review'] == null ? null : Review.fromJson(json['review']),
        note = json['note'] == null ? null : Note.fromJson(json['note']),
        answerAnalysis = json['answer_analysis'] == null
            ? null
            : AnswerAnalysis.fromJson(json['answer_analysis']),
        weakness = json['weakness'] == null
            ? null
            : Weakness.fromJson(json['weakness']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'drill_id': drillId,
        'word_id': wordId,
        'reference_word_id': referenceWordId,
        'sentence_id': sentenceId,
        'question': question,
        'lang_number_of_question': langNumberOfQuestion,
        'question_read_aloud': questionReadAloud,
        'correct_answer': correctAnswer,
        'lang_number_of_answer': langNumberOfAnswer,
        'answer_read_aloud': answerReadAloud,
        'distractors': distractors,
        'flashcard': flashcard,
        'explanation': explanation,
        'hint': hint,
        'drill': drill,
        'review': review,
        'note': note,
        'answer_analysis': answerAnalysis,
        'weakness': weakness,
      };
}
