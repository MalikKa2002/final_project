import 'package:flutter/material.dart';
import 'package:smart_guide/Services/api_service.dart';
import 'package:smart_guide/Services/validators.dart';
import 'package:smart_guide/components/day_hours.dart';
import 'package:smart_guide/components/form_input_field.dart';

import '../components/upload_image.dart';

class FormScreen extends StatefulWidget {
  @override
  createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final TextEditingController _collegeNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Variable to store the selected image path
  String? _selectedImagePath;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save form data

      // Prepare data for API request
      Map<String, dynamic> formData = {
        "college_name": _collegeNameController.text,
        "email": _emailController.text,
        "location": _locationController.text,
        "phone": _phoneController.text,
        "website": _websiteController.text,
        "description": _descriptionController.text,
        "image": _selectedImagePath, // Include the image if selected
      };
      try {
        // Call the static method to add data and use the result
        await ApiService.addData(formData);
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('add succeses ')));
        }
        setState(() {});
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Failed to add data: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: Text('Add Building')),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "SUBMIT REQUEST",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Lorem ipsum is simply dummy text of the printing and typesetting industry.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 20),
                    FormInputField(
                      label: "College Name",
                      hintText: "Enter your college/university name",
                      controller: _collegeNameController,
                      validator: Validators.validateCollegeName,
                    ),
                    FormInputField(
                      label: "Email",
                      hintText: "Enter your Email",
                      controller: _emailController,
                      validator: Validators.validateEmail,
                    ),
                    FormInputField(
                      label: "Location",
                      hintText: "ex: Jerusalem, Israel",
                      controller: _locationController,
                      validator: Validators.validateLocation,
                    ),
                    FormInputField(
                      label: "Phone Number",
                      hintText: "+972 123456789",
                      controller: _phoneController,
                      validator: Validators.validatePhoneNumber,
                    ),
                    FormInputField(
                      label: "Website",
                      hintText: "ex: https://www.example.com",
                      controller: _websiteController,
                      validator: Validators.validateWebsite,
                    ),
                    SizedBox(height: 20),
                    FormInputField(
                      label: "Description",
                      hintText: "Enter your Description",
                      controller: _descriptionController,
                      maxLines: 5,
                      validator: Validators.validateDescription,
                    ),
                    SizedBox(height: 20),
                    Text("Opening Hours",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    DayHoursSelector(),
                    SizedBox(height: 20),
                    ImageUploadWidget(),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.green,
                      ),
                      onPressed: _submitForm,
                      child: Text(
                        "Save Building",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
