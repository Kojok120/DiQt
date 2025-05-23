import 'package:booqs_mobile/components/layouts/app_bar/default.dart';
import 'package:booqs_mobile/i18n/translations.g.dart';
import 'package:booqs_mobile/models/tab_info.dart';
import 'package:booqs_mobile/pages/activity/index.dart';
import 'package:booqs_mobile/pages/notice/index.dart';
import 'package:booqs_mobile/routes.dart';
import 'package:booqs_mobile/utils/responsive_values.dart';
import 'package:booqs_mobile/utils/size_config.dart';
import 'package:booqs_mobile/components/layouts/bottom_navbar/bottom_navbar.dart';
import 'package:flutter/material.dart';

class NoticeHomePage extends StatefulWidget {
  const NoticeHomePage({super.key, this.initialndex});
  final int? initialndex;

  static Future push(BuildContext context, int initialndex) async {
    // return Navigator.of(context).pushNamed(notificationIndexPage);
    // アニメーションなしで画面遷移させる。 参考： https://stackoverflow.com/questions/49874272/how-to-navigate-to-other-page-without-animation-flutter
    return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        // 画面遷移のログを送信するために、settings.nameを設定する。
        settings: const RouteSettings(name: noticeHomePage),
        pageBuilder: (context, animation1, animation2) =>
            NoticeHomePage(initialndex: initialndex),
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  State<NoticeHomePage> createState() => _NoticeHomePageState();
}

class _NoticeHomePageState extends State<NoticeHomePage> {
  final List<TabInfo> _tabs = [
    TabInfo(t.notices.notifications, const NoticeIndexPage()),
    TabInfo(t.activities.activities, const ActivityIndexPage()),
  ];

  @override
  Widget build(BuildContext context) {
    final int initialIndex = widget.initialndex ?? 0;

    List<Widget> tabBars() {
      SizeConfig().init(context);
      double grid = SizeConfig.blockSizeHorizontal ?? 0;
      double width = grid * 40;
      return [
        SizedBox(width: width, child: Tab(text: t.notices.notifications)),
        SizedBox(width: width, child: Tab(text: t.activities.activities)),
      ];
    }

    return DefaultTabController(
      initialIndex: initialIndex,
      length: 2,
      //length: _tabs.length,
      child: Scaffold(
        appBar: AppBarDefault(
          automaticallyImplyLeading: false,
          // タイトル部分を消す ref: https://blog.mrym.tv/2019/09/flutter-tabbar-without-appbar-title/
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TabBar(
                isScrollable: true,
                tabs: tabBars(),
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(
            horizontal: ResponsiveValues.horizontalMargin(context),
          ),
          child: TabBarView(children: _tabs.map((tab) => tab.widget).toList()),
        ),
        bottomNavigationBar: const BottomNavbar(),
      ),
    );
  }
}
