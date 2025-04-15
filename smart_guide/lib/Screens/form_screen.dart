import 'package:flutter/material.dart';
import 'package:smart_guide/Services/api_service.dart';
import 'package:smart_guide/Services/validators.dart';
import 'package:smart_guide/components/day_hours.dart';
import 'package:smart_guide/components/form_input_field.dart';

import '../components/upload_image.dart';

class FormScreen extends StatefulWidget {
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Controllers
  // Controllers for input fields
  final TextEditingController _collegeNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _submitForm();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Process submission
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Submitting form...')),
      // );
      _formKey.currentState!.save(); // Save form data
      // Prepare data for API request
      Map<String, dynamic> formData = {
        "college_name": _collegeNameController.text,
        "email": _emailController.text,
        "location": _locationController.text,
        "phone": _phoneController.text,
        "website": _websiteController.text,
        "description": _descriptionController.text,
        // Include the image if selected
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

  Widget _buildStepperHeader() {
    List<String> steps = [
      "Building Info",
      "open/closed houre ",
      "uplaod images"
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: steps.map((label) {
        int index = steps.indexOf(label);
        bool active = index == _currentStep;
        return Expanded(
          child: Column(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: active ? Colors.green : Colors.grey.shade300,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                  color: active ? Colors.green : Colors.grey,
                  fontSize: 12,
                ),
              )
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return Column(
          children: [
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
              maxLines: 7,
              validator: Validators.validateDescription,
            ),
          ],
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Opening Hours",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            DayHoursSelector(), // Your custom widget
          ],
        );

      case 2:
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Cover Image (max 1)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 10),
              ImageUploadWidget(maxImages: 1, isMultiple: false),
              SizedBox(height: 30),
              Text("Gallery Images (max 3)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 10),
              ImageUploadWidget(maxImages: 3, isMultiple: true),
              SizedBox(height: 30),
              Text("Building Album (max 50)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 10),
              ImageUploadWidget(maxImages: 50, isMultiple: true),
              SizedBox(height: 30),
            ],
          ),
        );

      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text("New Building "),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 500,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildStepperHeader(),
                  SizedBox(height: 20),
                  _buildStepContent(),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep > 0)
                        TextButton(
                          onPressed: _prevStep,
                          child: Text("Back"),
                        ),
                      ElevatedButton(
                        onPressed: _nextStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: Text(
                          _currentStep < 2 ? "Next" : "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
