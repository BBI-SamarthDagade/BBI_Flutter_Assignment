import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('Your Profile'),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {

          if (constraints.maxWidth > 600) {
            // For larger screens, arrange widgets in a horizontal split view
            return Row(
              children: [
                // Profile Info Section
                Expanded(            
                  flex: 1,
                  child: GestureDetector(
                    onTap: toggleOpacity,

                    child: Column(   //wrap with gesture detector
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        profileImage(constraints.maxWidth),
                        const SizedBox(height: 16),
                        profileName(),
                        const SizedBox(height: 16),
                        socialMediaIcons(constraints.maxWidth),
                      ],
                    ),
                  ),
                ),
                
                Container(
                  height: 1000,
                  width: 2,
                  color: Colors.black,
                ),

               

                // Bio Section
                Expanded(  

                  flex: 2,
                  child: SingleChildScrollView(
                    child: AnimatedOpacity(
                      opacity: isVisible? 1.0 : 0.0,
                      duration: const Duration(seconds: 1),

                      child: Column(   //wrap with animatedOpacity
                        children: [
                          bioHeading(),
                          const SizedBox(height: 8),
                          profileBio(constraints.maxWidth),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            // For smaller screens, stack widgets vertically
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  profileImage(constraints.maxWidth),
                  const SizedBox(height: 16),
                  profileName(),
                  const SizedBox(height: 16),
                  socialMediaIcons(constraints.maxWidth),
                  const SizedBox(height: 20),
                  bioHeading(),
                  // const SizedBox(height: 8),
                  profileBio(constraints.maxWidth),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget profileImage(double screenWidth) {
    return CircleAvatar(
      radius: screenWidth < 600 ? 80 : 100,
      backgroundImage: const NetworkImage(
        'https://images.aiscribbles.com/d2b8779b49dc43d29d8a17dcbf35298a.png?v=101f25',
      ),
    );
  }

  Widget profileName() {
    return const Text(
      "Samarth Dagade",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
      ),
    );
  }

  Widget socialMediaIcons(double screenWidth) {
    final double iconSize = screenWidth < 600 ? 40 : 50;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(
          FontAwesomeIcons.github,
          size: iconSize,
          color: Colors.black,
        ),
        SizedBox(width: screenWidth < 600 ? 20 : 30),
        FaIcon(
          FontAwesomeIcons.twitter,
          size: iconSize,
          color: Colors.blue,
        ),
        SizedBox(width: screenWidth < 600 ? 20 : 30),
        FaIcon(
          FontAwesomeIcons.linkedin,
          size: iconSize,
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget bioHeading() {
    return const Text(
      "Bio",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget profileBio(double screenWidth) {
    return Container(
      
      // padding: const EdgeInsets.all(16.0),
       
      padding:  EdgeInsets.symmetric(vertical : 5, horizontal : (screenWidth) < 600 ? 16.0 : 60.00),

      child: const Text(
        "Hi, I'm Samarth Dagade, a passionate and motivated software developer, tech enthusiast, and eternal learner. A 2024 graduate in Engineering from SPPU University, I bring a strong academic foundation with a GPA of 9.00 and hands-on experience in coding and problem-solving. Currently working as a Jr. Software Developer at Börm Bruckmeier Infotech India Private Limited, I design and develop robust, scalable applications while exploring the exciting world of technology. My skill set includes proficiency in Java, SQL, DSA, and web development technologies, which I apply to deliver impactful solutions.",
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }

  void toggleOpacity(){
    setState(() {
       isVisible = !isVisible;
    });
  }
  
}
