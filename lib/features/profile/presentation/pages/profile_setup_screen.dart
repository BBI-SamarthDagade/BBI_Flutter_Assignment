import 'package:ecommerce/constants/constants.dart';
import 'package:ecommerce/features/profile/domain/entities/profile_model.dart';
import 'package:ecommerce/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:ecommerce/features/profile/presentation/bloc/profile_event.dart';
import 'package:ecommerce/features/profile/presentation/bloc/profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSetupScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _selectedImageUrl;
  final _formKey = GlobalKey<FormState>();

  // Sample profile image URLs
  // final List<String> _profileImages = [
  //   'https://i.pravatar.cc/150?img=1',
  //   'https://i.pravatar.cc/150?img=2',
  //   'https://i.pravatar.cc/150?img=3',
  //   'https://i.pravatar.cc/150?img=4',
  //   'https://i.pravatar.cc/150?img=5',
  //   'https://i.pravatar.cc/150?img=6',
  //   'https://i.pravatar.cc/150?img=7',
  //   'https://i.pravatar.cc/150?img=8',
  //   'https://i.pravatar.cc/150?img=9',
  //   'https://i.pravatar.cc/150?img=10',
  //   'https://i.pravatar.cc/150?img=11',
  //   'https://i.pravatar.cc/150?img=12',
  //   'https://i.pravatar.cc/150?img=13',
  //   'https://i.pravatar.cc/150?img=14',
  //   'https://i.pravatar.cc/150?img=15',
  // ];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _setInitialUsername();
  }

  Future<void> _setInitialUsername() async {
    final user = getCurrentUser();
    if (user != null) {
      final email = user.email ?? '';
      final usernameFromEmail = email.split('@').first;
      _nameController.text = usernameFromEmail; // Set default username
    }
  }

  Future<void> _loadProfileData() async {
    final user = getCurrentUser();
    if (user != null) {
      context.read<ProfileBloc>().add(GetProfileEvent(user.uid));
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final user = getCurrentUser();

      if (user != null) {
        final bloc = context.read<ProfileBloc>();
        bloc.add(
          SaveProfileEvent(
            ProfileModel(
              username: _nameController.text,
              phoneNumber: _mobileController.text,
              address: _addressController.text,
              imageUrl: _selectedImageUrl ??
                  Constant.profileImages[0], // Default image
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

  void _skipProfileSetup() async {
    final user = getCurrentUser();

    if (user != null) {
      final userId = user.uid;
      final profileBloc = context.read<ProfileBloc>();

      try {
        profileBloc.add(GetProfileEvent(userId));

        await Future.delayed(Duration(milliseconds: 500));

        final profileState = profileBloc.state;
        if (profileState is ProfileLoaded) {
          profileBloc.add(
            SaveProfileEvent(
              ProfileModel(
                username: profileState.profile.username,
                phoneNumber: profileState.profile.phoneNumber,
                address: profileState.profile.address,
                imageUrl:
                    profileState.profile.imageUrl ?? Constant.profileImages[0],
              ),
              userId,
            ),
          );
        } else {
          profileBloc.add(
            SaveProfileEvent(
              ProfileModel(
                username: _nameController.text.isNotEmpty
                    ? _nameController.text
                    : user.email?.split('@').first ?? '',
                phoneNumber: '',
                address: '',
                imageUrl: Constant.profileImages[0],
              ),
              userId,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error retrieving profile data: $e')),
        );
      }
    }

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.check_circle,
              color: Constant.colorOrg,
              size: 28,
            ),
            const SizedBox(width: 15),
            const Text(
              "Confirm Profile Setup",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            // Populate fields with loaded profile data
            _nameController.text = state.profile.username;
            _mobileController.text = state.profile.phoneNumber ?? '';
            _addressController.text = state.profile.address ?? '';
            _selectedImageUrl = state.profile.imageUrl;
          } else if (state is ProfileSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                    'Profile saved successfully!',
                    style: TextStyle(color: Colors.black),
                  ),
                  backgroundColor: Colors.green),
            );

            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("please update or skip profile can update it later")),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            print("inside profile loading");
            return Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _showImageSelectionDialog,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: _selectedImageUrl != null
                                  ? NetworkImage(_selectedImageUrl!)
                                  : null,
                              child: _selectedImageUrl == null
                                  ? Icon(Icons.camera_alt, size: 50)
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
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter your name'
                                : null,
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
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter your address'
                                : null,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _handleSubmit,
                            child: Text('Save'),
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
          }
        },
      ),
    );
  }

  //method to get current user from firebase
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  //method to show image selection dialog
  void _showImageSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Profile Image'),
        content: SingleChildScrollView(
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: Constant.profileImages.map((imageUrl) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedImageUrl = imageUrl;
                  });
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(imageUrl),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
