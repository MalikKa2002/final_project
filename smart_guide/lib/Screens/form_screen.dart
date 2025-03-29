import 'package:flutter/material.dart';
import 'package:smart_guide/components/day_hours.dart';
import 'package:smart_guide/components/form_input_field.dart';
import 'package:smart_guide/components/upload_image.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form Submitted Successfully!')),
      );
    }
  }

// TODO add open closed hours and days

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Add Building'),
      ),
      body: Center(
        child: SingleChildScrollView(
          // padding: EdgeInsets.all(24.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
                // borderRadius: BorderRadius.circular(20),
                ),
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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
                      hintText: "Enter your college/univarsity name",
                      controller: TextEditingController(),
                    ),
                    FormInputField(
                      label: "Email",
                      hintText: "Enter your Email",
                      controller: TextEditingController(),
                    ),
                    FormInputField(
                      label: "location",
                      hintText: "ex: Jerusalem,Irsael",
                      controller: TextEditingController(),
                    ),
                    FormInputField(
                      label: "phone Number",
                      hintText: "+972 123456789",
                      controller: TextEditingController(),
                    ),
                    FormInputField(
                      label: "Website",
                      hintText: "ex: https://www.example.com",
                      controller: TextEditingController(),
                    ),
                    SizedBox(height: 20),
                    FormInputField(
                      label: "Description",
                      hintText: "Enter your Description",
                      controller: TextEditingController(),
                      maxLines: 5,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Opening Hours",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        // color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black),
                      ),
                      padding: EdgeInsets.all(15),
                      child: DayHoursSelector(),
                    ),
                    SizedBox(height: 20),
                    ImagePickerWidget(
                      onImageSelected: (image) {
                        print("Selected image path: ${image.path}");
                        // You can save this file or upload it to a server
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
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
