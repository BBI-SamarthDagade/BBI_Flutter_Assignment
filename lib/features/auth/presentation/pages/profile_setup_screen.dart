// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class ProfileSetupScreen extends StatefulWidget {
//   @override
//   _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
// }

// class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   String? _profileImage;

//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: source); // Use pickImage instead of getImage
//     setState(() {
//       _profileImage = pickedFile?.path;
//     });
//   }

//   void _handleSubmit() {
//     if (_formKey.currentState?.validate() ?? false) {
//       // Handle the submission logic here
//       // For example, send the data to the backend or save it locally
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Profile setup successful!')),
//       );
      
//      // Navigator.pop(context); // Close loading dialog
//       Navigator.pushReplacementNamed(context, '/home');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile Setup'),
//         centerTitle: true,
//         backgroundColor: Theme.of(context).primaryColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Profile Picture Input
//                 GestureDetector(
//                   onTap: () {
//                     showModalBottomSheet(
//                       context: context,
//                       builder: (context) {
//                         return Container(
//                           height: 150,
//                           child: Column(
//                             children: [
//                               ListTile(
//                                 leading: Icon(Icons.camera),
//                                 title: Text('Camera'),
//                                 onTap: () {
//                                   _pickImage(ImageSource.camera);
//                                   Navigator.pop(context);
//                                 },
//                               ),
//                               ListTile(
//                                 leading: Icon(Icons.photo),
//                                 title: Text('Gallery'),
//                                 onTap: () {
//                                   _pickImage(ImageSource.gallery);
//                                   Navigator.pop(context);
//                                 },
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   child: CircleAvatar(
//                     radius: 50,
//                     backgroundColor: Colors.grey.shade300,
//                     backgroundImage: _profileImage != null
//                         ? FileImage(File(_profileImage!))
//                         : null,
//                     child: _profileImage == null
//                         ? Icon(Icons.camera_alt, size: 50, color: Colors.white)
//                         : null,
//                   ),
//                 ),
//                 SizedBox(height: 20),

//                 // Name Input
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: InputDecoration(
//                     labelText: 'Name',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                     filled: true,
//                     fillColor: Colors.grey.shade200,
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your name';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16.0),

//                 // Mobile Number Input
//                 TextFormField(
//                   controller: _mobileController,
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(
//                     labelText: 'Mobile Number',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                     filled: true,
//                     fillColor: Colors.grey.shade200,
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your mobile number';
//                     } else if (value.length < 10) {
//                       return 'Enter a valid mobile number';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16.0),

//                 // Address Input
//                 TextFormField(
//                   controller: _addressController,
//                   decoration: InputDecoration(
//                     labelText: 'Address',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                     filled: true,
//                     fillColor: Colors.grey.shade200,
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your address';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),

//                 // Submit Button
//                 ElevatedButton(
//                   onPressed: _handleSubmit,
//                   child: Text('Save Profile'),
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(vertical: 16.0),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
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


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetupScreen extends StatefulWidget {
  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _profileImage;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source); // Use pickImage instead of getImage
    setState(() {
      _profileImage = pickedFile?.path;
    });
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle the submission logic here
      // For example, send the data to the backend or save it locally
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile setup successful!')),
      );
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _skipProfileSetup() {
    // Navigate to home without saving any data
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Setup'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Picture Input
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

                // Name Input
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person), // Icon for Name
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),

                // Mobile Number Input
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    prefixIcon: Icon(Icons.phone), // Icon for Mobile Number
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
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

                // Address Input
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.home), // Icon for Address
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: _handleSubmit,
                  child: Text('Save Profile'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                
                // Skip Profile Button
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
    );
  }
}
