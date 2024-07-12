import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import '../models/event.dart';
import 'package:path/path.dart' as path;

class EventProvider with ChangeNotifier {
  List<Event> _events = [];
  String? _authToken;

  List<Event> get events {
    return [..._events];
  }

  void update(String? token) {
    _authToken = token;
    notifyListeners();
  }

  Future<void> fetchEvents(bool allEvent) async {
    final url = _authToken != null && allEvent == false
        ? Uri.parse('http://192.168.100.65:8000/api/events')
        : Uri.parse('http://192.168.100.65:8000/api/event');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $_authToken'},
    );

    final extractedData = json.decode(response.body) as List;
    _events = extractedData.map((eventData) => Event.fromJson(eventData)).toList();
    notifyListeners();
  }

  Future<void> addEvent(Event event, File? imageFile) async {
    final url = Uri.parse('http://192.168.100.65:8000/api/events');
    
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $_authToken';
    request.fields['name'] = event.name;
    request.fields['description'] = event.description;
    request.fields['date'] = event.date;
    request.fields['location'] = event.location;
    request.fields['time_start'] = event.timeStart ?? '';
    request.fields['time_end'] = event.timeEnd ?? '';

    if (imageFile != null) {
      var stream = http.ByteStream(imageFile.openRead());
      stream.cast();
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: path.basename(imageFile.path),
      );
      request.files.add(multipartFile);
    }

    final response = await request.send();
    if (response.statusCode == 201) {
      final responseData = await response.stream.bytesToString();
      _events.add(Event.fromJson(json.decode(responseData)));
      notifyListeners();
    } else {
      throw Exception('Failed to upload event');
    }
  }

  Future<void> updateEvent(Event event, File? imageFile) async {
    final url = Uri.parse('http://192.168.100.65:8000/api/events/${event.id}');
    
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $_authToken';
    request.fields['_method'] = 'PUT';
    request.fields['name'] = event.name;
    request.fields['description'] = event.description;
    request.fields['date'] = event.date;
    request.fields['location'] = event.location;
    request.fields['time_start'] = event.timeStart ?? '';
    request.fields['time_end'] = event.timeEnd ?? '';

    if (imageFile != null) {
      var stream = http.ByteStream(imageFile.openRead());
      stream.cast();
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: path.basename(imageFile.path),
      );
      request.files.add(multipartFile);
    }

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final updatedEvent = Event.fromJson(json.decode(responseData));
      final eventIndex = _events.indexWhere((e) => e.id == updatedEvent.id);
      _events[eventIndex] = updatedEvent;
      notifyListeners();
    } else {
      throw Exception('Failed to update event');
    }
  }

  Future<void> deleteEvent(int id) async {
    final url = Uri.parse('http://192.168.100.65:8000/api/events/$id');
    await http.delete(
      url,
      headers: {'Authorization': 'Bearer $_authToken'},
    );

    _events.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
