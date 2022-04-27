import 'package:booqs_mobile/data/local/user_info.dart';
import 'package:booqs_mobile/data/provider/user.dart';
import 'package:booqs_mobile/data/remote/relationships.dart';
import 'package:booqs_mobile/models/relationship.dart';
import 'package:booqs_mobile/models/user.dart';
import 'package:booqs_mobile/pages/user/mypage.dart';
import 'package:booqs_mobile/widgets/button/small_green_button.dart';
import 'package:booqs_mobile/widgets/button/small_outline_gray_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RelationshipFollowButton extends ConsumerStatefulWidget {
  const RelationshipFollowButton(
      {Key? key, required this.user, required this.relationship})
      : super(key: key);
  final User user;
  final Relationship? relationship;

  @override
  _RelationshipFollowButton createState() => _RelationshipFollowButton();
}

class _RelationshipFollowButton
    extends ConsumerState<RelationshipFollowButton> {
  User? _user;
  User? _currentUser;
  Relationship? _relationship;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _user = widget.user;
          _currentUser = ref.watch(currentUserProvider);
          _relationship = widget.relationship;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null || _currentUser == null) return Container();

    // フォロー
    Future<void> _follow() async {
      // ログインしていないならマイページ（ログイン画面）に飛ばす
      final String? token = await LocalUserInfo.authToken();
      if (token == null) return UserMyPage.push(context);

      EasyLoading.show(status: 'loading...');
      final Map? resMap = await RemoteRelationships.create(_user!.publicUid);
      EasyLoading.dismiss();
      if (resMap == null) return;

      final Relationship relationship =
          Relationship.fromJson(resMap['relationship']);
      setState(() {
        _relationship = relationship;
      });
    }

    // フォロー解除
    Future<void> _remove() async {
      if (_relationship == null) return;
      EasyLoading.show(status: 'loading...');
      final Map? resMap = await RemoteRelationships.destroy(_relationship!);
      EasyLoading.dismiss();
      if (resMap == null) return;
      setState(() {
        _relationship = null;
      });
    }

    Widget _followButton() {
      final richText = RichText(
          text: const TextSpan(children: [
        WidgetSpan(
          child: Icon(
            Icons.person_add,
            color: Colors.black87,
            size: 18.0,
          ),
        ),
        TextSpan(
            text: ' フォローする',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold))
      ]));
      return InkWell(
        onTap: () {
          _follow();
        },
        child: SmallOutlineGrayButton(
          richText: richText,
        ),
      );
    }

    Widget _removeButton(relationship) {
      final richText = RichText(
          text: const TextSpan(children: [
        WidgetSpan(
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: 18.0,
          ),
        ),
        TextSpan(
            text: ' フォロー中',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))
      ]));
      return InkWell(
        onTap: () {
          _remove();
        },
        child: SmallGreenButton(
          richText: richText,
        ),
      );
    }

    Widget _button(relationship) {
      if (relationship == null) {
        return _followButton();
      } else {
        return _removeButton(relationship);
      }
    }

    return _button(_relationship);
  }
}
