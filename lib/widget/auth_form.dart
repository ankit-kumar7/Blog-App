import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';


class AuthForm extends StatefulWidget {

  AuthForm(this.userValue);

  final void Function(bool loginState,String email,String user,String pass) userValue;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  final _formKey = GlobalKey<FormState>();

  var _loginState = true;
  String _userEmail;
  String _userName;
  String _userPassword;

  void _formValidator()
  {
    FocusScope.of(context).unfocus();
    if(_formKey.currentState.validate())
    {
      _formKey.currentState.save();
      widget.userValue(
        _loginState,
        _userEmail,
        _userName,
        _userPassword,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _objectHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Form(
          key:_formKey,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: _objectHeight*0.02,horizontal: 40),
            child: Column(
              children: [
                TextFormField(
                  keyboardType:TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email",
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      )
                  ),
                  validator: (value)
                  {
                    if(value.isEmpty || !EmailValidator.validate(value))
                      return "Please enter valid email!";

                    return null;
                  },
                  onSaved: (value)
                  {
                    _userEmail = value;
                  },
                ),
                SizedBox(
                  height: _objectHeight*0.04,
                  //   width: MediaQuery.of(context).size.width,
                ),
                if(!_loginState)
                  TextFormField(
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        labelText: "Name",
                        hintText: "Create your username",
                        prefixIcon: Icon(Icons.account_circle),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        )
                    ),
                    validator: (value)
                    {
                      if(value.isEmpty)
                        return "Please enter a valid username!";

                      return null;
                    },
                    onSaved: (value)
                    {
                      _userName = value;
                    },
                  ),
                if(!_loginState)
                  SizedBox(
                    height: _objectHeight*0.04,
                  ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: _loginState ? "Create your password":"Enter your password",
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  validator: (value)
                  {
                    if(value.isEmpty || value.length<6)
                      return "Password must be should at least 6 characters";

                    return null;
                  },
                  onSaved: (value)
                  {
                    _userPassword = value;
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 130,
          height: 40,
          child: RaisedButton(
            child: Text(_loginState ? "LogIn" : "SignUp",
              style: TextStyle(
                fontSize: 25,
              ),),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            onPressed: _formValidator,
          ),
        ),
        FlatButton(
          child: Text(_loginState ? "Create an account ? " : "Already have an account ? ",
            style: TextStyle(
              color: Colors.pinkAccent,
            ),),
          onPressed: ()
          {
            FocusScope.of(context).unfocus();
            setState(() {
              _loginState = !_loginState;
              _formKey.currentState.reset();
            });
          },
        ),
      ],
    );
  }
}
