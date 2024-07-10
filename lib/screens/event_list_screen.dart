import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../providers/event_provider.dart';
import '../providers/auth_provider.dart';
import 'event_form_screen.dart';
import 'auth_screen.dart';

class EventListScreen extends StatefulWidget {
  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
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
                color: Color(0xFF363f93),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 35,
                    child: Container(
                      // height: 100,
                      width: 500,
                      child: Opacity(
                        opacity: 0.5,
                        child: Column(
                          children: [
                            Image(image: AssetImage('assets/images/city.png')),
                          ],
                        ),
                      ) 
                    ) 
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
                        color: Color(0xFF363f93),
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
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.logout),
        //     onPressed: () {
        //       Provider.of<AuthProvider>(context, listen: false).logout();
        //       Navigator.of(context).pushReplacement(
        //         MaterialPageRoute(builder: (ctx) => AuthScreen()),
        //       );
        //     },
        //   ),
        // ],
      ),
      body: FutureBuilder(
        future:
            Provider.of<EventProvider>(context, listen: false).fetchEvents(),
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
                    return Container(
                      height: 230,
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
                              width:
                                  MediaQuery.of(context).size.width - 225,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  
                                  Text(
                                      DateFormat('EEEE, dd MMM', 'id_ID').format(DateTime.parse(event.date)),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.location_pin, color: Color(0xff363f93), size: 20),
                                      Text(
                                        ' ' + event.location,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFF363f93),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time, color: Color(0xff363f93), size: 20),
                                      Text(
                                        ' ${event.timeStart ?? ''} - ${event.timeEnd ?? ''}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF363f93),
                                        ),
                                        overflow: TextOverflow.ellipsis,
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
                                    'http://192.168.100.65:8000/images/${event.image}',
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
                                    Color(0xff2d388a),
                                    Color(0XFF00aeef).withOpacity(0.5)
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
                    );
                  },
                );
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
