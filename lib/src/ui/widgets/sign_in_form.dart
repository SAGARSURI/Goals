import '../../utils/strings.dart';
import 'package:flutter/material.dart';
import '../../blocs/login_bloc_provider.dart';
import '../goals_list.dart';

class SignInForm extends StatefulWidget {
  @override
  SignInFormState createState() {
    return SignInFormState();
  }
}

class SignInFormState extends State<SignInForm> {
  LoginBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = LoginBlocProvider.of(context);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        emailField(),
        Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
        passwordField(),
        Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
        submitButton()
      ],
    );
  }

  Widget passwordField() {
    return StreamBuilder(
        stream: _bloc.password,
        builder: (context, AsyncSnapshot<String> snapshot) {
          return TextField(
            onChanged: _bloc.changePassword,
            obscureText: true,
            decoration: InputDecoration(
                hintText: StringConstant.passwordHint,
                errorText: snapshot.error),
          );
        });
  }

  Widget emailField() {
    return StreamBuilder(
        stream: _bloc.email,
        builder: (context, snapshot) {
          return TextField(
            onChanged: _bloc.changeEmail,
            decoration: InputDecoration(
                hintText: StringConstant.emailHint, errorText: snapshot.error),
          );
        });
  }

  Widget submitButton() {
    return StreamBuilder(
        stream: _bloc.signInStatus,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return button();
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget button() {
    return RaisedButton(
        child: Text(StringConstant.submit),
        textColor: Colors.white,
        color: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () {
          if (_bloc.validateFields()) {
            authenticateUser();
          } else {
            showErrorMessage();
          }
        });
  }

  void authenticateUser() {
    _bloc.showProgressBar(true);
    _bloc.submit().then((value) {
      if (value == 0) {
        //New User
        _bloc.registerUser().then((value) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => GoalsList(_bloc.emailAddress)));
        });
      } else {
        //Already registered
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => GoalsList(_bloc.emailAddress)));
      }
    });
  }

  void showErrorMessage() {
    final snackbar = SnackBar(
        content: Text(StringConstant.errorMessage),
        duration: new Duration(seconds: 2));
    Scaffold.of(context).showSnackBar(snackbar);
  }
}
