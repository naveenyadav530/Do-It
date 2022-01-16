class Users {
  final String full_name;
  final String? email_address;
  final String password;
  final String? userId;



  Users({required this.userId,
    required this.full_name,
    required this.email_address,
    required this.password,});

  Users.fromJson(Map<String, Object?> json)
      : this(
    full_name: json['full_name']! as String,
    email_address: json['email_address']! as String,
    password: json['password']! as String,
    userId: json['userId']! as String,
  );


  Map<String, Object?> toJson() {
    return {
      "full_name":full_name,
      "email_address":email_address,
      "password":password,
      "userId":userId,
    };
  }
}