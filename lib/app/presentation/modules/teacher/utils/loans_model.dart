import 'dart:convert';

class LoansModel {
  final List<String> idLoans;
  final String idUser;

  LoansModel({
    required this.idLoans,
    required this.idUser,
  });

  LoansModel copyWith({
    List<String>? idLoans,
    String? idUser,
  }) =>
      LoansModel(
        idLoans: idLoans ?? this.idLoans,
        idUser: idUser ?? this.idUser,
      );

  factory LoansModel.fromJson(String str) =>
      LoansModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoansModel.fromMap(Map<String, dynamic> json) => LoansModel(
        idLoans: List<String>.from(json["id-loans"].map((x) => x)),
        idUser: json["id-user"],
      );

  Map<String, dynamic> toMap() => {
        "id-loans": List<dynamic>.from(idLoans.map((x) => x)),
        "id-user": idUser,
      };
}
