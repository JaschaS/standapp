import 'dart:convert';

import 'package:http/http.dart';

import '../member_model.dart';

class HttpService {
  static Future<List<Member>> addMember(final Member member) async {
    final response = await post(
        Uri.parse('http://localhost:8082/standup/v1/member'),
        headers: {"content-type": "application/json"},
        body: jsonEncode({"nickName": member.name, "image": member.avatar}));

    return _evaluateMembers(response);
  }

  static Future<Member> getCurrentHost() async {
    final response =
        await get(Uri.parse('http://localhost:8082/standup/v1/current'));

    return _evaluateMember(response);
  }

  static Future<Member> getRecommendation() async {
    final response =
        await get(Uri.parse('http://localhost:8082/standup/v1/recommend'));

    return _evaluateMember(response);
  }

  static Future<List<Member>> getMembers() async {
    final response =
        await get(Uri.parse('http://localhost:8082/standup/v1/members'));

    return _evaluateMembers(response);
  }

  static Future<List<Member>> deleteMember(final String name) async {
    final response = await delete(
      Uri.parse('http://localhost:8082/standup/v1/member'),
      headers: {"content-type": "application/json"},
      body: jsonEncode({"nickName": name}),
    );

    return _evaluateMembers(response);
  }

  static void postHost(final Member member) async {
    final response = await post(
        Uri.parse('http://localhost:8082/standup/v1/host'),
        headers: {"content-type": "application/json"},
        body: jsonEncode({"nickName": member.name, "key": member.key}));

    if (response.statusCode != 200) {
      throw Exception('Failed to load current host');
    }
  }

  static Future<List<Member>> patchMember(
      final Member oldMember, final Member newMember) async {
    final bodyMap = {};
    if (oldMember.avatar != newMember.avatar)
      bodyMap.putIfAbsent("image", () => newMember.avatar);
    if (oldMember.name != newMember.name)
      bodyMap.putIfAbsent("nickName", () => newMember.name);

    final response = await patch(
      Uri.parse('http://localhost:8082/standup/v1/member/${oldMember.name}'),
      headers: {"content-type": "application/json"},
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
