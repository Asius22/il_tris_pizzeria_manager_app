import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:il_tris_manager/components/circle_widget.dart';
import 'package:il_tris_manager/components/text_fields/password_field.dart';
import 'package:il_tris_manager/components/text_fields/email_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final _formkey = GlobalKey<FormState>();
  final _loginKey = GlobalKey<EmailFieldState>();
  final _passwordKey = GlobalKey<PasswordFieldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
              top: -80, right: -100, child: CircleWidget(radius: 120)),
          const Positioned(
              top: 600,
              left: -80,
              child: CircleWidget(
                radius: 120,
                secondary: false,
              )),
          const Positioned(
              top: 100,
              right: -150,
              child: CircleWidget(
                radius: 100,
                secondary: false,
              )),
          const Positioned(
              top: -70,
              left: -100,
              child: CircleWidget(
                radius: 135,
                secondary: false,
              )),
          const Positioned(
              top: 678, right: 120, child: CircleWidget(radius: 100)),
          const Positioned(
              left: -100, top: 348, child: CircleWidget(radius: 80)),
          SafeArea(
            child: Form(
              key: _formkey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EmailField(
                      key: _loginKey,
                    ),
                    PasswordField(key: _passwordKey),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FilledButton.tonalIcon(
                          icon: const Icon(Icons.send),
                          label: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "A C C E D I",
                            ),
                          ),
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              //esegui l'accesso
                              try {
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: _loginKey.currentState!.value,
                                        password:
                                            _passwordKey.currentState!.value)
                                    .then((value) => Navigator.of(context)
                                        .pushNamed("/home"));
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'wrong-password') {
                                  _showToast(context,
                                      'La password inserita è sbagliata');
                                } else if (e.code == 'user-not-found') {
                                  _showToast(context,
                                      'La mail inserita non è registrata');
                                }
                              } catch (e) {
                                _showToast(context, e.toString());
                              }
                            }
                          },
                        ),
                        FilledButton.tonal(
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                try {
                                  FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: _loginKey.currentState!.value,
                                          password:
                                              _passwordKey.currentState!.value)
                                      .then((value) => Navigator.pushNamed(
                                          context, "/home"));
                                } on FirebaseAuthException catch (e) {
                                  _showToast(context, e.code);
                                } catch (e) {
                                  _showToast(context, e.toString());
                                }
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text("R E G I S T R A T I"),
                            ))
                      ],
                    )
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> login(BuildContext context) async {}

  void _showToast(BuildContext context, String msg) => Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor:
            Theme.of(context).colorScheme.secondaryContainer.withAlpha(120),
      );
}
