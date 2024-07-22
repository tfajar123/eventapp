import 'package:event_app/providers/auth_provider.dart';
import 'package:event_app/screens/home_screen.dart';
import 'package:event_app/screens/my_event_screen.dart';
import 'package:event_app/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventListScreen extends StatefulWidget {
  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  bool allEvent = true;
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 3) {
      _showLogoutConfirmationDialog(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getScreen(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'My Event',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade),
            label: 'Event List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 82, 3, 135),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return MyEventScreen();
      case 1:
        return HomeScreen();
      case 2:
        return SearchScreen();
      default:
        return HomeScreen();
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false)
                    .logout(context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
