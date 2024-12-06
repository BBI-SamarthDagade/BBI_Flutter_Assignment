import 'package:flutter/material.dart';
import 'package:login_form/pages/home_page.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

   String? _errorMSG;

  bool _hasLowercase = false;
  bool _hasUppercase = false;
  bool _hasDigit = false;
  bool _hasLength = false;

  bool validateEmail(String email) {
    final rGmail = RegExp(r"^[a-zA-Z0-9._%+-]+@gmail\.com$");
    return rGmail.hasMatch(email);
  }

  bool validateMobile(String mobile) {
    final rMobile = RegExp(r"^(?:\+91)?[0-9]{10}$");
    return rMobile.hasMatch(mobile);
  }

  bool validatePassword(String password) {
    setState(() {
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasDigit = password.contains(RegExp(r'[0-9]'));

     if(password.length >= 8)
          _hasLength = true;
      else
          _hasLength = false;
          
    });

    return _hasLowercase && _hasUppercase && _hasDigit && _hasLength;
  }

 
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _login() {
    String loginInput = _loginController.text.trim();
    String passwordInput = _passwordController.text.trim();

    bool isPasswordValid = validatePassword(passwordInput);
    bool isEmailValid = validateEmail(loginInput);
    bool isMobileValid = validateMobile(loginInput);

    if (!isEmailValid && !isMobileValid || !isPasswordValid) {
      setState(() {
        _showErrorDialog("Invalid login or password. Please try again.");
        return;
      });
    } else {
      setState(() {
        _errorMSG = null;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Container(
          color:Color.fromARGB(255, 216, 217, 221),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text(
                'Login to Your Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    child: TextField(
                      controller: _loginController,
                      decoration: InputDecoration(
                        labelText: 'Login ID',
                        hintText: 'Gmail / Mo.No.',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12)),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: TextField(
                        controller: _passwordController,
                        onChanged: (password) {
                          validatePassword(password);
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'password',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12)),
                          ),
                        ),
                        obscureText: true,
                      ),
                    ),
                  ),
                ],
              ),


              SizedBox(height: 10),

              Row(
                
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Icon(
                    _hasLowercase ? Icons.check : Icons.close,
                    color: _hasLowercase ? Colors.green : Colors.red,
                  ),
                  SizedBox(width: 5),
                  Text("[a-z]"),
                  SizedBox(width: 10),

                  Icon(
                    _hasUppercase ? Icons.check : Icons.close,
                    color: _hasUppercase ? Colors.green : Colors.red,
                  ),
                  SizedBox(width: 5),
                  Text("[A-Z]"),
                  SizedBox(width: 10),
                  
                  Icon(
                    _hasDigit ? Icons.check : Icons.close,
                    color: _hasDigit ? Colors.green : Colors.red,
                  ),
                  SizedBox(width: 5),
                  Text("0-9"),
                  SizedBox(width: 10),

                  Icon(
                    _hasLength ? Icons.check : Icons.close,
                    color: _hasLength ? Colors.green : Colors.red,
                  ),
                  SizedBox(width: 5),
                  Text("Length"),
                  
                ],
              ),

              SizedBox(height: 20),
              
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
