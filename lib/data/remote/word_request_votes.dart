import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:booqs_mobile/utils/diqt_url.dart';
import 'package:booqs_mobile/utils/error_handler.dart';
import 'package:booqs_mobile/utils/http_service.dart';
import 'package:http/http.dart';

class RemoteWordRequestVotes {
  static Future<Map> create(
      {required int wordRequestId, required bool upvoted}) async {
    try {
      final Map<String, dynamic> params = {
        'word_request_id': wordRequestId,
        'upvoted': upvoted,
      };
      final Map<String, dynamic> body = {'word_request_vote': params};
      final Uri url =
          Uri.parse('${DiQtURL.root()}/api/v1/mobile/word_request_votes');
      final Response res = await HttpService.post(url, body);
      if (ErrorHandler.isErrorResponse(res)) return ErrorHandler.errorMap(res);
      final Map resMap = json.decode(res.body);
      return resMap;
    } on TimeoutException catch (e, s) {
      return ErrorHandler.timeoutMap(e, s);
    } on SocketException catch (e, s) {
      return ErrorHandler.socketExceptionMap(e, s);
    } catch (e, s) {
      return ErrorHandler.exceptionMap(e, s);
    }
  }

  static Future<Map> destroy(int wordRequestVoteId) async {
    try {
      final Uri url = Uri.parse(
          '${DiQtURL.root()}/api/v1/mobile/word_request_votes/$wordRequestVoteId');
      final Response res = await HttpService.delete(url, null);
      if (ErrorHandler.isErrorResponse(res)) return ErrorHandler.errorMap(res);
      final Map resMap = json.decode(res.body);
      return resMap;
    } on TimeoutException catch (e, s) {
      return ErrorHandler.timeoutMap(e, s);
    } on SocketException catch (e, s) {
      return ErrorHandler.socketExceptionMap(e, s);
    } catch (e, s) {
      return ErrorHandler.exceptionMap(e, s);
    }
  }
}
