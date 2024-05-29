import 'package:bookreserve/app/presentation/modules/teacher/utils/book_model.dart';
import 'package:bookreserve/app/presentation/modules/teacher/utils/reserver_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../routes/routes.dart';

class BooksReserver extends StatelessWidget {
  const BooksReserver({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("books").snapshots(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        List<BookModel> data = snapshot.data!.docs
            .map((e) => BookModel.fromMap(e.data()))
            .toList();
        return StreamBuilder(
            stream: returReserve(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/not-book.svg',
                      height: 250,
                    ),
                    const SizedBox(height: 20),
                    const Text('No hay libros por reservados'),
                  ],
                );
              }
              final dataReserve = snapshot.data;
              final bookFilter = data
                  .where((book) => dataReserve!.idBooks.contains(book.id))
                  .toList();

              if (bookFilter.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/not-book.svg',
                      height: 250,
                    ),
                    const SizedBox(height: 20),
                    const Text('No hay libros por reservados'),
                  ],
                );
              }
              return GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 15,
                  mainAxisExtent: 300,
                ),
                itemCount: bookFilter.length,
                itemBuilder: (context, index) {
                  final book = bookFilter[index];

                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.DETAILSRESERVE,
                      arguments: book,
                    ),
                    child: Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ExtendedImage.network(
                              book.urlImage,
                              height: 250,
                              width: double.maxFinite,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10)
                                      .copyWith(top: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    book.author,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            });
      },
    );
  }
}

Stream<ReserverModel> returReserve() {
  final uuid = FirebaseAuth.instance.currentUser?.uid;
  return FirebaseFirestore.instance
      .collection('reserver')
      .where('id-user', isEqualTo: uuid)
      .snapshots()
      .map(
        (querySnap) => querySnap.docs
            .map(
              (doc) => ReserverModel.fromMap(doc.data()),
            )
            .first,
      );
}
