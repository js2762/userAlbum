import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_gradient/animate_gradient.dart';
import '../providers/auth.dart';
import '../models/http_exception.dart';

enum AuthMode { signUp, login }

class AuthScreen extends StatefulWidget {
  static const roteName = '/auth';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset:
            false, // to stop background image overlaping when keyboard displayed above scaffold
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: AnimateGradient(
            controller: _controller,
            primaryColors: const [
              Colors.purple,
              Colors.blue,
              Colors.orange,
              Colors.red,
            ],
            secondaryColors: const [
              Colors.deepPurple,
              Colors.green,
              Colors.deepOrange,
              Colors.pink,
            ],
            child: Stack(
              children: [
                /* Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                    colors: [
                      Colors.purple,
                      Color.fromARGB(255, 123, 56, 238),
                      Color.fromARGB(255, 5, 66, 172),
                    ],
                    transform: GradientRotation(pi / 7),
                  )),
                ), */
                SingleChildScrollView(
                  child: Container(
                    height: deviceSize.height,
                    width: deviceSize.width,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            AuthField(),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthField extends StatefulWidget {
  const AuthField({super.key});

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  AuthMode _authMode = AuthMode.login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  final _passwordController = TextEditingController();
  var _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        //content: Text('hello'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Okay'))
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        // login
        await Provider.of<Auth>(context, listen: false).login(
            _authData['email'] as String, _authData['password'] as String);
      } else {
        // sign up
        await Provider.of<Auth>(context, listen: false).signUp(
            _authData['email'] as String, _authData['password'] as String);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed.';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
        //print(errorMessage);
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is a valid email address.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      var errorMessage = 'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
      //print(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      //width: deviceSize.width,
      height: _authMode == AuthMode.signUp ? 410 : 310,
      width: deviceSize.width * 0.75,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Invalid Email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['email'] = value as String;
                },
                decoration: InputDecoration(
                    errorStyle: const TextStyle(color: Colors.white),
                    label: const Text(
                      'Email',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                    )),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty || value.length < 5) {
                    return 'Password is too short!';
                  }
                },
                onSaved: (value) {
                  _authData['password'] = value as String;
                },
                decoration: InputDecoration(
                    errorStyle: const TextStyle(color: Colors.white),
                    label: const Text(
                      'Password',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                    )),
              ),
              const SizedBox(
                height: 30,
              ),
              if (_authMode != AuthMode.login)
                TextFormField(
                  obscureText: true,
                  validator: _authMode == AuthMode.signUp
                      ? (value) {
                          if (value != _passwordController.text) {
                            return 'Password do not match!';
                          }
                        }
                      : null,
                  decoration: InputDecoration(
                      label: const Text(
                        'Confirm Password',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2),
                      )),
                ),
              const SizedBox(
                height: 30,
              ),
              if (_isLoading)
                const CircularProgressIndicator(
                  color: Colors.white,
                )
              else
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(300, 50),
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                  child: Text(
                      ' ${_authMode == AuthMode.login ? 'Login' : 'SignUp'}',
                      style: const TextStyle(color: Colors.black)),
                ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      '${_authMode == AuthMode.login ? "Don't Have Account?" : 'Already Have An Account!'}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  const SizedBox(
                    width: 3,
                  ),
                  TextButton(
                    onPressed: _switchAuthMode,
                    child: Text(
                        '${_authMode == AuthMode.login ? 'SignUp' : 'Login'}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
