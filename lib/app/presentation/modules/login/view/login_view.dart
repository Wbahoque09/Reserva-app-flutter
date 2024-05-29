import 'package:bookreserve/app/presentation/modules/login/view/widgets/list_view.dart';
import 'package:bookreserve/app/presentation/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: ShaderMask(
              blendMode: BlendMode.dstOut,
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.white,
                    Colors.white.withOpacity(0.8),
                    Colors.black.withOpacity(0.8),
                    Colors.black,
                  ],
                  stops: const [0, 0.7, 0.73, 0.95, 1],
                ).createShader(rect);
              },
              child: const Column(
                children: <Widget>[
                  SizedBox(height: 30),
                  ImageListView(
                    startIndex: 1,
                    duration: 25,
                  ),
                  SizedBox(height: 10),
                  ImageListView(
                    startIndex: 11,
                    duration: 45,
                  ),
                  SizedBox(height: 10),
                  ImageListView(
                    startIndex: 21,
                    duration: 65,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Iniciar sesión",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 38,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Correo electronico',
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Correo no puede estar vacio.";
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        return ("Porfavor ingrese un correo válido");
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      emailController.text = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    obscureText: _isObscure3,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          icon: Icon(_isObscure3
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure3 = !_isObscure3;
                            });
                          }),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Contraseña',
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                        left: 14.0,
                        bottom: 8.0,
                        top: 15.0,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      RegExp regex = RegExp(r'^.{6,}$');
                      if (value!.isEmpty) {
                        return "La contraseña no puede estar vacia.";
                      }
                      if (!regex.hasMatch(value)) {
                        return ("La contraseña debe tener el menos 6 caracteres.");
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      passwordController.text = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                    elevation: 1.0,
                    height: 55,
                    minWidth: size.width * 0.8,
                    onPressed: () {
                      signIn(
                        emailController.text,
                        passwordController.text,
                      );
                    },
                    color: visible
                        ? Colors.orange.withOpacity(0.6)
                        : Colors.orange,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (visible)
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        Text(
                          visible ? "Ingresando..." : "Ingresar",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "¿Aun no tienes cuenta?",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          Routes.REGISTER,
                        ),
                        child: const Text(
                          'Registrate',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Navigator.pushReplacementNamed(context, Routes.TEACHER);
        // if (documentSnapshot.get('rool') == "Profesor") {
        // } else {
        //   Navigator.pushReplacementNamed(context, Routes.STUDENT);
        // }
      } else {
        print('Documento no existe en firebase.');
      }
    });
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        visible = true;
      });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        route();
      } on FirebaseAuthException catch (e) {
        setState(() {
          visible = false;
        });

        if (e.code == 'user-not-found') {
          messageError('Correo electronico no encontrado.');
        }
        if (e.code == 'invalid-credential') {
          messageError('Credenciales invalidas');
        } else if (e.code == 'wrong-password') {
          messageError('La contraseña es incorrecta');
        }
      }
    }
  }

  void messageError(String message) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(message: message),
    );
  }
}
