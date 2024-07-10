import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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

  final TextEditingController _dateController = TextEditingController();

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
      _dateController.text = _date;
    } else {
      _name = '';
      _description = '';
      _date = '';
      _location = '';
      _image = '';
      _timeStart = null;
      _timeEnd = null;
      _dateController.text = '';
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
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
        final formattedTime = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        if (isStart) {
          _timeStart = formattedTime;
        } else {
          _timeEnd = formattedTime;
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date.isNotEmpty ? DateTime.parse(_date) : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _date = picked.toIso8601String().split('T').first;
        _dateController.text = _date;
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
                SizedBox(height: 10),
                TextFormField(
                  initialValue: _name,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
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
                SizedBox(height: 10),
                TextFormField(
                  initialValue: _description,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
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
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                      ),
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
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: _location,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
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
                SizedBox(height: 10),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Start Time',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: () => _selectTime(context, true),
                    ),
                  ),
                  controller: TextEditingController(
                    text: _timeStart ?? 'Not selected',
                  ),
                  validator: (value) {
                    if (_timeStart == null || _timeStart!.isEmpty) {
                      return 'Please select a start time.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'End Time',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: () => _selectTime(context, false),
                    ),
                  ),
                  controller: TextEditingController(
                    text: _timeEnd ?? 'Not selected',
                  ),
                  validator: (value) {
                    if (_timeEnd == null || _timeEnd!.isEmpty) {
                      return 'Please select an end time.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                _imageFile == null
                    ? Text('No image selected.')
                    : Image.file(_imageFile!, height: 100),
                SizedBox(height: 10),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Pick Image',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
