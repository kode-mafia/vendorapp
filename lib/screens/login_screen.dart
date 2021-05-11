import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:vendorapp_mulitvendorapp/providers/auth_provider.dart';
import 'package:vendorapp_mulitvendorapp/screens/home_screen.dart';
import 'package:vendorapp_mulitvendorapp/screens/register_screen.dart';
import 'package:vendorapp_mulitvendorapp/widgets/reset_password_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _passwordController = TextEditingController();
  String email;
  String password;
  Icon icon;
  bool _visible = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    scaffoldMessage(message) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'LOGIN',
                            style: TextStyle(fontFamily: 'Anton', fontSize: 30),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Image.asset('images/shapeyou_logo.png', height: 80),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emailTextController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter an email address';
                          }
                          final bool _isValid =
                              EmailValidator.validate(_emailTextController.text);
                          if (!_isValid) {
                            return 'Enter a valid email address';
                          }
                          setState(() {
                            email = value;
                          });
                          return null;
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                          ),
                          focusColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Minimum 6 characters';
                          }
                          setState(() {
                            password = value;
                          });
                          return null;
                        },
                        obscureText: _visible == false ? false : true,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: _visible
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _visible = !_visible;
                              });
                            },
                          ),
                          enabledBorder: OutlineInputBorder(),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                          ),
                          focusColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                           SizedBox(width: 48.0,),
                              InkWell(
                                onTap: (){
                                  Navigator.pushNamed(context, ResetPassword.id);
                                },
                                child: Text(
                                  'Forgot Password ?', textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: Colors.blue, fontWeight: FontWeight.bold),
                                ),
                              ),

                            ],
                          ),

                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: FlatButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    _authData
                                        .loginVendor(email, password)
                                        .then((credential) {
                                      if (credential != null) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        Navigator.pushReplacementNamed(
                                            context, HomeScreen.id);
                                      } else {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        scaffoldMessage(_authData.error);
                                      }
                                    });
                                  }
                                },
                                color: Theme.of(context).primaryColor,
                                child: _isLoading
                                    ? LinearProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                        backgroundColor: Colors.transparent,
                                      )
                                    : Text(
                                        'Login',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                          ),
                        ],
                      ),

                      // ignore: deprecated_member_use
                      Row(
                        children: [
                          FlatButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.pushNamed(context, RegisterScreen.id);
                            },
                            child:RichText(
                              text: TextSpan(
                                text: '',
                                children: [
                                  TextSpan(text: 'Don\'t have an account ?', style: TextStyle(color: Colors.black),),
                                  TextSpan(text: ' Register', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
                                ]
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
