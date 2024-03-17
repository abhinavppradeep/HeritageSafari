import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MonumentForm extends StatefulWidget {
  @override
  _MonumentFormState createState() => _MonumentFormState();
}

class _MonumentFormState extends State<MonumentForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _aboutController = TextEditingController();
  final _coordinateController = TextEditingController();

  Future<void> _uploadData() async {
    final url = Uri.parse('http://172.16.33.173:3000/api/monuments');

    try {
      final response = await http.post(
        url,
        body: {
          'name': _nameController.text,
          'location': _locationController.text,
          'about_monument': _aboutController.text,
          'location_coordinate': _coordinateController.text,
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        // Upload successful
        print(
            'Monument added successfully with ID: ${responseData['insertedId']}');
      } else {
        // Upload failed
        print('Failed to add monument: ${responseData['error']}');
      }
    } catch (error) {
      print('Error uploading monument: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Monument'),
        backgroundColor: Colors.grey[800], // Adjust app bar color
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _aboutController,
                decoration: InputDecoration(labelText: 'About Monument'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter details about the monument';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _coordinateController,
                decoration: InputDecoration(labelText: 'Location Coordinate'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location coordinates';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _uploadData();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[800], // Adjust button color
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Upload Monument',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Uploading the Monument will not result in direct changes in the app. Your data will be be published after admin authentication. Thank you for being our local guide.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey[600], // Adjust text color
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
