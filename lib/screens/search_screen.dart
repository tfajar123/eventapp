import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:event_app/providers/event_provider.dart';
import 'package:event_app/screens/event_detail_screen.dart';
import 'package:event_app/models/event.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import for CachedNetworkImage

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      Provider.of<EventProvider>(context, listen: false)
          .searchEvents(_searchController.text)
          .then((_) {
            setState(() {}); // Trigger a rebuild to show updated search results
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = Provider.of<EventProvider>(context).searchResults;

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Events'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: searchResults.isNotEmpty
                ? ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (ctx, i) {
                      final event = searchResults[i];
                      return ListTile(
                        contentPadding: EdgeInsets.all(8.0),
                        leading: CachedNetworkImage(
                          imageUrl: 'http://54.253.6.75/images/${event.image}',
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        title: Text(event.name, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Row(
                          children: [
                            Icon(Icons.location_pin, color: Colors.grey[600], size: 16.0),
                            Text(event.location, style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => EventDetailScreen(event: event),
                            ),
                          );
                        },
                      );
                    },
                  )
                : Center(child: Text('No events found')),
          ),
        ],
      ),
    );
  }
}
