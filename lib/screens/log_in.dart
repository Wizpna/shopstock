import 'package:flutter/material.dart';
import 'package:shopstock/backshop/api_caller.dart';
import '../theme.dart';
import 'package:url_launcher/url_launcher.dart';


const FONT_SIZE = 20.0;
class LogIn extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LogIn> {

  bool _rememberMe = false; //state of remember me checkbox
  final _formKey = GlobalKey<FormState>(); //for validation/saving

  final TextEditingController _emailControl = TextEditingController();
  final TextEditingController _passwordControl = TextEditingController();

  //save values--set after button onPressed
  String _email, _password;

  //default textField style
  //here as to not mess with theme.dart
  final fieldStyle = TextStyle(
    color: AppColors.primary,
    fontSize: 16.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundDecoration(),
        height: double.infinity,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 120.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Sign In',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildTextFields(),
              //SizedBox(height: 20.0),
              _buildForgotPasswordButton(),
              _buildRememberMe(),
              _buildLogInButton(),
              _buildSignUpButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFields() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _buildEmail(),
            _buildPassword(),
          ],
        )
    );
  }

  Widget _buildEmail() {
    return Container(
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            labelText: "Email",
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor)
            ),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.accentDark)
            )
        ),
        style: fieldStyle,
        controller: _emailControl,
        validator: (value) {
          if (value.isEmpty)
            return "Field cannot be empty";
          return null;
        },
        onSaved: (value) {
          _email = value;
        },
      ),
    );
  }

  Widget _buildPassword() {
    return Container(
      child: TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            labelText: "Password",
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor)
            ),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.accentDark)
            )
        ),
        style: fieldStyle,
        obscureText: true,
        controller: _passwordControl,
        validator: (value) {
          if (value.isEmpty)
            return "Field cannot be empty";
          return null;
        },
        onSaved: (value) {
          _password = value;
        },
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: _launchPasswordResetUrl,
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  Widget _buildRememberMe() {
    return Container(
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: AppColors.primary),
            child: Checkbox(
              value: _rememberMe,
              checkColor: AppColors.accentDark,
              activeColor: AppColors.accent,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember Me',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogInButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
    if(_formKey.currentState.validate()) {
          _formKey.currentState.save();
          // TODO interface with the loading screen

          // Launching of the login method
          logIn(_email, _password, _rememberMe);

          //Navigator.pushReplacementNamed(context, "/map_explore");
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Theme.of(context).buttonColor,
        child: Text(
          'LOGIN',
          style: Theme.of(context).textTheme.button,
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/log_in/sign_up"),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an account? ',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14.0,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchPasswordResetUrl() async{
    const url = 'https://shopstock.live/reset_password/';
    if (await canLaunch(url)) {
      await launch(url);
    }else{
      throw 'Could not launch $url';
    }
  }
}