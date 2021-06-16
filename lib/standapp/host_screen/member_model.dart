class Member {
  String name;
  String avatar;
  String key;

  Member({name = "", avatar = "", key = ""})
      : this.name = name,
        this.avatar = avatar,
        this.key = key;

  factory Member.fromJson(Map<String, dynamic> json) {
    final String? name = json["nickName"] ?? "";
    final String? avatar = json["image"] ?? "";
    final String? key = json["key"] ?? "";

    return Member(name: name, avatar: avatar, key: key);
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
