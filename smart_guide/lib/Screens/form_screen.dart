import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smart_guide/Services/validators.dart';
import 'package:smart_guide/components/day_hours.dart';
import 'package:smart_guide/components/form_input_field.dart';
import '../components/upload_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_guide/screens/home_screen.dart';

class FormScreen extends StatefulWidget {
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isLoading = false;

  // Controllers for fixed fields (step 0):
  final TextEditingController _collegeNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Operating hours (step 1):
  Map<String, Map<String, String>> _operatingHours = {
    "Sunday": {"open": "", "close": ""},
    "Monday": {"open": "", "close": ""},
    "Tuesday": {"open": "", "close": ""},
    "Wednesday": {"open": "", "close": ""},
    "Thursday": {"open": "", "close": ""},
    "Friday": {"open": "", "close": ""},
    "Saturday": {"open": "", "close": ""},
  };

  // Image data (step 2):
  Uint8List? _coverImage;
  List<Uint8List> _galleryImages = [];
  List<Uint8List> _albumImages = [];

  // Dynamic “places” controllers (step 0):
  final List<TextEditingController> _placeControllers = [];

  @override
  void initState() {
    super.initState();
    _addNewPlaceController(); // Start with one place field by default
  }

  @override
  void dispose() {
    _collegeNameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    for (var c in _placeControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addNewPlaceController() {
    final controller = TextEditingController();
    setState(() {
      _placeControllers.add(controller);
    });
  }

  void _removePlaceController(int index) {
    if (_placeControllers.length > 1) {
      setState(() {
        _placeControllers[index].dispose();
        _placeControllers.removeAt(index);
      });
    }
  }

  /// _nextStep() now also checks: at step 2, ensure a cover image exists.
  void _nextStep() {
    if (_currentStep == 0) {
      // Validate only step 0 fields before moving on.
      if (!_formKey.currentState!.validate()) return;
    }

    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      // At step 2: verify cover image is set before submission.
      if (_coverImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.coverRequiredError,
              // You’ll need to add this key to your ARB files:
              //   "coverRequiredError": "Please select a cover image"
            ),
          ),
        );
        return;
      }
      _submitForm();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _submitForm() async {
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    String collegeNameTrimmed = _collegeNameController.text.trim();

    // Check for duplicate campus name:
    QuerySnapshot existingCampusSnapshot = await FirebaseFirestore.instance
        .collection('campuses')
        .where('college_name', isEqualTo: collegeNameTrimmed)
        .get();
    if (existingCampusSnapshot.docs.isNotEmpty) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Campus already exists!')),
      );
      return;
    }

    // Collect all non‐empty “places”:
    List<String> places = _placeControllers
        .map((c) => c.text.trim())
        .where((txt) => txt.isNotEmpty)
        .toList();

    // Prepare initial campus data:
    Map<String, dynamic> formData = {
      "college_name": collegeNameTrimmed,
      "email": _emailController.text.trim(),
      "location": _locationController.text.trim(),
      "phone": _phoneController.text.trim(),
      "website": _websiteController.text.trim(),
      "description": _descriptionController.text.trim(),
      "places": places,
      "operating_hours": _operatingHours,
      "cover_image": "",
      "gallery_images": [],
      "album_images": [],
    };

    try {
      // 1. Create new Firestore document under “campuses”
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('campuses').add(formData);
      String campusId = docRef.id;

      // 2. Immediately add an entry to “waiting_to_approve”
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('waiting_to_approve')
            .add({
          'user_id': user.uid,
          'campus_id': campusId,
          'approved': false, // initial state: not yet approved
        });
      }

      // 3. Upload images if provided:
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

      // 4. Update Firestore doc with URLs:
      await docRef.update({
        "cover_image": coverImageUrl,
        "gallery_images": galleryImageUrls,
        "album_images": albumImageUrls,
      });

      setState(() => _isLoading = false);

      // 5. Navigate back to HomeScreen (clearing stack):
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Campus added successfully')),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add campus: $e')),
      );
    }
  }

  Future<String> _uploadImage(
      Uint8List imageData, String campusId, String imageName) async {
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child("campus_images")
        .child(campusId)
        .child("$imageName.jpg");

    UploadTask uploadTask = storageRef.putData(imageData);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Widget _buildStepContent() {
    final local = AppLocalizations.of(context)!;

    switch (_currentStep) {
      case 0:
        return Column(
          children: [
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            FormInputField(
              label: local.description,
              hintText: local.enterYourDescription,
              controller: _descriptionController,
              maxLines: 7,
              validator: Validators.validateDescription,
            ),
            const SizedBox(height: 20),
            // Dynamic “places” fields:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  local.placesLabel, // “Places”
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: _addNewPlaceController,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: Text(local.addPlace), // “Add Place”
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Render one input + remove button per _placeControllers:
            ..._placeControllers.asMap().entries.map((entry) {
              int index = entry.key;
              TextEditingController placeCtrl = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    Expanded(
                      child: FormInputField(
                        label: "${local.place} ${index + 1}", // “Place 1”, “Place 2”, …
                        hintText: local.enterPlaceName, // “Enter place name”
                        controller: placeCtrl,
                        validator: null, // no validator here
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (_placeControllers.length > 1)
                      IconButton(
                        icon: const Icon(Icons.remove_circle,
                            color: Colors.redAccent),
                        onPressed: () => _removePlaceController(index),
                      ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
          ],
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(local.openingHoures,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            DayHoursSelector(
              onHoursChanged: (updatedHours) {
                setState(() {
                  _operatingHours = updatedHours;
                });
              },
            ),
            // No required‐field check here (step 1 can be empty)
          ],
        );

      case 2:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover Image Upload:
              Text('${local.coverImage} (${local.max} 1)',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              ImageUploadWidget(
                maxImages: 1,
                isMultiple: false,
                onImagesSelected: (images) {
                  setState(() {
                    _coverImage = images.isNotEmpty ? images.first : null;
                  });
                },
              ),
              const SizedBox(height: 30),

              // Gallery Images Upload:
              Text('${local.galleryImage} (${local.max} 3)',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              ImageUploadWidget(
                maxImages: 3,
                isMultiple: true,
                onImagesSelected: (images) {
                  setState(() {
                    _galleryImages = images;
                  });
                },
              ),
              const SizedBox(height: 30),

              // Album Images Upload:
              Text('${local.buildingAlbum} (${local.max} 50)',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              ImageUploadWidget(
                maxImages: 50,
                isMultiple: true,
                onImagesSelected: (images) {
                  setState(() {
                    _albumImages = images;
                  });
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

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
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 4),
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
            preferredSize: const Size.fromHeight(70),
            child: Column(
              children: [
                _buildStepperHeader(),
              ],
            )),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  width: 500,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: const [
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
                        _buildStepContent(),
                        const SizedBox(height: 30),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                              child: Text(
                                _currentStep < 2 ? local.next : local.submit,
                                style: const TextStyle(color: Colors.white),
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

          // Loading overlay while uploading/creating:
          if (_isLoading)
            Container(
              color: Colors.black45,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
