import 'package:bookreserve/app/presentation/modules/teacher/utils/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class DetailsloansView extends StatefulWidget {
  const DetailsloansView({super.key});

  @override
  State<DetailsloansView> createState() => _DetailsloansViewState();
}

class _DetailsloansViewState extends State<DetailsloansView> {
  bool loans = false;
  bool isloans = false;

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
            child: loans
                ? const SizedBox.shrink()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MaterialButton(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        height: 55,
                        minWidth: 250,
                        color: Colors.red.shade500,
                        onPressed: () async {
                          await updateReserve(book.id);
                        },
                        child: Text(
                          isloans ? 'Cancelando...' : 'Cancelar prestamos',
                          style: const TextStyle(color: Colors.white),
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

    final docRef = FirebaseFirestore.instance.collection('loans').doc(uuid);
    isloans = true;
    setState(() {});
    await docRef.update({
      'id-loans': FieldValue.arrayRemove([idBook])
    }).then((_) {
      isloans = false;
      loans = true;
      setState(() {});
      messageSucces('Prestamo cancelado de forma exitosa!');
    }).catchError((error) {
      messageError('Error al cancelar Prestamo del libro.');
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
