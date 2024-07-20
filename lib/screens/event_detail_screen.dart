import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/event.dart'; // Make sure to import your Event model

class EventDetailScreen extends StatelessWidget {
  final Event event;

  EventDetailScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: 'http://54.253.6.75/images/${event.image}',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 300,
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor:
                  const Color.fromARGB(255, 116, 116, 116).withOpacity(0.2),
              elevation: 0,
              title: Text(
                'Events',
                style: TextStyle(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              iconTheme: IconThemeData(color: Colors.white),
            ),
          ),
          Positioned(
            top: 300,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 82, 3, 135),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0),
                child: Text(
                  DateFormat('EEEE, dd MMM yyyy', 'id_ID')
                      .format(DateTime.parse(event.date)),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 340.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Text(
                      event.name.toUpperCase(),
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: Color.fromARGB(255, 255, 81, 0)),
                        SizedBox(width: 8),
                        Text(
                          '${event.timeStart ?? ''} - ${event.timeEnd ?? ''}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 0),
                    child: Row(
                      children: [
                        Icon(Icons.location_pin, color: Color.fromARGB(255, 82, 3, 135), size: 20),
                        SizedBox(width: 8),
                        Text(
                          event.location.toUpperCase(),
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 82, 3, 135),
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Container(
                          height: 50,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 82, 3, 135),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                          ),
                          padding: EdgeInsets.only(left: 16),
                          child: Row(
                            children: [
                              Text(
                                'Map',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.location_searching,
                                  size: 18, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(
                    indent: 16,
                    endIndent: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Text(
                          (event.description ?? 'No description available.'),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
