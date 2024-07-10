import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
// import 'package:path/path.dart' as path;

import '../providers/event_provider.dart';
import '../models/event.dart';

class EventFormScreen extends StatefulWidget {
  final Event? event;

  EventFormScreen({this.event});

  @override
  _EventFormScreenState createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late String _date;
  late String _location;
  late String? _image;
  late String? _timeStart;
  late String? _timeEnd;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _name = widget.event!.name;
      _description = widget.event!.description;
      _date = widget.event!.date;
      _location = widget.event!.location;
      _image = widget.event!.image;
      _timeStart = widget.event!.timeStart;
      _timeEnd = widget.event!.timeEnd;
    } else {
      _name = '';
      _description = '';
      _date = '';
      _location = '';
      _image = '';
      _timeStart = null;
      _timeEnd = null;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newEvent = Event(
        id: widget.event?.id ?? 0,
        name: _name,
        description: _description,
        date: _date,
        location: _location,
        image: _image,
        timeStart: _timeStart,
        timeEnd: _timeEnd,
      );

      if (widget.event == null) {
        await Provider.of<EventProvider>(context, listen: false).addEvent(newEvent, _imageFile);
      } else {
        await Provider.of<EventProvider>(context, listen: false).updateEvent(newEvent, _imageFile);
      }
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final formattedTime = picked.format(context);
        if (isStart) {
          _timeStart = formattedTime;
        } else {
          _timeEnd = formattedTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event == null ? 'Add Event' : 'Edit Event'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: _name,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide a name.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                TextFormField(
                  initialValue: _description,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide a description.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                TextFormField(
                  initialValue: _date,
                  decoration: InputDecoration(labelText: 'Date'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide a date.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _date = value!;
                  },
                ),
                TextFormField(
                  initialValue: _location,
                  decoration: InputDecoration(labelText: 'Location'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide a location.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _location = value!;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Start Time: ${_timeStart ?? 'Not selected'}'),
                    ElevatedButton(
                      onPressed: () => _selectTime(context, true),
                      child: Text('Select Start Time'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('End Time: ${_timeEnd ?? 'Not selected'}'),
                    ElevatedButton(
                      onPressed: () => _selectTime(context, false),
                      child: Text('Select End Time'),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                _imageFile == null
                    ? Text('No image selected.')
                    : Image.file(_imageFile!, height: 100),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pick Image'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
