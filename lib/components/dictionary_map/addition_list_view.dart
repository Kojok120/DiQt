import 'package:booqs_mobile/components/dictionary_map/addition_list_item.dart';
import 'package:booqs_mobile/components/shared/loading_spinner.dart';
import 'package:booqs_mobile/data/remote/dictionary_maps.dart';
import 'package:booqs_mobile/models/dictionary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:visibility_detector/visibility_detector.dart';

class DictionaryMapAdditionListView extends ConsumerStatefulWidget {
  const DictionaryMapAdditionListView({super.key});

  @override
  DictionaryMapAdditionListViewState createState() =>
      DictionaryMapAdditionListViewState();
}

class DictionaryMapAdditionListViewState
    extends ConsumerState<DictionaryMapAdditionListView> {
  bool _isLoading = false;
  bool _isReached = true;
  int _nextPagekey = 0;
  // 一度に読み込むアイテム数
  static const _pageSize = 10;
  // pageのパラメーターの初期値
  final PagingController<int, Dictionary> _pagingController =
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

    final Map? resMap = await RemoteDictionaryMaps.addition(pageKey, _pageSize);
    if (!mounted) return;
    if (resMap == null) {
      return setState(() {
        _isLoading = false;
        _isReached = false;
      });
    }
    final List<Dictionary> dictionaries = [];
    resMap['dictionaries']
        .forEach((e) => dictionaries.add(Dictionary.fromJson(e)));

    final isLastPage = dictionaries.length < _pageSize;
    if (isLastPage) {
      _pagingController.appendLastPage(dictionaries);
    } else {
      _nextPagekey = pageKey + dictionaries.length;
      // _pagingController.appendLastPage(notices);
      // pageKeyにnullを渡すことで、addPageRequestListener の発火を防ぎ、自動で次のアイテムを読み込まないようにする。
      _pagingController.appendPage(dictionaries, _nextPagekey);
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
    //
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

    return PagedListView<int, Dictionary>(
      pagingController: _pagingController,
      // Vertical viewport was given unbounded heightの解決 ref: https://qiita.com/code-cutlass/items/3a8b759056db1e8f7639
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      builderDelegate: PagedChildBuilderDelegate<Dictionary>(
          itemBuilder: (context, item, index) =>
              DictionaryMapAdditionListItem(dictionary: item),

          // 最下部のローディング ref: https://pub.dev/documentation/infinite_scroll_pagination/latest/infinite_scroll_pagination/PagedChildBuilderDelegate-class.html
          newPageProgressIndicatorBuilder: (_) => loader(),
          // 検索結果なし
          noItemsFoundIndicatorBuilder: (_) => const Text('Not Found'),
          // すべての検索結果の読み込み完了
          noMoreItemsIndicatorBuilder: (_) => const SizedBox(
                height: 120,
              )),
    );
  }
}
