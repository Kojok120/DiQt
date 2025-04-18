import 'package:booqs_mobile/data/provider/solved_quiz_ids.dart';
import 'package:booqs_mobile/routes.dart';
import 'package:booqs_mobile/utils/responsive_values.dart';
import 'package:booqs_mobile/components/layouts/bottom_navbar/bottom_navbar.dart';
import 'package:booqs_mobile/components/shared/empty_app_bar.dart';
import 'package:booqs_mobile/components/weakness/unsolved_screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeaknessUnsolvedPage extends ConsumerStatefulWidget {
  const WeaknessUnsolvedPage({super.key});

  static Future push(BuildContext context) async {
    return Navigator.of(context).pushNamed(weaknessUnsolvedPage);
  }

  @override
  WeaknessUnsolvedPageState createState() => WeaknessUnsolvedPageState();
}

class WeaknessUnsolvedPageState extends ConsumerState<WeaknessUnsolvedPage> {
  @override
  void initState() {
    super.initState();
    // 解答済の問題のIDのリストをリセットする。
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(solvedQuizIdsProvider.notifier).state = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EmptyAppBar(),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
              horizontal: ResponsiveValues.horizontalMargin(context)),
          child: const WeaknessUnsolvedScreenWrapper(),
        ),
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
