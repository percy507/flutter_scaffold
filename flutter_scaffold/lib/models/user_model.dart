class UserModel {
  UserModel({
    this.id,
    this.name,
    this.age,
    this.sex,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    name = json['name'] as String;
    age = int.parse(json['age'] as String);
    sex = json['sex'] as int;
  }

  int id;
  String name;
  int age;
  int sex;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['id'] = id;
    data['name'] = name;
    data['age'] = age;
    data['sex'] = sex;

    return data;
  }
}
