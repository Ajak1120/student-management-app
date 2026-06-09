import 'package:flutter/material.dart';

import '../models/student.dart';
import '../services/student_service.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final regController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final courseController = TextEditingController();
  final yearController = TextEditingController();

  @override
  void dispose() {
    regController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    courseController.dispose();
    yearController.dispose();
    super.dispose();
  }

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final student = Student(
      regNo: regController.text.trim(),
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      course: courseController.text.trim(),
      year: yearController.text.trim(),
    );

    await StudentService().insertStudent(student);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Student added successfully')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: regController,
                decoration: const InputDecoration(labelText: 'Registration No'),
                validator: (value) => value?.isEmpty == true ? 'Enter registration number' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value?.isEmpty == true ? 'Enter name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value?.isEmpty == true ? 'Enter email' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) => value?.isEmpty == true ? 'Enter phone number' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: courseController,
                decoration: const InputDecoration(labelText: 'Course'),
                validator: (value) => value?.isEmpty == true ? 'Enter course' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: yearController,
                decoration: const InputDecoration(labelText: 'Year'),
                validator: (value) => value?.isEmpty == true ? 'Enter year' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveStudent,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
