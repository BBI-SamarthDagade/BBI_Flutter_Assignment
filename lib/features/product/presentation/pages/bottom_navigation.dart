import 'package:flutter/material.dart';
import 'package:ecommerce/features/product/presentation/pages/cart_screen.dart';
import 'package:ecommerce/features/product/presentation/pages/home_page.dart';
import 'package:ecommerce/features/product/presentation/pages/profile_page.dart';
import 'package:ecommerce/features/product/presentation/pages/wishlist_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: 'Roboto',
    ),
    home: BottomNavigation(),
  ));
}

class BottomNavigation extends StatefulWidget {
   
  final int selectedIndex;

   BottomNavigation({this.selectedIndex = 0});
  
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<BottomNavigation> {
  int _currentIndex = 0; // Tracks the selected tab

  final List<Widget> _screens = [
    HomePage(),
    WishlistScreen(),
    CartScreen(),
    UserProfileScreen(),
  ];
   @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Clean white background
            boxShadow: [
              BoxShadow(
                color: Colors.black12, // Softer shadow
                blurRadius: 15.0,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.orange.withOpacity(0.8), // White background for a cleaner look
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 28),
                activeIcon: Icon(Icons.home, size: 30, color: Colors.white),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border, size: 28),
                activeIcon: Icon(Icons.favorite, size: 30, color: Colors.white),
                label: 'Wishlist',
              ),
               BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined, size: 28),
                activeIcon: Icon(Icons.shopping_cart, size: 30, color: Colors.white),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 28),
                activeIcon: Icon(Icons.person, size: 30, color: Colors.white),
                label: 'Profile',
              ),
            ],
            selectedItemColor: Colors.white, // Primary color for selected items
            unselectedItemColor: Colors.white, // Neutral color for unselected items
            selectedFontSize: 14,
            unselectedFontSize: 12,
            showUnselectedLabels: true,
          ),
        ),
      ),
    );
  }
}
