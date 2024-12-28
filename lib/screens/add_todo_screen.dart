import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/todo_model.dart';
import '../providers/todo_provider.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formattedDate = TextEditingController();
  final _imageDescription = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  Priority _selectedPriority = Priority.low;
  bool changeAdd = true;
  File? selectedImage;

  //? Show Date Picker
  void _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _formattedDate.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  //? Adding Image from Gallery
  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage != null) {
      setState(() {
        selectedImage = File(returnedImage.path);
        log("$selectedImage");
      });
    } else {
      log("No image selected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create New Task',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //? Title Input
                _buildSectionHeader('Task Title', Icons.title),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title'; // Error message if the field is empty
                    } else if (value.length > 80) {
                      return 'Title cannot be more than 50 characters'; // Error message if the title exceeds 50 characters
                    }
                    return null; // No error if the title is valid
                  },
                  decoration: _buildInputDecoration(
                    hintText: 'Enter task title',
                    prefixIcon: Icons.edit,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                        80), // Limit to 50 characters
                  ],
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                //? Description Input
                Container(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  changeAdd = true;
                                });
                              },
                              child: _buildSectionHeader(
                                  'Description', Icons.description)),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  changeAdd = false;
                                });
                              },
                              child: _buildSectionHeader(
                                  'Image', Icons.image))
                        ],
                      ),
                      const SizedBox(height: 12),
                      changeAdd
                          //? Text Field Note
                          ? TextFormField(
                              controller: _descriptionController,
                              maxLines: 5,
                              decoration: _buildInputDecoration(
                                hintText: 'Add task details (optional)',
                                prefixIcon: Icons.notes,
                              ),
                              style: Theme.of(context).textTheme.bodyLarge,
                            )
                          //? Image Note Picker
                          : Column(children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        _pickImageFromGallery();
                                      },
                                      child: const Center(
                                          child: Text(
                                        "Adding image!",
                                      )),
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.5,
                                      height: screenHeight * 0.06,
                                      child: 
                                      Container(
                                        child: TextFormField(
                                          textAlign: TextAlign.justify,
                                          controller: _imageDescription,
                                          maxLines: 1,
                                          decoration: _buildInputDecoration(
                                            hintText: 'Image title',
                                            prefixIcon: Icons.notes,
                                          ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              //TODO NEED TO SAVE IMAGE HERE!
                              Container(
                                // color: Colors.blue,
                                width: screenWidth * 0.85,
                                height: screenHeight * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: selectedImage != null
                                    ? Image.file(selectedImage!)
                                    : Container(
                                      margin: EdgeInsets.only(top: 10, left: 10),
                                      child: const Text("Please selected your image!")
                                    ),
                              ),
                            ])
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                //? Select Date
                _buildSectionHeader(
                    'Select your Date', Icons.date_range_outlined),
                const SizedBox(height: 12),
                TextField(
                  readOnly: true,
                  onTap: _showDatePicker,
                  decoration: _buildInputDecoration(
                    hintText: 'dd/mm/yyyy',
                    prefixIcon: Icons.notes,
                  ),
                  controller: _formattedDate,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),

                //? Priority Selector
                _buildSectionHeader('Priority', Icons.flag),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonFormField<Priority>(
                    value: _selectedPriority,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      prefixIcon: Icon(
                        Icons.priority_high,
                        color: _getPriorityColor(_selectedPriority),
                      ),
                    ),
                    items: Priority.values
                        .map((priority) => DropdownMenuItem(
                              value: priority,
                              child: Text(
                                priority
                                    .toString()
                                    .split('.')
                                    .last
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: _getPriorityColor(priority),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (priority) {
                      setState(() {
                        _selectedPriority = priority!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 32),

                //? Save Button
                ElevatedButton(
                  onPressed: _saveTodo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save, color: Colors.white),
                      const SizedBox(width: 12),
                      Text(
                        'Save Task',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //? Helper method to build section headers
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
        ),
      ],
    );
  }

  //? Helper method to create input decorations
  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintStyle: const TextStyle(
        backgroundColor: Colors.transparent
      ),

      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: Colors.deepPurple),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
      ),
    );
  }

  //? Helper method to get priority color
  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  //? Save field
  void _saveTodo() {
    if (_formKey.currentState!.validate()) {
      final newTodo = TodoModel(
        id: const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        setDateTime: _selectedDate,
        priority: _selectedPriority,
        imageDescription: _imageDescription.text,
      );

      Provider.of<TodoProvider>(context, listen: false).addTodo(newTodo);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _formattedDate.dispose();
    _imageDescription.dispose();
    super.dispose();
  }
}
