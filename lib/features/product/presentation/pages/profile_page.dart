//with default image
// import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:ecommerce/features/auth/presentation/bloc/auth_event.dart';
// import 'package:ecommerce/features/profile/presentation/pages/update_profile.dart';
// import 'package:ecommerce/features/profile/presentation/bloc/profile_bloc.dart';
// import 'package:ecommerce/features/profile/presentation/bloc/profile_event.dart';
// import 'package:ecommerce/features/profile/presentation/bloc/profile_state.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class UserProfileScreen extends StatefulWidget {
//   @override
//   State<UserProfileScreen> createState() => _UserProfileScreenState();
// }

// class _UserProfileScreenState extends State<UserProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       context.read<ProfileBloc>().add(GetProfileEvent(user.uid));
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: BlocBuilder<ProfileBloc, ProfileState>(
//           builder: (context, state) {
//             if (state is ProfileLoading) {
//               return Text('Loading...');
//             } else if (state is ProfileLoaded) {
//               return Text(
//                 state.profile.username,
//                 style: TextStyle(fontSize: 30),
//               );
//             } else if (state is ProfileError) {
//               return Text('Error');
//             } else {
//               return Text('Profile');
//             }
//           },
//         ),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.lightBlue, Colors.grey],
//               begin: Alignment.topRight,
//               end: Alignment.topLeft,
//             ),
//           ),
//         ),
//       ),
//       body: CustomScrollView(
//         slivers: [

//           // Sticky AppBar with Profile Header
//           SliverAppBar(
//             expandedHeight: 150, // Adjust height to provide more space
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               //  title: Text("${FirebaseAuth.instance.currentUser?.displayName ?? 'No Name'}"),
//               background: Stack(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Colors.lightBlue, Colors.grey],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Padding(
//                       padding:
//                           const EdgeInsets.only(bottom: 16.0), // Add spacing
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Stack(
//                             children: [
//                               CircleAvatar(
//                                 radius:
//                                     40, // Slightly larger for better visibility
//                                 backgroundImage: NetworkImage(
//                                   'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg', // Replace with user image
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 4,
//                                 right: 4,
//                                 child: CircleAvatar(
//                                   radius: 15,
//                                   backgroundColor: Colors.white,
//                                   child: IconButton(
//                                     icon: Icon(Icons.camera_alt,
//                                         size: 16, color: Colors.blue),
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 UpdateProfilePage()),
//                                       ).then((_) {
//                                         context
//                                             .read<ProfileBloc>()
//                                             .add(GetProfileEvent(user!.uid));
//                                       });
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                               height: 8), // Space between avatar and username
//                           Text(
//                             "${FirebaseAuth.instance.currentUser?.email ?? 'No email'}",
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Colors.grey.shade200,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Profile Options
//           SliverList(
//             delegate: SliverChildListDelegate(
//               [
//                 SizedBox(height: 16),
//                 _buildSectionTitle("Account Settings"),
//                 _buildAccountOption(
//                   icon: Icons.edit,
//                   label: "View Or Edit Profile",
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => UpdateProfilePage()),
//                     ).then((_) {
//                       context
//                           .read<ProfileBloc>()
//                           .add(GetProfileEvent(user!.uid));
//                     });
//                   },
//                 ),
//                 _buildAccountOption(
//                   icon: Icons.shopping_bag,
//                   label: "My Orders",
//                   onTap: () {
//                     // Navigate to orders page
//                   },
//                 ),
//                 _buildAccountOption(
//                   icon: Icons.favorite,
//                   label: "Wishlist",
//                   onTap: () {
//                     // Navigate to Wishlist
//                   },
//                 ),
//                 _buildAccountOption(
//                   icon: Icons.location_on,
//                   label: "Saved Addresses",
//                   onTap: () {
//                     // Navigate to Saved Addresses
//                   },
//                 ),
//                 _buildAccountOption(
//                   icon: Icons.payment,
//                   label: "Payment Methods",
//                   onTap: () {
//                     // Navigate to payment methods
//                   },
//                 ),
//                 _buildAccountOption(
//                   icon: Icons.settings,
//                   label: "Settings",
//                   onTap: () {
//                     // Navigate to Settings
//                   },
//                 ),
//                 SizedBox(height: 20),

//                 // Logout Button
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
//                       // Navigate to the AuthScreen
//                       Navigator.pushReplacementNamed(context, '/auth');
//                     },
//                     style: ElevatedButton.styleFrom(
//                       iconColor: Colors.red,
//                       padding: EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     child: Text(
//                       "Log Out",
//                       style: TextStyle(fontSize: 16, color: Colors.blueGrey),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper method to create section title
//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Text(
//         title,
//         style: TextStyle(
//             fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
//       ),
//     );
//   }

//   // Helper method for Account Options
//   Widget _buildAccountOption({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Container(
//         decoration: BoxDecoration(
//           color: Colors.blue.withOpacity(0.1),
//           shape: BoxShape.circle,
//         ),
//         padding: EdgeInsets.all(10),
//         child: Icon(icon, color: Colors.blue),
//       ),
//       title: Text(label),
//       trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//       onTap: onTap,
//     );
//   }
// }

import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce/features/product/presentation/pages/bottom_navigation.dart';
import 'package:ecommerce/features/profile/presentation/pages/update_profile.dart';
import 'package:ecommerce/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:ecommerce/features/profile/presentation/bloc/profile_event.dart';
import 'package:ecommerce/features/profile/presentation/bloc/profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<ProfileBloc>().add(GetProfileEvent(user.uid));
    }

    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Text('Loading...');
            } else if (state is ProfileLoaded) {
              return Text(
                state.profile.username,
                style: TextStyle(fontSize: 30),
              );
            } else if (state is ProfileError) {
              return Text('Error');
            } else {
              return Text('Profile');
            }
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFBBDEFB), // Muted blue
                Color(0xFFFFE0B2), // Soft orange
                Color(0xFFF5F5F5), // Off-white
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            return CustomScrollView(
              slivers: [
                // Sticky AppBar with Profile Header
                SliverAppBar(
                  expandedHeight: 150, // Adjust height to provide more space
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFBBDEFB), // Muted blue
                                Color(0xFFFFE0B2), // Soft orange
                                Color(0xFFF5F5F5),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 16.0), // Add spacing
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(
                                        state.profile.imageUrl ??
                                            'https://via.placeholder.com/150', // Default image
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 4,
                                      right: 4,
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.white,
                                        child: IconButton(
                                          icon: Icon(Icons.camera_alt,
                                              size: 16, color: Colors.blue),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateProfilePage()),
                                            ).then((_) {
                                              context.read<ProfileBloc>().add(
                                                  GetProfileEvent(user!.uid));
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height:
                                        8), // Space between avatar and username
                                Text(
                                  user?.email ?? 'No email',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Profile Options
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SizedBox(height: 16),
                      _buildSectionTitle("Account Settings"),
                      _buildAccountOption(
                        icon: Icons.edit,
                        label: "View Or Edit Profile",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateProfilePage()),
                          ).then((_) {
                            context
                                .read<ProfileBloc>()
                                .add(GetProfileEvent(user!.uid));
                          });
                        },
                      ),
                      _buildAccountOption(
                        icon: Icons.shopping_bag,
                        label: "My Orders",
                        onTap: () {
                          // Navigate to orders page
                        },
                      ),
                      _buildAccountOption(
                        icon: Icons.favorite,
                        label: "Wishlist",
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigation(selectedIndex: 1) ));
                        },
                      ),
                      _buildAccountOption(
                        icon: Icons.location_on,
                        label: "Saved Addresses",
                        onTap: () {
                          // Navigate to Saved Addresses
                        },
                      ),
                      _buildAccountOption(
                        icon: Icons.payment,
                        label: "Payment Methods",
                        onTap: () {
                          // Navigate to payment methods
                        },
                      ),
                      _buildAccountOption(
                        icon: Icons.settings,
                        label: "Settings",
                        onTap: () {
                          // Navigate to Settings
                        },
                      ),
                      SizedBox(height: 20),

                      // Logout Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<AuthBloc>(context)
                                .add(SignOutEvent());
                            // Navigate to the AuthScreen
                            Navigator.pushReplacementNamed(context, '/auth');
                          },
                          style: ElevatedButton.styleFrom(
                            iconColor: Colors.red,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Log Out",
                            style:
                                TextStyle(fontSize: 16, color: Colors.blueGrey),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text('No profile data available.'));
        },
      ),
    );
  }

  // Helper method to create section title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  // Helper method for Account Options
  Widget _buildAccountOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(10),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(label),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
