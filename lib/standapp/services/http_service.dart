import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';

import '../host_screen/member_model.dart';

class HttpService {
  static const String APP_ID = "lob80zu3ng";

  static Future<List<Member>> addMember(
      final User user, final Member member) async {
    final response = await post(
        Uri.parse(
            'https://$APP_ID.execute-api.eu-west-1.amazonaws.com/dev/member'),
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer ${await user.getIdToken()}"
        },
        body: jsonEncode({"nickName": member.name, "image": member.avatar}));

    return _evaluateMembers(response);
  }

  static Future<Member> getCurrentHost(final User user) async {
    final response = await get(
      Uri.parse(
          'https://$APP_ID.execute-api.eu-west-1.amazonaws.com/dev/host/current'),
      headers: {"Authorization": "Bearer ${await user.getIdToken()}"},
    );

    return _evaluateMember(response);
  }

  static Future<Member> getRecommendation(final User user) async {
    final response = await get(
        Uri.parse(
            'https://$APP_ID.execute-api.eu-west-1.amazonaws.com/dev/host/find'),
        headers: {"Authorization": "Bearer ${await user.getIdToken()}"});

    return _evaluateMember(response);
  }

  static Future<Member> getRecommendationWithoutMember(
      final User user, final Member member) async {
    final response = await get(
        Uri.parse(
            'https://$APP_ID.execute-api.eu-west-1.amazonaws.com/dev/host/find?memberId=${member.memberId}'),
        headers: {"Authorization": "Bearer ${await user.getIdToken()}"});

    return _evaluateMember(response);
  }

  static Future<List<Member>> getMembers(final User user) async {
    final response = await get(
        Uri.parse(
            'https://$APP_ID.execute-api.eu-west-1.amazonaws.com/dev/member'),
        headers: {"Authorization": "Bearer ${await user.getIdToken()}"});

    return _evaluateMembers(response);
  }

  static Future<List<Member>> deleteMember(
      final User user, final Member member) async {
    final response = await delete(
      Uri.parse(
          'https://$APP_ID.execute-api.eu-west-1.amazonaws.com/dev/member'),
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer ${await user.getIdToken()}"
      },
      body: jsonEncode({"memberId": member.memberId}),
    );

    return _evaluateMembers(response);
  }

  static Future<void> postHost(final User user, final Member member) async {
    final response = await post(
        Uri.parse(
            'https://$APP_ID.execute-api.eu-west-1.amazonaws.com/dev/host/save'),
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer ${await user.getIdToken()}"
        },
        body: jsonEncode({
          "nickName": member.name,
          "image": member.avatar,
          "end": member.endDate,
          "start": member.startDate,
          "memberId": member.memberId
        }));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to load current host');
    }
  }

  static Future<List<Member>> patchMember(
      final User user, final Member oldMember, final Member newMember) async {
    final bodyMap = {};
    if (oldMember.avatar != newMember.avatar)
      bodyMap.putIfAbsent("image", () => newMember.avatar);
    if (oldMember.name != newMember.name)
      bodyMap.putIfAbsent("nickName", () => newMember.name);

    final response = await patch(
      Uri.parse(
          'https://$APP_ID.execute-api.eu-west-1.amazonaws.com/dev/member/${oldMember.memberId}'),
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer ${await user.getIdToken()}"
      },
      body: jsonEncode(bodyMap),
    );

    return _evaluateMembers(response);
  }

  static List<Member> _evaluateMembers(final Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);

      return List<Member>.from(
        json["members"].map((model) => Member.fromJson(model)),
      );
    }

    throw Exception('Failed to load members');
  }

  static Member _evaluateMember(final Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);

      return Member.fromJson(json);
    }

    throw Exception('Failed to load current host');
  }
}
