// ignore_for_file: file_names

class User {
  String id;
  String userName;
  String password;
  String fullName;

  User(this.id, this.userName, this.password, this.fullName);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userName = json['userName'],
        password = json['password'],
        fullName = json['fullName'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': userName,
        'password': password,
        'fullName': fullName,
      };
}
