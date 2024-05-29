import 'dart:io';

import 'package:bookreserve/app/presentation/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  _RegisterViewState();

  bool showProgress = false;
  bool visible = false;

  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;
  File? file;
  var options = [
    'Estudiante',
    'Profesor',
  ];
  var _currentItemSelected = "Estudiante";
  var rool = "Estudiante";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    const Text(
                      "Registrate de forma sencilla",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
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
                        if (value!.isEmpty) {
                          return "Correo electronico es requerido.";
                        }
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return ("Introduzca un coreeo valido.");
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {},
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: _isObscure,
                      controller: passwordController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            }),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Contraseña',
                        enabled: true,
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 15.0),
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
                          return "La contraseña es obligatoria.";
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Ingrese minimo 6 caracteres.");
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: _isObscure2,
                      controller: confirmpassController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(_isObscure2
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isObscure2 = !_isObscure2;
                              });
                            }),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Confirmar contraseña',
                        enabled: true,
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 15.0),
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
                        if (value!.isEmpty) {
                          return "La confirmación de contraseña es obligatoria.";
                        }
                        if (confirmpassController.text !=
                            passwordController.text) {
                          return "Contraseña no coindicen.";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Seleccione un rol : ",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        DropdownButton<String>(
                          isDense: true,
                          isExpanded: false,
                          items: options.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(
                                dropDownStringItem,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValueSelected) {
                            setState(() {
                              _currentItemSelected = newValueSelected!;
                              rool = newValueSelected;
                            });
                          },
                          value: _currentItemSelected,
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "¿Ya tienes cuenta?",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            Routes.LOGIN,
                          ),
                          child: const Text(
                            'Inicia sesión',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 80),
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
                        signUp(emailController.text, passwordController.text,
                            rool);
                      },
                      color: visible
                          ? Colors.orange.withOpacity(0.6)
                          : Colors.orange,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: visible,
                            replacement: const SizedBox.shrink(),
                            child: const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            visible ? "registrando..." : "Registrar",
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signUp(String email, String password, String rool) async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        visible = true;
      });
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore(email, rool)})
          .catchError((e) {
        messageError('Ocrrio un error al resgitrarse, vuelva a intentarlo');
      });
    }
  }

  postDetailsToFirestore(String email, String rool) async {
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    CollectionReference refLoans =
        FirebaseFirestore.instance.collection('loans');
    CollectionReference refReserve =
        FirebaseFirestore.instance.collection('reserver');
    ref.doc(user!.uid).set({'email': emailController.text, 'rool': rool});
    await refLoans.doc(user.uid).set({'id-loans': [], 'id-user': user.uid});
    await refReserve.doc(user.uid).set({'id-books': [], 'id-user': user.uid});
    setState(() {
      showProgress = true;
      visible = false;
    });

    messageSucces('Registro realizado de forma exitosa');
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushReplacementNamed(context, Routes.LOGIN);
    }
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
