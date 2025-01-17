// import 'dart:io';
// import 'package:ecommerce/features/profile/domain/entities/profile_model.dart';
// import 'package:ecommerce/features/profile/presentation/bloc/profile_bloc.dart';
// import 'package:ecommerce/features/profile/presentation/bloc/profile_event.dart';
// import 'package:ecommerce/features/profile/presentation/bloc/profile_state.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';

// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   String? _profileImage;

//   @override
//   void initState() {
//     super.initState();
//     _setInitialUsername();
//   }

//   Future<void> _setInitialUsername() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final email = user.email ?? '';
//       final usernameFromEmail = email.split('@').first;
//       _nameController.text = usernameFromEmail; // Set default username
//     }
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: source);
//     setState(() {
//       _profileImage = pickedFile?.path;
//     });
//   }

//   void _handleSubmit() {
//     if (_formKey.currentState?.validate() ?? false) {
//       final user = FirebaseAuth.instance.currentUser; // Get the current user

//       if (user != null) {
//         // User is authenticated, proceed with saving the profile
//         final bloc = context.read<ProfileBloc>();
//         bloc.add(
//           SaveProfileEvent(
//             ProfileModel(
//               username: _nameController.text, // Use the edited username
//               phoneNumber: _mobileController.text,
//               address: _addressController.text,
//               imageUrl: _profileImage ?? '', // Handle case where _profileImage might be null
//             ),
//             user.uid, // Use the user's UID safely
//           ),
//         );
//       } else {
//         // Handle case when no user is logged in
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Please log in to save your profile.')),
//         );
//         Navigator.pushNamed(context, '/login'); // Redirect to login if necessary
//       }
//     }
//   }

//   void _skipProfileSetup() {
//     Navigator.pushReplacementNamed(context, '/home');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile Setup'),
//         centerTitle: true,
//         backgroundColor: Theme.of(context).primaryColor,
//       ),
//       body: BlocConsumer<ProfileBloc, ProfileState>(
//         listener: (context, state) {
//           if (state is ProfileSaved) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Profile saved successfully!')),
//             );
//             Navigator.pushReplacementNamed(context, '/home');
//           } else if (state is ProfileError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is ProfileLoading) {
//             print("inside profile loading state");
//             return Center(child: CircularProgressIndicator());
//           } else if (state is ProfileInitial || state is ProfileLoaded) {
//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           showModalBottomSheet(
//                             context: context,
//                             builder: (context) {
//                               return Container(
//                                 height: 150,
//                                 child: Column(
//                                   children: [
//                                     ListTile(
//                                       leading: Icon(Icons.camera),
//                                       title: Text('Camera'),
//                                       onTap: () {
//                                         _pickImage(ImageSource.camera);
//                                         Navigator.pop(context);
//                                       },
//                                     ),
//                                     ListTile(
//                                       leading: Icon(Icons.photo),
//                                       title: Text('Gallery'),
//                                       onTap: () {
//                                         _pickImage(ImageSource.gallery);
//                                         Navigator.pop(context);
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                         child: CircleAvatar(
//                           radius: 50,
//                           backgroundColor: Colors.grey.shade300,
//                           backgroundImage: _profileImage != null
//                               ? FileImage(File(_profileImage!))
//                               : null,
//                           child: _profileImage == null
//                               ? Icon(Icons.camera_alt, size: 50, color: Colors.white)
//                               : null,
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       TextFormField(
//                         controller: _nameController,
//                         decoration: InputDecoration(
//                           labelText: 'Name',
//                           prefixIcon: Icon(Icons.person),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12.0),
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey.shade200,
//                         ),
//                         validator: (value) =>
//                             value == null || value.isEmpty ? 'Please enter your name' : null,
//                       ),
//                       SizedBox(height: 16.0),
//                       TextFormField(
//                         controller: _mobileController,
//                         keyboardType: TextInputType.phone,
//                         decoration: InputDecoration(
//                           labelText: 'Mobile Number',
//                           prefixIcon: Icon(Icons.phone),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12.0),
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey.shade200,
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your mobile number';
//                           } else if (value.length < 10) {
//                             return 'Enter a valid mobile number';
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(height: 16.0),
//                       TextFormField(
//                         controller: _addressController,
//                         decoration: InputDecoration(
//                           labelText: 'Address',
//                           prefixIcon: Icon(Icons.home),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12.0),
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey.shade200,
//                         ),
//                         validator: (value) =>
//                             value == null || value.isEmpty ? 'Please enter your address' : null,
//                       ),
//                       SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: _handleSubmit,
//                         child: Text('Save Profile'),
//                         style: ElevatedButton.styleFrom(
//                           padding: EdgeInsets.symmetric(vertical: 16.0),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12.0),
//                           ),
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: _skipProfileSetup,
//                         child: Text(
//                           'Skip Profile Setup',
//                           style: TextStyle(color: Colors.red),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           } else {
//             return Center(child: Text('Unexpected state!'));
//           }
//         },
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:ecommerce/features/profile/domain/entities/profile_model.dart';
import 'package:ecommerce/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:ecommerce/features/profile/presentation/bloc/profile_event.dart';
import 'package:ecommerce/features/profile/presentation/bloc/profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _profileImage;

  @override
  void initState() {
    super.initState();
    _setInitialUsername();
  }

  Future<void> _setInitialUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final email = user.email ?? '';
      final usernameFromEmail = email.split('@').first;
      _nameController.text = usernameFromEmail; // Set default username
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      _profileImage = pickedFile?.path;
    });
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final bloc = context.read<ProfileBloc>();
        bloc.add(
          SaveProfileEvent(
            ProfileModel(
              username: _nameController.text,
              phoneNumber: _mobileController.text,
              address: _addressController.text,
              imageUrl: _profileImage ?? '',
            ),
            user.uid,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to save your profile.')),
        );
        Navigator.pushNamed(context, '/login');
      }
    }
  }

  void _skipProfileSetup() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Setup'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Profile saved successfully!')),
            );
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProfileInitial || state is ProfileLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Card(
                  elevation: 10.0,
                  shadowColor: Colors.black.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: 150,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.camera),
                                          title: Text('Camera'),
                                          onTap: () {
                                            _pickImage(ImageSource.camera);
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.photo),
                                          title: Text('Gallery'),
                                          onTap: () {
                                            _pickImage(ImageSource.gallery);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage: _profileImage != null
                                  ? FileImage(File(_profileImage!))
                                  : null,
                              child: _profileImage == null
                                  ? Icon(Icons.camera_alt, size: 50, color: Colors.white)
                                  : null,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? 'Please enter your name' : null,
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _mobileController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Mobile Number',
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your mobile number';
                              } else if (value.length < 10) {
                                return 'Enter a valid mobile number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: 'Address',
                              prefixIcon: Icon(Icons.home),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? 'Please enter your address' : null,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _handleSubmit,
                            child: Text('Save Profile'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                            ),
                          ),
                          TextButton(
                            onPressed: _skipProfileSetup,
                            child: Text(
                              'Skip Profile Setup',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Center(child: Text('Unexpected state!'));
          }
        },
      ),
    );
  }
}
