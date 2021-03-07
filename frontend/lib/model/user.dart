class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final bool isInstructor;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.isInstructor = false});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['pk'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      isInstructor: json['isInstructor'] == null ? false : json['isInstructor'],
    );
  }
}
