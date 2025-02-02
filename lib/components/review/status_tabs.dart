import 'package:booqs_mobile/data/provider/current_user.dart';
import 'package:booqs_mobile/i18n/translations.g.dart';
import 'package:booqs_mobile/pages/review/all.dart';
import 'package:booqs_mobile/pages/review/index.dart';
import 'package:booqs_mobile/pages/review/scheduled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReviewStatusTabs extends ConsumerWidget {
  const ReviewStatusTabs({super.key, required this.selected});
  final String selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int unsolvedReviewsCount = ref.watch(unsolvedReviewsCountProvider);
    final int reviewsCount = ref.watch(reviewsCountProvider);
    final int solvedReviewsCount = ref.watch(solvedReviewsCountProvider);

    const selectedStyle = TextStyle(
        color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold);
    const normalStyle = TextStyle(
        color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold);

    Widget unreviewed() {
      final style = selected == 'unreviewed' ? selectedStyle : normalStyle;
      final text = RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: '${t.reviews.unreviewed}\n($unsolvedReviewsCount)',
            style: style),
      );
      return InkWell(
        onTap: () {
          ReviewIndexPage.push(context);
        },
        child: Container(alignment: Alignment.center, child: text),
      );
    }

    Widget scheduled() {
      final style = selected == 'scheduled' ? selectedStyle : normalStyle;
      final text = RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: '${t.reviews.scheduled}\n($solvedReviewsCount)',
            style: style),
      );
      return InkWell(
        onTap: () {
          ReviewScheduledPage.push(context);
        },
        child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(width: 0.5, color: Colors.black54),
                right: BorderSide(width: 0.5, color: Colors.black54),
              ),
            ),
            child: text),
      );
    }

    Widget all() {
      final style = selected == 'all' ? selectedStyle : normalStyle;
      final text = RichText(
        textAlign: TextAlign.center,
        text: TextSpan(text: '${t.reviews.all}\n($reviewsCount)', style: style),
      );
      return InkWell(
        onTap: () {
          ReviewAllPage.push(context);
        },
        child: Container(alignment: Alignment.center, child: text),
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: unreviewed(),
        ),
        Expanded(flex: 1, child: scheduled()),
        Expanded(flex: 1, child: all()),
      ],
    );
  }
}
