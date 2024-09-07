import 'dart:io';

import 'package:chat_app/core/extensions/extensions.dart';
import 'package:chat_app/core/presentation/widgets/user_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String _enteredEmail = '';
  String _enteredPassword = '';
  String _enteredUsername = '';

  File? _pickedImage;

  bool _isLogin = true;
  bool _isAuthenticating = false;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid || _pickedImage == null && !_isLogin) {
      return;
    }

    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();

    try {
      setState(() {
        _isAuthenticating = true;
      });

      if (_isLogin) {
        await _firebase.signInWithEmailAndPassword(email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredential = await _firebase.createUserWithEmailAndPassword(email: _enteredEmail, password: _enteredPassword);

        final storageRef = FirebaseStorage.instance.ref().child('user_images').child('${userCredential.user!.uid}.jpg');

        await storageRef.putFile(_pickedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'image_url': imageUrl,
        });

        if (!mounted) return;

        setState(() {
          _isAuthenticating = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        //
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message ?? 'Authentication failed.'),
      ));

      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  SizedBox get _buildCreateAccountButton {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          setState(() {
            _isLogin = !_isLogin;
          });
        },
        child: Text(_isLogin ? 'Create an account' : 'I already have an account'),
      ),
    );
  }

  SizedBox _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: context.theme.colorScheme.primaryContainer,
        ),
        onPressed: _submit,
        child: Text(_isLogin ? 'Login' : 'Sign Up'),
      ),
    );
  }

  TextFormField get _buildPasswordInput {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Password'),
      obscureText: true,
      validator: (value) {
        if (value == null || value.trim().length < 6) {
          return "Password must be at least 6 characters";
        }

        return null;
      },
      onSaved: (value) {
        _enteredPassword = value!;
      },
    );
  }

  TextFormField get _buildUsernameInput {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Username'),
      autocorrect: false,
      enableInteractiveSelection: false,
      textCapitalization: TextCapitalization.none,
      validator: (value) {
        if (value == null || value.isEmpty || value.trim().length < 4) {
          return "Please enter at least 4 characters";
        }

        return null;
      },
      onSaved: (value) {
        _enteredUsername = value!;
      },
    );
  }

  TextFormField get _buildEmailInput {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      validator: (value) {
        if (value == null || value.trim().isEmpty || !value.contains('@')) {
          return "Provide a valid email";
        }

        return null;
      },
      onSaved: (value) {
        _enteredEmail = value!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 63, 17, 177),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30, bottom: 20, left: 20, right: 20),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (!_isLogin) UserImagePicker(onPickImage: (image) => _pickedImage = image),
                          _buildEmailInput,
                          if (!_isLogin) _buildUsernameInput,
                          _buildPasswordInput,
                          const SizedBox(height: 12),
                          if (_isAuthenticating)
                            const CircularProgressIndicator()
                          else ...[
                            _buildLoginButton(context),
                            _buildCreateAccountButton,
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
