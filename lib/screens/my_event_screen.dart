import 'package:event_app/providers/event_provider.dart';
import 'package:event_app/screens/event_detail_screen.dart';
import 'package:event_app/screens/event_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

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
                                              maxLines: 1,
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
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
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
