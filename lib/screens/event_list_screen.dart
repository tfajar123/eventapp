import 'package:event_app/providers/auth_provider.dart';
import 'package:event_app/screens/event_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../providers/event_provider.dart';
import 'event_form_screen.dart';

class EventListScreen extends StatefulWidget {
  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  bool allEvent = true;
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 2) {
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
            label: 'MyEvent',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 82, 3, 135),
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
                Navigator.of(context).pop(); // pop the dialog
              },
            ),
          ],
        );
      },
    );
  }
}

// MyEventScreen class
class MyEventScreen extends StatelessWidget {
  final bool allEvent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Event',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 82, 3, 135),
      ),
      body: FutureBuilder(
        future: Provider.of<EventProvider>(context, listen: false)
            .fetchEvents(allEvent),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred!'));
          } else {
            return Consumer<EventProvider>(
              builder: (ctx, eventProvider, _) {
                if (eventProvider.events.isEmpty) {
                  return Center(child: Text('No events found.'));
                } else {
                  return ListView.builder(
                    itemCount: eventProvider.events.length,
                    itemBuilder: (ctx, i) {
                      final event = eventProvider.events[i];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => EventDetailScreen(event: event),
                            ),
                          );
                        },
                        child: Container(
                          height: 200,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Material(
                                  child: Container(
                                    height: 180,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(0.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 20,
                                          offset: Offset(-10, 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: 20,
                                child: Container(
                                  height: 180,
                                  width:
                                      MediaQuery.of(context).size.width - 250,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('EEEE, dd MMM', 'id_ID')
                                            .format(DateTime.parse(event.date)),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 82, 3, 135),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Divider(endIndent: 30),
                                      Row(
                                        children: [
                                          Icon(Icons.access_time,
                                              color: Color.fromARGB(
                                                  121, 55, 55, 55),
                                              size: 20),
                                          Expanded(
                                            child: Text(
                                              ' ${event.timeStart ?? ''} - ${event.timeEnd ?? ''}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 18),
                                      Row(
                                        children: [
                                          Icon(Icons.location_pin,
                                              color: Color.fromARGB(
                                                  121, 55, 55, 55),
                                              size: 20),
                                          Expanded(
                                            child: Text(
                                              ' ' +
                                                  event.location.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit,
                                                color: Color.fromARGB(
                                                    255, 82, 3, 135)),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      EventFormScreen(
                                                    event: event,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: Text('Confirm Delete'),
                                                  content: Text(
                                                      'Are you sure you want to delete this event?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.of(ctx)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('Delete'),
                                                      onPressed: () {
                                                        Provider.of<EventProvider>(
                                                                context,
                                                                listen: false)
                                                            .deleteEvent(
                                                                event.id);
                                                        Navigator.of(ctx).pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 220,
                                  height: 180,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'http://54.253.6.75/images/${event.image}',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 120,
                                right: 0,
                                child: Container(
                                  height: 40,
                                  width: 220,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 82, 3, 135),
                                        Color(0XFF00aeef).withOpacity(0.5),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 6.0),
                                    child: Text(
                                      event.name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => EventFormScreen(),
          ));
        },
      ),
    );
  }
}

// HomeScreen class
class HomeScreen extends StatelessWidget {
  final bool allEvent = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 230, // Adjust the height of the AppBar
        flexibleSpace: Column(
          children: [
            Container(
              width: MediaQuery.of(context)
                  .size
                  .width, // Set the width to the screen width
              height: 230,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                ),
                color: Color.fromARGB(255, 82, 3, 135),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 35,
                    child: Container(
                      width: 500,
                      child: Opacity(
                        opacity: 0.5,
                        child: Column(
                          children: [
                            Image(image: AssetImage('assets/images/city.png')),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 80,
                    left: 0,
                    child: Container(
                      height: 100,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 110,
                    left: 20,
                    child: Text(
                      'Event List',
                      style: TextStyle(
                        color: Color.fromARGB(255, 82, 3, 135),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: Provider.of<EventProvider>(context, listen: false)
            .fetchEvents(allEvent),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred!'));
          } else {
            return Consumer<EventProvider>(
              builder: (ctx, eventProvider, _) {
                return ListView.builder(
                  itemCount: eventProvider.events.length,
                  itemBuilder: (ctx, i) {
                    final event = eventProvider.events[i];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => EventDetailScreen(event: event),
                          ),
                        );
                      },
                      child: Container(
                        height: 200,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Material(
                                child: Container(
                                  height: 180,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(0.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 20,
                                        offset: Offset(-10, 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 20,
                              child: Container(
                                height: 150,
                                width: MediaQuery.of(context).size.width - 250,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateFormat('EEEE, dd MMM', 'id_ID')
                                          .format(DateTime.parse(event.date)),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 82, 3, 135),
                                      ),
                                      overflow: TextOverflow
                                          .ellipsis, // Add this line
                                      maxLines: 1, // Add this line
                                    ),
                                    Divider(endIndent: 30),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time,
                                            color:
                                                Color.fromARGB(121, 55, 55, 55),
                                            size: 20),
                                        Expanded(
                                          // Wrap the Text widget with Expanded
                                          child: Text(
                                            ' ${event.timeStart ?? ''} - ${event.timeEnd ?? ''}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(Icons.location_pin,
                                            color:
                                                Color.fromARGB(121, 55, 55, 55),
                                            size: 20),
                                        Expanded(
                                          // Wrap the Text widget with Expanded
                                          child: Text(
                                            ' ' + event.location.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 220,
                                height: 180,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'http://54.253.6.75/images/${event.image}',
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 120,
                              right: 0,
                              child: Container(
                                height: 40,
                                width: 220,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 82, 3, 135),
                                      Color(0XFF00aeef).withOpacity(0.5),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 125,
                              left: 180,
                              child: Text(
                                event.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Logout class
class LogoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Logout'),
          onPressed: () {
            _showLogoutConfirmationDialog(context);
          },
        ),
      ),
    );
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
