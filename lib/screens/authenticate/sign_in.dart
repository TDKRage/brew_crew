import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0,
              title: Text('Sign in'),
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: Icon(Icons.person),
                    label: Text('Register'))
              ],
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        TextFormField(
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Email'),
                          validator: (val) =>
                              val.isEmpty ? 'Enter an email' : null,
                          onChanged: (val) {
                            setState(() {
                              this.email = val;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Password'),
                          validator: (val) => val.length < 6
                              ? 'Enter an password 6+ chars long'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() {
                              this.password = val;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        RaisedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result = await _auth
                                  .signInWithEmailPassword(email, password);
                              if (result == null) {
                                setState(() {
                                  error = 'Invalid Shit';
                                  loading = false;
                                });
                              }
                            }
                          },
                          color: Colors.pink[400],
                          child: Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          error,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 20),
                        RaisedButton.icon(
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              dynamic result = await _auth.signInWithGoogle();
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                });
                              }
                            },
                            icon: FaIcon(FontAwesomeIcons.googlePlus),
                            label: Text('Sign In With Google'))
                      ],
                    ))));
  }
}
