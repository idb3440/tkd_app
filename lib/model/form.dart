// ignore_for_file: file_names

class Forma {
  String id;
  String grade;
  String type;
  String namePoomsae;
  String urlVideo;

  Forma(this.id, this.grade, this.type, this.namePoomsae, this.urlVideo);

  Forma.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        grade = json['grade'],
        type = json['type'],
        namePoomsae = json['namePoomsae'],
        urlVideo = json['urlVideo'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'grade': grade,
        'type': type,
        'namePoomsae': namePoomsae,
        'urlVideo': urlVideo,
      };
}
