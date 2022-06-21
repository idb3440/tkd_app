// ignore_for_file: file_names

class Student {
  String id;
  String fullName;
  String grade;
  String emergencyPhone;
  String dateBirth;
  String dateEnrolment;
  bool isActive;
  String idUser;

  Student(this.id, this.fullName, this.grade, this.emergencyPhone,
      this.dateBirth, this.dateEnrolment, this.isActive, this.idUser);

  Student.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        fullName = json['fullName'],
        grade = json['grade'],
        emergencyPhone = json['emergencyPhone'],
        dateBirth = json['dateBirth'],
        dateEnrolment = json['dateEnrolment'],
        isActive = json['isActive'],
        idUser = json['idUser'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'grade': grade,
        'emergencyPhone': emergencyPhone,
        'dateBirth': dateBirth,
        'dateEnrolment': dateEnrolment,
        'isActive': isActive,
        'idUser': idUser,
      };
}
