import 'dart:convert';

class ReserverModel {
  final List<String> idBooks;
  final String idUser;

  ReserverModel({
    required this.idBooks,
    required this.idUser,
  });

  ReserverModel copyWith({
    List<String>? idBooks,
    String? idUser,
  }) =>
      ReserverModel(
        idBooks: idBooks ?? this.idBooks,
        idUser: idUser ?? this.idUser,
      );

  factory ReserverModel.fromJson(String str) =>
      ReserverModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ReserverModel.fromMap(Map<String, dynamic> json) => ReserverModel(
        idBooks: List<String>.from(json["id-books"].map((x) => x)),
        idUser: json["id-user"],
      );

  Map<String, dynamic> toMap() => {
        "id-books": List<dynamic>.from(idBooks.map((x) => x)),
        "id-user": idUser,
      };
}
