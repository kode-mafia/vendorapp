import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendorapp_mulitvendorapp/providers/auth_provider.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _confirmpasswordTextController = TextEditingController();
  var _addressTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              validator: (value){
                if (value.isEmpty) {
                  return 'Enter Shop Name';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.add_business),
                labelText: 'Business Name',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2, color: Theme.of(context).primaryColor,
                  ),
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              validator: (value){
                if (value.isEmpty) {
                  return 'Enter Mobile Number';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone_android),
                labelText: 'Mobile Number',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2, color: Theme.of(context).primaryColor,
                  ),
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              controller: _emailTextController,
              keyboardType: TextInputType.emailAddress,
              validator: (value){
                if (value.isEmpty) {
                  return 'Enter Email';
                }
                final bool _isValid=EmailValidator.validate(_emailTextController.text);
                if (!_isValid) {
                  return 'Invalid Email Format';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: 'Email ',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2, color: Theme.of(context).primaryColor,
                  ),
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              obscureText: true,
              validator: (value){
                if (value.isEmpty) {
                  return 'Enter Password';
                }
                if (value.length<6) {
                  return 'Minimum 6 characters';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key_outlined),

                labelText: 'Password',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2, color: Theme.of(context).primaryColor,
                  ),
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              obscureText: true,
              validator: (value){
                if (value.isEmpty) {
                  return 'Enter Confirm Password';
                }
                if (value.length<6) {
                  return 'Minimum 6 characters';
                }

                if(_passwordTextController.text!=_confirmpasswordTextController.text){
                  return 'Password don\'t match';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key_outlined),

                labelText: 'Confirm Password',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2, color: Theme.of(context).primaryColor,
                  ),
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              maxLines: 6,
              controller: _addressTextController,
              validator: (value){
                if (value.isEmpty) {
                  return 'Please press Navigator Button';
                }
                if(_authData.shopLatitude==null){
                  return 'Please press Navigator Button';
                }

                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.contact_mail_outlined),
                labelText: 'Business Location',
                suffixIcon: IconButton(
                  icon: Icon(Icons.location_searching),
                  onPressed: (){
                    _addressTextController.text = 'Locating....... \nPlease Wait .....';
                    _authData.getCurrentAddress().then((address){
                      if (address!= null) {
                        setState(() {
                          _addressTextController.text = '${_authData.placeName}\n${_authData.shopAddress}';
                        });
                      } else{
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Couldn\'t find location..... Please Try Again..'),),);
                      }
                    });
                  },
                ),
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2, color: Theme.of(context).primaryColor,
                  ),
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.comment),
                labelText: 'Shop Dialog',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2, color: Theme.of(context).primaryColor,
                  ),
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),


          SizedBox(height: 20,),
          Row(
            children: [
              Expanded(
                child: FlatButton(
                   color: Theme.of(context).primaryColor,
                    onPressed: (){
                     if (_authData.isPicAvail==true) { //first validate profile picture
              if (_formKey.currentState.validate()) {
            ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Processing Data '),),);
          }
         }else{
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Shop profile picture need to be uploaded'),),);
            }

        },
                    child: Text('Register',style: TextStyle(color: Colors.white),),
                 ),
          ),
            ],
          ),
        ],
      ),
    );
  }
}
