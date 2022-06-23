import 'package:booqs_mobile/models/chapter.dart';
import 'package:booqs_mobile/pages/chapter/show.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChapterCard extends ConsumerWidget {
  const ChapterCard({Key? key, required this.chapter}) : super(key: key);
  final Chapter chapter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1,000のようなdelimiterを使って解答数を整形する。参考： https://stackoverflow.com/questions/62580280/how-to-format-numbers-as-thousands-separators-in-dart
    final formatter = NumberFormat('#,###,000');
    final answerHistoriesCount = formatter.format(chapter.answerHistoriesCount);

    // Chapterページに遷移
    Future _moveToChapterPage(chapter) async {
      // TODO: タグによる経由のページ遷移のために、一応publidUidは渡しておく（タグを改善したら修正する）
      await ChapterShowPage.push(context, chapter.publicUid);
    }

    final image = CachedNetworkImage(
      imageUrl: chapter.thumbnailUrl,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );

    // カードデザインの参考： https://material.io/components/cards/flutter
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        splashColor: Colors.green.withAlpha(30),
        onTap: () {
          _moveToChapterPage(chapter);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              //leading: Image(image: NetworkImage('${chapter.iconUrl}')),
              title: Text(chapter.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Text(
                '$answerHistoriesCount解答',
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
            image,
            Padding(
              padding: const EdgeInsets.only(
                  right: 16.0, left: 16, top: 16, bottom: 32),
              child: Text(
                chapter.introduction,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
