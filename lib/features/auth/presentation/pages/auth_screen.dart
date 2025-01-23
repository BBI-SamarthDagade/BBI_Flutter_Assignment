
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:ecommerce/features/auth/domain/entities/auth_entity.dart';
import 'package:sign_in_button/sign_in_button.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isSignUp = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _toggleSignUp() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final authEntity = AuthEntity(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (_isSignUp) {
        BlocProvider.of<AuthBloc>(context)
            .add(SignUpWithEmailEvent(authEntity));
      } else {
        BlocProvider.of<AuthBloc>(context)
            .add(SignInWithEmailEvent(authEntity));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isSignUp ? 'Create an Account' : 'Welcome Back',
          style: theme.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            print(_isSignUp);
            if (_isSignUp) {
              Navigator.pushReplacementNamed(context, '/profileSetup');
            } else {
              Navigator.pushReplacementNamed(context, '/profileSetup');
            }
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
// listener: (context, state) async {
//   if (state is AuthSuccess) {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user != null) {
//       // Dispatch GetProfileEvent
//       context.read<ProfileBloc>().add(GetProfileEvent(user.uid));

//       // Wait for the result of the profile fetching
//       final profileState =
//           await context.read<ProfileBloc>().stream.firstWhere(
//                 (state) =>
//                     state is ProfileLoaded || state is ProfileError,
//               );

//       if (profileState is ProfileLoaded) {
//         final profile = profileState.profile;

//         // Check if any field is empty
//         if (profile.username.isEmpty ||
//             profile.phoneNumber.isEmpty ||
//             profile.address.isEmpty ||
//             profile.imageUrl.isEmpty) {
//           // Navigate to profile setup page if any field is empty
//           Navigator.pushReplacementNamed(context, '/profileSetup');
//         } else {
//           // Navigate to home page if all fields are complete
//           Navigator.pushReplacementNamed(context, '/home');
//         }
//       } else {
//         // User profile does not exist, navigate to profile setup page
//         Navigator.pushReplacementNamed(context, '/profileSetup');
//       }
//     } else {
//       // Fallback case if user is not authenticated
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('User is not authenticated.')),
//       );
//     }
//   } else if (state is AuthFailure) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(state.message)),
//     );
//   }
// },

        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _isSignUp ? "Join Our Community!" : "Let's Sign You In!",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    Card(
                      elevation: 12.0,
                      shadowColor: Colors.black.withOpacity(0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF3F4F6),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  // Define a regex pattern for valid email addresses
                                  final emailRegex = RegExp(
                                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required';
                                  } else if (!emailRegex.hasMatch(value)) {
                                    return 'Enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 15.0),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                    onPressed: () => setState(() =>
                                        _isPasswordVisible =
                                            !_isPasswordVisible),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                ),
                                validator: (value) => value == null ||
                                        value.length < 6
                                    ? 'Password must be at least 6 characters'
                                    : null,
                              ),
                              if (_isSignUp) ...[
                                SizedBox(height: 15.0),
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: !_isConfirmPasswordVisible,
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                    prefixIcon: Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isConfirmPasswordVisible
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                      ),
                                      onPressed: () => setState(() =>
                                          _isConfirmPasswordVisible =
                                              !_isConfirmPasswordVisible),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                  ),
                                  validator: (value) =>
                                      value != _passwordController.text
                                          ? 'Passwords do not match'
                                          : null,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () => _handleSubmit(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: Text(
                        _isSignUp ? 'Sign Up' : 'Sign In',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
                    _isSignUp == false
                        ? TextButton(
                            onPressed: () {
                              final email = _emailController.text.trim();

                              if (email.isNotEmpty) {
                                BlocProvider.of<AuthBloc>(context)
                                    .add(PasswrodResetEvent(email));

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Password reset email sent!")),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Please enter a valid email address")),
                                );
                              }
                            },
                            child: Text("Reset Password"),
                          )
                        : SizedBox.shrink(),
                    SizedBox(height: 15.0),
                    TextButton(
                      onPressed: _toggleSignUp,
                      child: Text(
                        _isSignUp
                            ? 'Already have an account? Sign In'
                            : 'Don’t have an account? Sign Up',
                        style: TextStyle(color: Colors.black87, fontSize: 16.0),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('OR',
                              style: TextStyle(color: Colors.grey.shade600)),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    SignInButton(
                      Buttons.google,
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context)
                            .add(ContinueWithGoogleEvent());
                        // Navigator.pushReplacementNamed(
                        //     context, '/profileSetup');
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      text: "Continue with Google",
                    ),
                  ],
                ),
              ),
              if (state is AuthLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Loading Profile........"),
                      Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
