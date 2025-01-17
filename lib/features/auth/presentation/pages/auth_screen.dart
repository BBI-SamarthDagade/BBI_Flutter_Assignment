// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:ecommerce/features/auth/presentation/bloc/auth_event.dart';
// import 'package:ecommerce/features/auth/presentation/bloc/auth_state.dart';
// import 'package:ecommerce/features/auth/domain/entities/auth_entity.dart';
// import 'package:sign_in_button/sign_in_button.dart';

// class AuthScreen extends StatefulWidget {
//   @override
//   _AuthScreenState createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isSignUp = false;
//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;

//   void _toggleSignUp() {
//     setState(() {
//       _isSignUp = !_isSignUp;
//     });
//   }

//   void _handleSubmit(BuildContext context) {
//     if (_formKey.currentState?.validate() ?? false) {
//       final authEntity = AuthEntity(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       if (_isSignUp) {
//         BlocProvider.of<AuthBloc>(context)
//             .add(SignUpWithEmailEvent(authEntity));
//       } else {
//         BlocProvider.of<AuthBloc>(context)
//             .add(SignInWithEmailEvent(authEntity));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_isSignUp ? 'Create an Account' : 'Welcome Back'),
//       ),
//       body: BlocListener<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is AuthLoading) {
//             showDialog(
//               context: context,
//               barrierDismissible: false,
//               builder: (_) => Center(child: CircularProgressIndicator()),
//             );
//           } else if (state is AuthSuccess) {
//             Navigator.pop(context); // Close loading dialog
//             Navigator.pushReplacementNamed(context, '/home');
//           } else if (state is AuthFailure) {
//             Navigator.pop(context); // Close loading dialog
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//         },
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Branding
//                 Text(
//                   _isSignUp ? "Join Us!" : "Welcome Back!",
//                   style: theme.textTheme.headlineMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: theme.primaryColor,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),

//                 // SizedBox(height: 20),
//                 // Image.asset(
//                 //   'assets/images/logo.png', // Path to the asset
//                 //   width: 50, // Optional: Set width
//                 //   height: 250, // Optional: Set height
//                 //   fit: BoxFit.cover, // Optional: Adjust how the image is fitted
//                 // ),
//                 SizedBox(height: 60),

//                 // Input Fields
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     prefixIcon: Icon(Icons.email),
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value == null || !value.contains('@')) {
//                       return 'Enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16.0),
//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: !_isPasswordVisible,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     prefixIcon: Icon(Icons.lock),
//                     suffixIcon: IconButton(
//                       icon: Icon(_isPasswordVisible
//                           ? Icons.visibility
//                           : Icons.visibility_off),
//                       onPressed: () {
//                         setState(() {
//                           _isPasswordVisible = !_isPasswordVisible;
//                         });
//                       },
//                     ),
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.length < 6) {
//                       return 'Password must be at least 6 characters';
//                     }
//                     return null;
//                   },
//                 ),
//                 if (_isSignUp) SizedBox(height: 16.0),
//                 if (_isSignUp)
//                   TextFormField(
//                     controller: _confirmPasswordController,
//                     obscureText: !_isConfirmPasswordVisible,
//                     decoration: InputDecoration(
//                       labelText: 'Confirm Password',
//                       prefixIcon: Icon(Icons.lock_outline),
//                       suffixIcon: IconButton(
//                         icon: Icon(_isConfirmPasswordVisible
//                             ? Icons.visibility
//                             : Icons.visibility_off),
//                         onPressed: () {
//                           setState(() {
//                             _isConfirmPasswordVisible =
//                                 !_isConfirmPasswordVisible;
//                           });
//                         },
//                       ),
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please confirm your password';
//                       } else if (value != _passwordController.text) {
//                         return 'Passwords do not match';
//                       }
//                       return null;
//                     },
//                   ),
//                 SizedBox(height: 16.0),

//                 // Sign In/Sign Up Button
//                 ElevatedButton(
//                   onPressed: () => _handleSubmit(context),
//                   child: Text(
//                     _isSignUp ? 'Sign Up' : 'Sign In',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),

//                 // Switch Between Sign Up/Sign In
//                 TextButton(
//                   onPressed: _toggleSignUp,
//                   child: Text(
//                     _isSignUp
//                         ? 'Already have an account? Sign In'
//                         : 'Don’t have an account? Sign Up',
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 ),

//                 // Social Login Buttons
//                 SignInButton(
//                   Buttons.google,
//                   onPressed: () {
//                     BlocProvider.of<AuthBloc>(context)
//                         .add(ContinueWithGoogleEvent());
//                   },
//                   text: "Continue with Google",
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:ecommerce/features/auth/presentation/bloc/auth_event.dart';
// import 'package:ecommerce/features/auth/presentation/bloc/auth_state.dart';
// import 'package:ecommerce/features/auth/domain/entities/auth_entity.dart';
// import 'package:sign_in_button/sign_in_button.dart';

// class AuthScreen extends StatefulWidget {
//   @override
//   _AuthScreenState createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isSignUp = false;
//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;

//   void _toggleSignUp() {
//     setState(() {
//       _isSignUp = !_isSignUp;
//     });
//   }

//   void _handleSubmit(BuildContext context) {
//     if (_formKey.currentState?.validate() ?? false) {
//       final authEntity = AuthEntity(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       if (_isSignUp) {
//         BlocProvider.of<AuthBloc>(context)
//             .add(SignUpWithEmailEvent(authEntity));
//       } else {
//         BlocProvider.of<AuthBloc>(context)
//             .add(SignInWithEmailEvent(authEntity));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_isSignUp ? 'Create an Account' : 'Login'),
//         centerTitle: true,
//         //backgroundColor: Colors.grey.shade200,
//       ),
//       body: BlocListener<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is AuthLoading) {
//             showDialog(
//               context: context,
//               barrierDismissible: false,
//               builder: (_) => Center(child: CircularProgressIndicator()),
//             );
//           } else if (state is AuthSuccess) {
//             Navigator.pop(context); // Close loading dialog
//             if (_isSignUp) { 
//               // Navigate to profile setup only after successful sign-up
//               Navigator.pushReplacementNamed(context, '/profileSetup');
//             } 
//             else {
//                Navigator.pushReplacementNamed(context, '/home'); 
//             }
//           } 
//           else if (state is AuthFailure) {
//             Navigator.pop(context); // Close loading dialog
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//         },
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Branding
//               Text(
//                 _isSignUp ? "Join Us!" : "Welcome Back!",
//                 style: theme.textTheme.headlineSmall?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: theme.primaryColor,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 20),

//               // Input Fields
//               Card(
//                 elevation: 8.0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16.0),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         TextFormField(
//                           controller: _emailController,
//                           decoration: InputDecoration(
//                             labelText: 'Email',
//                             prefixIcon: Icon(Icons.email),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12.0),
//                               borderSide: BorderSide.none,
//                             ),
//                             filled: true,
//                             fillColor: Colors.grey.shade200,
//                           ),
//                           keyboardType: TextInputType.emailAddress,
//                           validator: (value) {
//                             if (value == null || !value.contains('@')) {
//                               return 'Enter a valid email';
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: 16.0),
//                         TextFormField(
//                           controller: _passwordController,
//                           obscureText: !_isPasswordVisible,
//                           decoration: InputDecoration(
//                             labelText: 'Password',
//                             prefixIcon: Icon(Icons.lock),
//                             suffixIcon: IconButton(
//                               icon: Icon(_isPasswordVisible
//                                   ? Icons.visibility
//                                   : Icons.visibility_off),
//                               onPressed: () {
//                                 setState(() {
//                                   _isPasswordVisible = !_isPasswordVisible;
//                                 });
//                               },
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12.0),
//                               borderSide: BorderSide.none,
//                             ),
//                             filled: true,
//                             fillColor: Colors.grey.shade200,
//                           ),
//                           validator: (value) {
//                             if (value == null || value.length < 6) {
//                               return 'Password must be at least 6 characters';
//                             }
//                             return null;
//                           },
//                         ),
//                         if (_isSignUp) SizedBox(height: 16.0),
//                         if (_isSignUp)
//                           TextFormField(
//                             controller: _confirmPasswordController,
//                             obscureText: !_isConfirmPasswordVisible,
//                             decoration: InputDecoration(
//                               labelText: 'Confirm Password',
//                               prefixIcon: Icon(Icons.lock_outline),
//                               suffixIcon: IconButton(
//                                 icon: Icon(_isConfirmPasswordVisible
//                                     ? Icons.visibility
//                                     : Icons.visibility_off),
//                                 onPressed: () {
//                                   setState(() {
//                                     _isConfirmPasswordVisible =
//                                         !_isConfirmPasswordVisible;
//                                   });
//                                 },
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12.0),
//                                 borderSide: BorderSide.none,
//                               ),
//                               filled: true,
//                               fillColor: Colors.grey.shade200,
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please confirm your password';
//                               } else if (value != _passwordController.text) {
//                                 return 'Passwords do not match';
//                               }
//                               return null;
//                             },
//                           ),
//                         SizedBox(height: 16.0),

//                         // Sign In/Sign Up Button
//                         ElevatedButton(
//                           onPressed: () => _handleSubmit(context),
//                           child: Text(
//                             _isSignUp ? 'Sign Up' : 'Sign In',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12.0),
//                             ),
//                             padding: EdgeInsets.symmetric(vertical: 16.0),
//                           ),
//                         ),

//                         // Switch Between Sign Up/Sign In
//                         TextButton(
//                           onPressed: _toggleSignUp,
//                           child: Text(
//                             _isSignUp
//                                 ? 'Already have an account? Sign In'
//                                 : 'Don’t have an account? Sign Up',
//                             style: TextStyle(color: Colors.black),
//                           ),
//                         ),
                         
//                          SizedBox(height: 10),
//                          Divider(color: Colors.grey.shade400, thickness: 1),
//                          SizedBox(height: 10),

//                         // Social Login Buttons
//                         SignInButton(
//                           Buttons.google,
//                           onPressed: () {
//                             BlocProvider.of<AuthBloc>(context)
//                                 .add(ContinueWithGoogleEvent());
//                           },
//                           text: "Continue with Google",
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12.0),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
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
        BlocProvider.of<AuthBloc>(context).add(SignUpWithEmailEvent(authEntity));
      } else {
        BlocProvider.of<AuthBloc>(context).add(SignInWithEmailEvent(authEntity));
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
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => Center(child: CircularProgressIndicator()),
            );
          } else if (state is AuthSuccess) {
            Navigator.pop(context);
            if (_isSignUp) {
              Navigator.pushReplacementNamed(context, '/profileSetup');
            } else {
              Navigator.pushReplacementNamed(context, '/home');
            }
          } else if (state is AuthFailure) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Branding Header
              Text(
                _isSignUp ? "Join Our Community!" : "Let's Sign You In!",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),

              // Form Card
              Card(
                elevation: 10.0,
                shadowColor: Colors.black.withOpacity(0.5),
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
  fillColor: const Color(0xFFF3F4F6), // A soft, neutral gray
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => value == null || !value.contains('@') ? 'Enter a valid email' : null,
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
                                _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              ),
                              onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                          validator: (value) => value == null || value.length < 6 ? 'Password must be at least 6 characters' : null,
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
                                  _isConfirmPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                ),
                                onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                            ),
                            validator: (value) => value != _passwordController.text ? 'Passwords do not match' : null,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),

              // Action Buttons
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
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 15.0),

              // Switch Mode Text
              TextButton(
                onPressed: _toggleSignUp,
                child: Text(
                  _isSignUp ? 'Already have an account? Sign In' : 'Don’t have an account? Sign Up',
                  style: TextStyle(color: Colors.black87, fontSize: 16.0),
                ),
              ),

              SizedBox(height: 20.0),

              // Divider with "OR"
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('OR', style: TextStyle(color: Colors.grey.shade600)),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              SizedBox(height: 20.0),

              // Social Login
              SignInButton(
                Buttons.google,
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(ContinueWithGoogleEvent());
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                text: "Continue with Google",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
