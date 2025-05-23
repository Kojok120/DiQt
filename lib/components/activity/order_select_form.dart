import 'package:booqs_mobile/data/provider/activity.dart';
import 'package:booqs_mobile/i18n/translations.g.dart';
import 'package:booqs_mobile/pages/notice/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivitiesOrderSelectForm extends ConsumerWidget {
  const ActivitiesOrderSelectForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 値に対応するフォームのラベル
    String label(String value) {
      switch (value) {
        case 'all':
          return t.activities.all;
        case 'following':
          return t.activities.following;
        case 'myself':
          return t.activities.myself;
        default:
          return 'Error';
      }
    }

    return Container(
      margin: const EdgeInsets.only(top: 24),
      height: 48,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 15.0, right: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.black87)),
      child: DropdownButton<String>(
        value: ref.watch(activitiesOrderProvider),
        iconSize: 24,
        elevation: 16,
        onChanged: (String? newValue) {
          if (newValue == null) return;
          ref.read(activitiesOrderProvider.notifier).state = newValue;
          NoticeHomePage.push(context, 1);
        },
        items: <String>[
          'all',
          'following',
          'myself',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(label(value),
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87)),
          );
        }).toList(),
      ),
    );
  }
}
