import 'package:booqs_mobile/components/shared/loading_spinner.dart';
import 'package:booqs_mobile/components/word_request/list_item.dart';
import 'package:booqs_mobile/data/remote/word_requests.dart';
import 'package:booqs_mobile/i18n/translations.g.dart';
import 'package:booqs_mobile/models/word_request.dart';
import 'package:booqs_mobile/utils/error_handler.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:visibility_detector/visibility_detector.dart';

class WordRequestDictionaryListView extends StatefulWidget {
  const WordRequestDictionaryListView(
      {super.key, required this.dictionaryId, required this.selected});
  final int dictionaryId;
  final String selected;

  @override
  State<WordRequestDictionaryListView> createState() =>
      _WordRequestDictionaryListViewState();
}

class _WordRequestDictionaryListViewState
    extends State<WordRequestDictionaryListView> {
  bool _isLoading = false;
  bool _isReached = true;
  int _nextPagekey = 0;
  // 一度に読み込むアイテム数
  static const _pageSize = 10;
  // pageのパラメーターの初期値
  final PagingController<int, WordRequest> _pagingController =
      PagingController(firstPageKey: 0);
  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  // ページに合わせてアイテムを読み込む
  Future<void> _fetchPage(int pageKey) async {
    if (_isLoading) return;
    if (_isReached == false) return;
    _isLoading = true;

    final Map resMap = await RemoteWordRequests.listForDictionary(
        dictionaryId: widget.dictionaryId,
        type: widget.selected,
        pageKey: pageKey,
        pageSize: _pageSize);
    if (!mounted) return;
    if (ErrorHandler.isErrorMap(resMap)) {
      ErrorHandler.showErrorSnackBar(context, resMap);
      return setState(() {
        _isLoading = false;
        _isReached = false;
      });
    }
    final List<WordRequest> wordRequests = [];
    try {
      resMap['word_requests']
          .forEach((e) => wordRequests.add(WordRequest.fromJson(e)));
    } catch (e) {
      print(e);
    }

    final isLastPage = wordRequests.length < _pageSize;
    if (isLastPage) {
      _pagingController.appendLastPage(wordRequests);
    } else {
      _nextPagekey = pageKey + wordRequests.length;
      // _pagingController.appendLastPage(notices);
      // pageKeyにnullを渡すことで、addPageRequestListener の発火を防ぎ、自動で次のアイテムを読み込まないようにする。
      _pagingController.appendPage(wordRequests, _nextPagekey);
    }

    setState(() {
      _isReached = false;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget loader() {
      // ref: https://qiita.com/kikuchy/items/07d10394a4f7aa2a3836
      return VisibilityDetector(
        key: const Key("for detect visibility"),
        onVisibilityChanged: (info) {
          // [visibleFraction] 0で非表示、１で完全表示。0.1は上部が少し表示されている状態 ref: https://pub.dev/documentation/visibility_detector/latest/visibility_detector/VisibilityInfo/visibleFraction.html
          if (info.visibleFraction > 0.1) {
            if (_isLoading) return;
            setState(() {
              _isReached = true;
            });
            // 最下部までスクロールしたら、次のアイテムを読み込む ref: https://pub.dev/documentation/infinite_scroll_pagination/latest/infinite_scroll_pagination/PagingController/notifyPageRequestListeners.html
            _pagingController.notifyPageRequestListeners(_nextPagekey);
          }
        },
        child: Container(
          padding: const EdgeInsets.only(bottom: 100),
          child: const LoadingSpinner(),
        ),
      );
    }

    return PagedListView<int, WordRequest>(
      pagingController: _pagingController,
      // Vertical viewport was given unbounded heightの解決 ref: https://qiita.com/code-cutlass/items/3a8b759056db1e8f7639
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      builderDelegate: PagedChildBuilderDelegate<WordRequest>(
          itemBuilder: (context, item, index) => WordRequestListItem(
                wordRequest: item,
              ),
          // 最下部のローディング ref: https://pub.dev/documentation/infinite_scroll_pagination/latest/infinite_scroll_pagination/PagedChildBuilderDelegate-class.html
          newPageProgressIndicatorBuilder: (_) => loader(),
          // 検索結果なし
          noItemsFoundIndicatorBuilder: (_) => Text(
              t.shared.no_items_found(name: t.wordRequests.edit_histories))),
    );
  }
}
