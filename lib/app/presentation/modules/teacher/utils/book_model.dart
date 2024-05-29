import 'dart:convert';

class BookModel {
  final String id;
  final int pages;
  final String author;
  final String title;
  final String languaje;
  final String publicationDate;
  final String description;
  final String urlImage;

  BookModel({
    required this.id,
    required this.pages,
    required this.author,
    required this.title,
    required this.languaje,
    required this.publicationDate,
    required this.description,
    required this.urlImage,
  });

  BookModel copyWith({
    String? id,
    int? pages,
    String? author,
    String? title,
    String? languaje,
    String? publicationDate,
    String? description,
    String? urlImage,
  }) =>
      BookModel(
        id: id ?? this.id,
        pages: pages ?? this.pages,
        author: author ?? this.author,
        title: title ?? this.title,
        languaje: languaje ?? this.languaje,
        publicationDate: publicationDate ?? this.publicationDate,
        description: description ?? this.description,
        urlImage: urlImage ?? this.urlImage,
      );

  factory BookModel.fromJson(String str) => BookModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BookModel.fromMap(Map<String, dynamic> json) => BookModel(
        id: json["id"],
        pages: json["pages"],
        author: json["author"],
        title: json["title"],
        languaje: json["languaje"],
        publicationDate: json["publication-date"],
        description: json["description"],
        urlImage: json["url-image"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "pages": pages,
        "author": author,
        "title": title,
        "languaje": languaje,
        "publication-date": publicationDate,
        "description": description,
        "url-image": urlImage,
      };
}
