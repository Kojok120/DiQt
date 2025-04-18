import 'package:booqs_mobile/data/provider/current_user.dart';
import 'package:booqs_mobile/data/remote/reviews.dart';
import 'package:booqs_mobile/i18n/translations.g.dart';
import 'package:booqs_mobile/pages/review/all.dart';
import 'package:booqs_mobile/utils/responsive_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReviewBulkDeletionScreen extends ConsumerStatefulWidget {
  const ReviewBulkDeletionScreen({super.key});

  @override
  ReviewBulkDeletionScreenState createState() =>
      ReviewBulkDeletionScreenState();
}

class ReviewBulkDeletionScreenState
    extends ConsumerState<ReviewBulkDeletionScreen> {
  @override
  Widget build(BuildContext context) {
    Future submit() async {
      EasyLoading.show(status: 'loading...');
      final Map? resMap = await RemoteReviews.destroyAll();
      EasyLoading.dismiss();
      if (resMap == null) return;
      final snackBar = SnackBar(content: Text(t.reviews.delete_all_reviews_completed));
      // currentUserの再読み込みでカウントをリセットする
      ref.invalidate(asyncCurrentUserProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      ReviewAllPage.push(context);
    }

    final cancelButton = ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey,
        minimumSize: const Size(144,
            40), // 親要素まで横幅を広げる。参照： https://stackoverflow.com/questions/50014342/how-to-make-button-width-match-parent
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: const Icon(Icons.close, color: Colors.white),
      label: Text(
        t.reviews.cancel,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
      ),
    );

    final submitButton = TextButton.icon(
      onPressed: () {
        submit();
      },
      icon: const Icon(
        Icons.delete,
        size: 18,
        color: Colors.red,
      ),
      label: Text(t.reviews.execute,
          style: TextStyle(
              fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.only(
          left: 32,
        ),
      ),
    );

    return Container(
      width: ResponsiveValues.dialogWidth(context),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.reviews.confirm_deletion,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 16),
          Text(t.reviews.delete_all_reviews_confirmation,
              style: TextStyle(fontSize: 16, color: Colors.black87)),
          const SizedBox(height: 32),
          Wrap(
            children: [cancelButton, submitButton],
          )
        ],
      )),
    );
  }
}
