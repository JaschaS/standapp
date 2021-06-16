class Member {
  String name;
  String avatar;
  String key;
  String? startDate;
  String? endDate;

  Member({name = "", avatar = "", key = "", String? start, String? end})
      : this.name = name,
        this.avatar = avatar,
        this.key = key,
        this.startDate = start,
        this.endDate = end;

  factory Member.fromJson(Map<String, dynamic> json) {
    final String? name = json["nickName"] ?? "";
    final String? avatar = json["image"] ?? "";
    final String? key = json["key"] ?? "";
    final String? end = json["end"];
    final String? start = json["start"];

    return Member(name: name, avatar: avatar, key: key, start: start, end: end);
  }

  bool isEmpty() {
    return name.isEmpty && avatar.isEmpty;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (!(other is Member)) return false;

    return this.key == other.key &&
        this.name == other.name &&
        this.avatar == other.avatar;
  }

  @override
  int get hashCode => name.hashCode ^ avatar.hashCode ^ key.hashCode;
}
