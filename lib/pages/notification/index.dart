import 'package:booqs_mobile/data/provider/answer_setting.dart';
import 'package:booqs_mobile/data/provider/current_user.dart';
import 'package:booqs_mobile/data/remote/notifications.dart';
import 'package:booqs_mobile/models/user.dart';
import 'package:booqs_mobile/routes.dart';
import 'package:booqs_mobile/utils/ad/app_banner.dart';
import 'package:booqs_mobile/utils/push_notification.dart';
import 'package:booqs_mobile/utils/user_setup.dart';
import 'package:booqs_mobile/widgets/session/external_link_dialog.dart';
import 'package:booqs_mobile/widgets/shared/bottom_navbar.dart';
import 'package:booqs_mobile/widgets/shared/drawer_menu.dart';
import 'package:booqs_mobile/widgets/shared/entrance.dart';
import 'package:booqs_mobile/widgets/shared/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationIndexPage extends ConsumerStatefulWidget {
  const NotificationIndexPage({Key? key}) : super(key: key);

  static Future push(BuildContext context) async {
    // return Navigator.of(context).pushNamed(notificationIndexPage);
    // アニメーションなしで画面遷移させる。 参考： https://stackoverflow.com/questions/49874272/how-to-navigate-to-other-page-without-animation-flutter
    return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        // 画面遷移のログを送信するために、settings.nameを設定する。
        settings: const RouteSettings(name: notificationIndexPage),
        pageBuilder: (context, animation1, animation2) =>
            const NotificationIndexPage(),
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  _NotificationIndexPageState createState() => _NotificationIndexPageState();
}

class _NotificationIndexPageState extends ConsumerState<NotificationIndexPage> {
  User? _user;
  int _unreadNotificationsCount = 0;
  bool _initDone = false;

  @override
  void initState() {
    super.initState();
    _loadCount();
    PushNotification.initialize(context);
  }

  Future _loadCount() async {
    Map? resMap = await RemoteNotifications.index(context);
    if (resMap == null) {
      await UserSetup.logOut(null);
      return setState(() {
        _initDone = true;
      });
    }
    User user = User.fromJson(resMap['user']);
    await UserSetup.signIn(user);
    ref.read(currentUserProvider.notifier).state = user;
    ref.read(answerSettingProvider.notifier).state = user.answerSetting;

    // Convert map to list. ref: https://qiita.com/7_asupara/items/01c29c006556e89f5b17
    setState(() {
      _user = User.fromJson(resMap['user']);
      _unreadNotificationsCount = resMap['user']['unread_notifications_count'];
      _initDone = true;
    });
  }

  Future _moveToNotifications() async {
    // 外部リンクダイアログを表示
    await showDialog(
        context: context,
        builder: (context) {
          // ./locale/ を取り除いたpathを指定する
          return const ExternalLinkDialog(redirectPath: 'notifications');
        });
  }

  Widget _notificationsPageButton() {
    return InkWell(
      onTap: () {
        _moveToNotifications();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: const Color(0xff84bf53).withAlpha(100),
                  offset: const Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.green),
        child: Text(
          '$_unreadNotificationsCount件の通知を見る',
          style: const TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _notificationsOrEntrance(user) {
    if (_initDone == false) return const LoadingSpinner();

    if (_user == null) return const Entrance();

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(28.0),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 80,
          ),
          _notificationsPageButton(),
          const SizedBox(
            height: 80,
          ),
          const AppBanner(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('通知'),
        //automaticallyImplyLeading: false,
      ),
      body: _notificationsOrEntrance(_user),
      bottomNavigationBar: const BottomNavbar(),
      drawer: const DrawerMenu(),
    );
  }
}
