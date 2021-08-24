class Member {
  String name = "";
  String avatar = "";
  String userId = "";
  String memberId = "";
  String? startDate;
  String? endDate;

  Member({
    required name,
    required avatar,
    memberId,
    userId,
    String? start,
    String? end,
  })  : startDate = start,
        endDate = end;

  factory Member.fromJson(Map<String, dynamic> json) {
    final String? name = json["nickName"] ?? "";
    final String? avatar = json["image"] ?? "";
    final String? memberId = json["memberId"] ?? "";
    final String? userId = json["userId"] ?? "";
    final String? end = json["end"];
    final String? start = json["start"];

    return Member(
      name: name,
      avatar: avatar,
      start: start,
      end: end,
      memberId: memberId,
      userId: userId,
    );
  }

  bool isEmpty() {
    return name.isEmpty && avatar.isEmpty;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Member) return false;

    return memberId == other.memberId;
  }

  @override
  int get hashCode => memberId.hashCode ^ userId.hashCode;
}
