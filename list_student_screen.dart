import 'package:flutter/material.dart';
import 'package:student_management/db_helper.dart';

class ListStudentScreen extends StatefulWidget {
  @override
  _ListStudentScreenState createState() => _ListStudentScreenState();
}

class _ListStudentScreenState extends State<ListStudentScreen> {
  List<Map<String, dynamic>> _students = [];

  void _fetchStudents() async {
    final students = await DBHelper().getStudents();
    setState(() {
      _students = students;
    });
  }

  void _deleteStudent(int id) async {
    await DBHelper().deleteStudent(id);
    _fetchStudents();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Student deleted successfully!')),
    );
  }

  void _editStudent(Map<String, dynamic> student) async {
    final nameController = TextEditingController(text: student['name']);
    final rollNumberController = TextEditingController(text: student['roll_number']);
    final addressController = TextEditingController(text: student['address']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Student'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Student Name'),
              ),
              TextField(
                controller: rollNumberController,
                decoration: InputDecoration(labelText: 'Roll Number'),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final updatedStudent = {
                  'name': nameController.text,
                  'roll_number': rollNumberController.text,
                  'address': addressController.text,
                };

                await DBHelper().updateStudent(student['id'], updatedStudent);
                Navigator.pop(context);
                _fetchStudents();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Student updated successfully!')),
                );
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Student Record'),
      ),
      body: ListView.builder(
        itemCount: _students.length,
        itemBuilder: (context, index) {
          final student = _students[index];
          return ListTile(
            title: Text(student['name']),
            subtitle: Text('Roll Number: ${student['roll_number']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editStudent(student),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteStudent(student['id']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
