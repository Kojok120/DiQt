import 'package:booqs_mobile/components/dictionary/ai/prompt_select.dart';
import 'package:booqs_mobile/components/dictionary/ai/results.dart';
import 'package:booqs_mobile/data/provider/dictionary.dart';
import 'package:booqs_mobile/data/remote/langs.dart';
import 'package:booqs_mobile/i18n/translations.g.dart';
import 'package:booqs_mobile/models/ai_searcher.dart';
import 'package:booqs_mobile/models/dictionary.dart';
import 'package:booqs_mobile/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DictionaryAIForm extends ConsumerStatefulWidget {
  const DictionaryAIForm(
      {super.key, required this.keyword, required this.dictionary});
  final String keyword;
  final Dictionary dictionary;

  @override
  ConsumerState<DictionaryAIForm> createState() => _DictionaryAIFormState();
}

class _DictionaryAIFormState extends ConsumerState<DictionaryAIForm> {
  bool _isRequesting = false;
  AISearcher? _aiSearcher;

  Future<void> _performAISearch() async {
    setState(() {
      _isRequesting = true;
    });
    final Map resMap = await RemoteLangs.aiSearch(
      keyword: widget.keyword,
      sourceLangNumber: widget.dictionary.langNumberOfEntry,
      targetLangNumber: widget.dictionary.langNumberOfMeaning,
      promptKey: ref.read(dictionaryAIPromptKeyProvider),
      version: 3,
    );
    if (!mounted) return;
    // エラーの場合の処理
    if (ErrorHandler.isErrorMap(resMap)) {
      ErrorHandler.showErrorSnackBar(context, resMap);
      return setState(() {
        _isRequesting = false;
      });
    }
    _aiSearcher = AISearcher.fromJson(resMap['ai_searcher']);
    setState(() {
      _aiSearcher;
      _isRequesting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DictionaryAIPromptSelect(),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isRequesting ? null : _performAISearch,
            child: Text(t.lang.ask_ai,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        DictionaryAIResults(
            aiSearcher: _aiSearcher, isRequesting: _isRequesting),
      ],
    );
  }
}
