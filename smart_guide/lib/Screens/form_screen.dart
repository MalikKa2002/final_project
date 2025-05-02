import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smart_guide/Services/validators.dart';
import 'package:smart_guide/components/day_hours.dart';
import 'package:smart_guide/components/form_input_field.dart';
import '../components/upload_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FormScreen extends StatefulWidget {
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Controllers for input fields.
  final TextEditingController _collegeNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Operating hours map for each day.
  Map<String, Map<String, String>> _operatingHours = {
    "Sunday": {"open": "", "close": ""},
    "Monday": {"open": "", "close": ""},
    "Tuesday": {"open": "", "close": ""},
    "Wednesday": {"open": "", "close": ""},
    "Thursday": {"open": "", "close": ""},
    "Friday": {"open": "", "close": ""},
    "Saturday": {"open": "", "close": ""},
  };

  // Use Uint8List to store images.
  Uint8List? _coverImage;
  List<Uint8List> _galleryImages = [];
  List<Uint8List> _albumImages = [];

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

  /// Submits the form: checks for duplicate campus,
  /// saves the data in Firestore and then uploads images.
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String collegeNameTrimmed = _collegeNameController.text.trim();

      // Check if a campus with the same college name already exists.
      QuerySnapshot existingCampusSnapshot = await FirebaseFirestore.instance
          .collection('campuses')
          .where('college_name', isEqualTo: collegeNameTrimmed)
          .get();
      if (existingCampusSnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Campus already exists!')),
        );
        return;
      }

      // Prepare initial campus data.
      Map<String, dynamic> formData = {
        "college_name": collegeNameTrimmed,
        "email": _emailController.text,
        "location": _locationController.text,
        "phone": _phoneController.text,
        "website": _websiteController.text,
        "description": _descriptionController.text,
        "operating_hours": _operatingHours,
        "cover_image": "",
        "gallery_images": [],
        "album_images": [],
      };

      try {
        // Create a new campus document.
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('campuses')
            .add(formData);
        String campusId = docRef.id;

        // Upload images and collect their URLs.
        String coverImageUrl = "";
        if (_coverImage != null) {
          coverImageUrl = await _uploadImage(_coverImage!, campusId, "cover");
        }

        List<String> galleryImageUrls = [];
        for (int i = 0; i < _galleryImages.length; i++) {
          String url =
              await _uploadImage(_galleryImages[i], campusId, "gallery_$i");
          galleryImageUrls.add(url);
        }

        List<String> albumImageUrls = [];
        for (int i = 0; i < _albumImages.length; i++) {
          String url =
              await _uploadImage(_albumImages[i], campusId, "album_$i");
          albumImageUrls.add(url);
        }

        // Update the campus document with image URLs.
        await docRef.update({
          "cover_image": coverImageUrl,
          "gallery_images": galleryImageUrls,
          "album_images": albumImageUrls,
        });

        // Navigate to the home screen after successful submission.
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Campus added successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add campus: $e')),
        );
      }
    }
  }

  /// Uploads an image (as Uint8List data) to Firebase Storage.
  Future<String> _uploadImage(
      Uint8List imageData, String campusId, String imageName) async {
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child("campus_images")
        .child(campusId)
        .child("$imageName.jpg");

    // Use putData to upload the image bytes.
    UploadTask uploadTask = storageRef.putData(imageData);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  /// Builds the multi-step content.
  Widget _buildStepContent() {
    final local = AppLocalizations.of(context)!;
    switch (_currentStep) {
      case 0:
        // Campus basic information.
        return Column(
          children: [
            SizedBox(height: 20),
            FormInputField(
              label: local.collegeName,
              hintText: local.enterYourCollegeUniversityName,
              controller: _collegeNameController,
              validator: Validators.validateCollegeName,
            ),
            FormInputField(
              label: local.email,
              hintText: local.enterYourEmail,
              controller: _emailController,
              validator: Validators.validateEmail,
            ),
            FormInputField(
              label: local.location,
              hintText: local.exJerusalem,
              controller: _locationController,
              validator: Validators.validateLocation,
            ),
            FormInputField(
              label: local.phoneNumber,
              hintText: "+972 123456789",
              controller: _phoneController,
              validator: Validators.validatePhoneNumber,
            ),
            FormInputField(
              label: local.website,
              hintText: "ex: https://www.example.com",
              controller: _websiteController,
              validator: Validators.validateWebsite,
            ),
            SizedBox(height: 20),
            FormInputField(
              label: local.description,
              hintText: local.enterYourDescription,
              controller: _descriptionController,
              maxLines: 7,
              validator: Validators.validateDescription,
            ),
          ],
        );
      case 1:
        // Operating hours using your DayHoursSelector widget.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(local.openingHoures,
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            DayHoursSelector(
              onHoursChanged: (updatedHours) {
                setState(() {
                  _operatingHours = updatedHours;
                });
              },
            ),
          ],
        );
      case 2:
        // Image uploads for cover, gallery, and album.
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover Image Upload.
              Text('${local.coverImage} (${local.max} 1) ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 10),
              ImageUploadWidget(
                maxImages: 1,
                isMultiple: false,
                onImagesSelected: (images) {
                  setState(() {
                    _coverImage = images.isNotEmpty ? images.first : null;
                  });
                },
              ),
              SizedBox(height: 30),
              // Gallery Images Upload.
              Text('${local.galleryImage} (${local.max} 3)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 10),
              ImageUploadWidget(
                maxImages: 3,
                isMultiple: true,
                onImagesSelected: (images) {
                  setState(() {
                    _galleryImages = images;
                  });
                },
              ),
              SizedBox(height: 30),
              // Building Album Images Upload.
              Text('${local.buildingAlbum} (${local.max} 50)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 10),
              ImageUploadWidget(
                maxImages: 50,
                isMultiple: true,
                onImagesSelected: (images) {
                  setState(() {
                    _albumImages = images;
                  });
                },
              ),
              SizedBox(height: 30),
            ],
          ),
        );
      default:
        return SizedBox.shrink();
    }
  }

  /// Builds a simple stepper header.
  Widget _buildStepperHeader() {
    final local = AppLocalizations.of(context)!;
    List<String> steps = [
      local.buildingInfo,
      local.openClosedHoures,
      local.uploadImage,
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

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text(local.newBuilding),
        automaticallyImplyLeading: true,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: Column(
              children: [
                _buildStepperHeader(),
              ],
            )),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Container(
              width: 500,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
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
                    // _buildStepperHeader(),
                    // SizedBox(height: 20),
                    _buildStepContent(),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentStep > 0)
                          TextButton(
                            onPressed: _prevStep,
                            child: Text(local.back),
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
                            _currentStep < 2 ? local.next : local.submit,
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
      ),
    );
  }
}
