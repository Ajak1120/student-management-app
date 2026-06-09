class Student {
  int? id;
  String regNo;
  String name;
  String email;
  String phone;
  String course;
  String year;

  Student({
    this.id,
    required this.regNo,
    required this.name,
    required this.email,
    required this.phone,
    required this.course,
    required this.year,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'regNo': regNo,
      'name': name,
      'email': email,
      'phone': phone,
      'course': course,
      'year': year,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      regNo: map['regNo'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      course: map['course'],
      year: map['year'],
    );
  }
}
