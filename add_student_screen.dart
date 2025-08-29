import 'package:flutter/material.dart';
import 'package:student_management/db_helper.dart';

class AddStudentScreen extends StatefulWidget {
  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void _saveStudent() async {
    final name = _nameController.text;
    final rollNumber = _rollNumberController.text;
    final address = _addressController.text;

    if (name.isNotEmpty && rollNumber.isNotEmpty && address.isNotEmpty) {
      final student = {
        'name': name,
        'roll_number': rollNumber,
        'address': address,
      };

      await DBHelper().insertStudent(student);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student added successfully!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Student Name'),
            ),
            TextField(
              controller: _rollNumberController,
              decoration: InputDecoration(labelText: 'Roll Number'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveStudent,
              child: Text('Save Student Data'),
            ),
          ],
        ),
      ),
    );
  }
}
