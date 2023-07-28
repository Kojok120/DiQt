import 'package:booqs_mobile/models/dictionary.dart';
import 'package:booqs_mobile/models/sentence.dart';
import 'package:booqs_mobile/models/user.dart';

class SentenceRequest {
  SentenceRequest({
    required this.id,
    required this.dictionaryId,
    required this.sentenceId,
    required this.userId,
    required this.original,
    required this.previousOriginal,
    required this.langNumberOfOriginal,
    required this.translation,
    required this.previousTranslation,
    required this.langNumberOfTranslation,
    required this.explanation,
    required this.previousExplanation,
    required this.addition,
    required this.modification,
    required this.elimination,
    required this.acceptance,
    required this.rejection,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.sentence,
    this.dictionary,
  });
  int id;
  int dictionaryId;
  int? sentenceId;
  int? userId;
  String? original;
  String? previousOriginal;
  int? langNumberOfOriginal;
  String? translation;
  String? previousTranslation;
  int? langNumberOfTranslation;
  String? explanation;
  String? previousExplanation;
  bool addition;
  bool modification;
  bool elimination;
  bool acceptance;
  bool rejection;
  DateTime createdAt;
  DateTime updatedAt;
  Dictionary? dictionary;
  Sentence? sentence;
  User? user;

  SentenceRequest.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        dictionaryId = json['dictionary_id'],
        sentenceId = json['sentence_id'],
        userId = json['user_id'],
        original = json['original'],
        previousOriginal = json['previous_original'],
        translation = json['translation'],
        previousTranslation = json['previous_translation'],
        explanation = json['explanation'],
        previousExplanation = json['previous_explanation'],
        addition = json['addition'],
        modification = json['modification'],
        elimination = json['elimination'],
        acceptance = json['acceptance'],
        rejection = json['rejection'],
        createdAt = DateTime.parse(json['created_at']),
        updatedAt = DateTime.parse(json['updated_at']),
        dictionary = json['dictionary'] == null
            ? null
            : Dictionary.fromJson(json['dictionary']),
        sentence = json['sentence'] == null
            ? null
            : Sentence.fromJson(json['sentence']),
        user = json['user'] == null ? null : User.fromJson(json['user']);

  bool isPending() => acceptance == false && rejection == false;

  Map<String, dynamic> toJson() => {
        'id': id,
        'dictionary_id': dictionaryId,
        'sentence_id': sentenceId,
        'user_id': userId,
        'original': original,
        'previous_original': previousOriginal,
        'translation': translation,
        'previous_translation': previousTranslation,
        'addition': addition,
        'modification': modification,
        'elimination': elimination,
        'acceptance': acceptance,
        'rejection': rejection,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'dictionary': dictionary,
        'sentence': sentence,
        'user': user,
      };
}
