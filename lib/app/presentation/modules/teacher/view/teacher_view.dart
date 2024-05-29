import 'package:bookreserve/app/presentation/modules/teacher/utils/book_model.dart';
import 'package:bookreserve/app/presentation/modules/teacher/utils/loans_model.dart';
import 'package:bookreserve/app/presentation/modules/teacher/utils/reserver_model.dart';
import 'package:bookreserve/app/presentation/modules/teacher/view/widgets/book_loans.dart';
import 'package:bookreserve/app/presentation/modules/teacher/view/widgets/book_reserver.dart';
import 'package:bookreserve/app/presentation/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TeacherView extends StatefulWidget {
  const TeacherView({super.key});

  @override
  State<TeacherView> createState() => _TeacherViewState();
}

class _TeacherViewState extends State<TeacherView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: Text(
                'PROFESOR',
                style: TextStyle(fontSize: 24),
              )),
          SizedBox(
            height: 60,
            width: double.maxFinite,
            child: TabBar(
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              dividerColor: Colors.transparent,
              padding: const EdgeInsets.only(left: 0),
              labelColor: Colors.black,
              labelPadding: const EdgeInsets.only(left: 15, right: 15),
              indicatorColor: Colors.orange,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: Colors.grey,
              controller: tabController,
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                // Use the default focused overlay color
                return states.contains(WidgetState.focused)
                    ? null
                    : Colors.transparent;
              }),
              indicator: CircleTabIndicator(color: Colors.orange, radius: 4),
              tabs: const [
                Tab(text: 'Disponibles'),
                Tab(text: 'Reservados'),
                Tab(text: 'Prestados'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                BooksActives(size: size),
                BooksReserver(size: size),
                BooksLoans(size: size),
                // CreateBook(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    const CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, Routes.LOGIN);
    }
  }
}

class CreateBook extends StatelessWidget {
  const CreateBook({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            onCreate();
          },
          child: const Text('Crear'),
        ),
      ),
    );
  }
}

class BooksActives extends StatelessWidget {
  const BooksActives({
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
          return const Center(child: CircularProgressIndicator());
        }
        List<BookModel> data = snapshot.data!.docs
            .map((e) => BookModel.fromMap(e.data()))
            .toList();
        return StreamBuilder(
          stream: returReserve(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text('Ocurrio un error');
            }
            final dataReserve = snapshot.data;
            final bookFilter = data
                .where((book) => !dataReserve!.idBooks.contains(book.id))
                .toList();
            if (bookFilter.isEmpty) {
              return const Text('No hay libros por mostrar');
            }
            return StreamBuilder(
              stream: returLoans(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text('Ocurrio un error');
                }
                final dataLoans = snapshot.data;
                final bookFilterLoans = bookFilter
                    .where((book) => !dataLoans!.idLoans.contains(book.id))
                    .toList();
                if (bookFilter.isEmpty) {
                  return const Text('No hay libros por mostrar');
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
                  itemCount: bookFilterLoans.length,
                  itemBuilder: (context, index) {
                    final book = bookFilterLoans[index];

                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        Routes.DETAILS,
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
                              Hero(
                                tag: book.id,
                                child: ExtendedImage.network(
                                  book.urlImage,
                                  height: 250,
                                  width: double.maxFinite,
                                  fit: BoxFit.cover,
                                ),
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
              },
            );
          },
        );
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

Stream<LoansModel> returLoans() {
  final uuid = FirebaseAuth.instance.currentUser?.uid;
  return FirebaseFirestore.instance
      .collection('loans')
      .where('id-user', isEqualTo: uuid)
      .snapshots()
      .map(
        (querySnap) => querySnap.docs
            .map(
              (doc) => LoansModel.fromMap(doc.data()),
            )
            .first,
      );
}

onCreate() {
  const uuid = Uuid();
  final id = uuid.v4();
  CollectionReference ref = FirebaseFirestore.instance.collection('books');
  ref.doc(id).set({
    "title": "Beginning Flutter",
    "description":
        "Beginning Flutter: A Hands-On Guide to App Development is the essential resource for both experienced and novice developers interested in getting started with Flutter—the powerful new mobile software development kit. With Flutter, you can quickly and easily develop beautiful, powerful apps for both Android and iOS, without the need to learn multiple programming languages or juggle more than one code base. This book walks you through the process step by step.",
    "author": "Marco L. Napoli",
    "languaje": "ingles",
    "pages": 528,
    "id": id,
    "publication-date": "20-08-2019",
    "url-image":
        "https://media.wiley.com/product_data/coverImage300/23/11195508/1119550823.jpg",
  });
}

class CircleTabIndicator extends Decoration {
  final Color color;
  double radius;

  CircleTabIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final double radius;
  late Color color;
  _CirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    late Paint paint;
    paint = Paint()..color = color;
    paint = paint..isAntiAlias = true;
    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius);
    canvas.drawCircle(circleOffset, radius, paint);
  }
}
