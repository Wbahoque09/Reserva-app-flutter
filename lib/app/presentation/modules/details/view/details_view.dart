import 'package:bookreserve/app/presentation/modules/teacher/utils/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class DetailsView extends StatefulWidget {
  const DetailsView({super.key});

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  bool reserver = false;
  bool loans = false;
  bool isLoans = false;
  bool isReserver = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final book = ModalRoute.of(context)?.settings.arguments as BookModel;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Hero(
              tag: book.id,
              child: SizedBox(
                width: size.width,
                height: size.height * 0.4,
                child: ExtendedImage.network(
                  book.urlImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: (size.height * 0.4) + 10,
            left: 15,
            height: (size.height * 0.5) + 10,
            right: 15,
            child: Scrollbar(
              trackVisibility: true,
              thumbVisibility: true,
              interactive: true,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Descripción: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            book.description,
                            style: const TextStyle(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            'Autor: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(book.author.toString()),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            'Paginas: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(book.pages.toString()),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            'Fecha de publicación: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(book.publicationDate.toString()),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 15,
            right: 15,
            child: reserver || loans
                ? const SizedBox.shrink()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        height: 55,
                        minWidth: 180,
                        color: Colors.orange.shade500,
                        onPressed: () async {
                          await updateReserve(book.id);
                        },
                        child: Text(
                          isReserver ? 'Reservando...' : 'Reservar',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.orange.shade500, strokeAlign: 1.5),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        height: 50,
                        minWidth: 180,
                        onPressed: () async {
                          updateLoans(book.id);
                        },
                        child: Text(
                          isLoans ? 'prestando' : 'Prestar',
                          style: const TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }

  Future<void> updateReserve(String idBook) async {
    final uuid = FirebaseAuth.instance.currentUser?.uid;

    final docRef = FirebaseFirestore.instance.collection('reserver').doc(uuid);
    isReserver = true;
    setState(() {});
    Map<String, dynamic> data = {
      'id-books': FieldValue.arrayUnion([idBook]),
      'id-user': uuid
    };
    await docRef.set(data, SetOptions(merge: true)).then((_) {
      isReserver = false;
      reserver = true;
      setState(() {});
      messageSucces('Reservado de forma exitosa!');
    }).catchError((error) {
      messageError('Error al Reservar el libro.');
    });
  }

  Future<void> updateLoans(String idBook) async {
    final uuid = FirebaseAuth.instance.currentUser?.uid;

    final docRef = FirebaseFirestore.instance.collection('loans').doc(uuid);
    isLoans = true;
    setState(() {});
    Map<String, dynamic> data = {
      'id-loans': FieldValue.arrayUnion([idBook]),
      'id-user': uuid
    };
    await docRef.set(data, SetOptions(merge: true)).then((_) {
      isLoans = false;
      loans = true;
      setState(() {});
      messageSucces('Libro pedido en prestamo de forma exitosa!');
    }).catchError((error) {
      messageError('Error al prestar el libro.');
    });
  }

  void messageError(String message) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(message: message),
    );
  }

  void messageSucces(String message) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(message: message),
    );
  }
}
