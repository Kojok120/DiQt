import 'package:booqs_mobile/pages/chapter/show.dart';
import 'package:booqs_mobile/pages/dictionary/dictionary.dart';
import 'package:booqs_mobile/pages/drill/unsolved.dart';
import 'package:booqs_mobile/pages/home.dart';
import 'package:booqs_mobile/pages/notification/index.dart';
import 'package:booqs_mobile/pages/review/index.dart';
import 'package:booqs_mobile/pages/user/achievements.dart';
import 'package:booqs_mobile/pages/session/login.dart';
import 'package:booqs_mobile/pages/user/edit.dart';
import 'package:booqs_mobile/pages/user/mypage.dart';
import 'package:booqs_mobile/pages/user/premium_menu.dart';
import 'package:booqs_mobile/pages/user/premium_plan.dart';
import 'package:booqs_mobile/pages/session/sign_up.dart';
import 'package:booqs_mobile/pages/word/edit.dart';
import 'package:booqs_mobile/pages/word/new.dart';
import 'package:booqs_mobile/pages/word/show.dart';
import 'package:booqs_mobile/pages/word/search_results.dart';

const indexPage = '/';
const reviewIndexPage = '/review/index';
const notificationIndexPage = '/notification/index';

const signUpPage = '/session/sign_up';
const loginPage = '/session/login';
const dictionaryPage = '/dictionary/show';

const wordShowPage = '/word/show';
const wordNewPage = '/word/new';
const wordEditPage = '/word/edit';
const wordSearchResultsPage = '/word/search';

const chapterShowPage = '/chapter/show';

const userMyPage = '/user/mypage';
const userAchievementsPage = '/user/achievements';
const userEditPage = '/user/edit';
const premiumPlanPage = '/user/premium_plan';
const premiumMenuPage = '/user/premium_menu';

const drillUnsolvedPage = '/drill/unsolved';

final routes = {
  indexPage: (context) => const MyHomePage(),
  reviewIndexPage: (context) => const ReviewIndexPage(),
  notificationIndexPage: (context) => const NotificationIndexPage(),
  userMyPage: (context) => const UserMyPage(),
  signUpPage: (context) => const SignUpPage(),
  loginPage: (context) => const LoginPage(),
  dictionaryPage: (context) => const DictionaryPage(),
  wordShowPage: (context) => const WordShowPage(),
  wordNewPage: (context) => const WordNewPage(),
  wordEditPage: (context) => const WordEditPage(),
  wordSearchResultsPage: (context) => const WordSearchResultsPage(),
  chapterShowPage: (context) => const ChapterShowPage(),
  userAchievementsPage: (context) => const UserAchievementsPage(),
  userEditPage: (context) => const UserEditPage(),
  premiumPlanPage: (context) => const PremiumPlanPage(),
  premiumMenuPage: (context) => const PremiumMenuPage(),
  drillUnsolvedPage: (context) => const DrillUnsolvedPage(),
};
