import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendorapp_mulitvendorapp/providers/auth_provider.dart';
import 'package:vendorapp_mulitvendorapp/screens/login_screen.dart';

class ResetPassword extends StatefulWidget {
  static const String id = 'reset-screen';

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  String email;
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('images/forgotpass.png', width: 300,),
                  SizedBox(height: 10,),

                  RichText(
                      text: TextSpan(
                        text: '',
                        children: [
                          TextSpan(text:'Forgot Password | ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),),
                          TextSpan(text:'Don\'t worry, Provide us your registered Email.We will send an email to reset your password',style: TextStyle(color: Colors.red),),
                        ]
                      )
                  ),

                  SizedBox(height: 10,),

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

                  FlatButton(
                    color: Theme.of(context).primaryColor,
                      onPressed: (){
                     if (_formKey.currentState.validate()) {
                       setState(() {
                         _isLoading= true;
                       });
                       _authData.resetPassword(email);
                       scaffoldMessage('Check you email for the link to reset your password');
                     }
                     Navigator.pushReplacementNamed(context, LoginScreen.id);
                      },
                      child: _isLoading?LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ):Text('Reset Password', style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                  ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
