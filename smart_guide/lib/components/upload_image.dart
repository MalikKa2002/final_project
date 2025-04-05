import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';

class ImageUploadWidget extends StatefulWidget {
  @override
  createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  String dropMessage = "Select images";
  List<Uint8List> uploadedImages = [];
  List<String> imageNames = [];
  int itemCount = 0;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );
    if (result != null) {
      setState(() {
        for (var file in result.files) {
          if (file.bytes != null) {
            uploadedImages.add(file.bytes!);
            imageNames.add(file.name);
            itemCount++;
          }
        }
        dropMessage = "Selected: $itemCount images";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(12),
              color: Colors.deepPurpleAccent,
              dashPattern: [8, 4],
              strokeWidth: 2,
              child: Container(
                padding: EdgeInsets.all(32),
                width: double.infinity,
                child: Column(
                  children: [
                    Icon(Icons.image_outlined,
                        size: 48, color: Colors.deepPurple),
                    SizedBox(height: 16),
                    Text(
                      dropMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      onPressed: _pickImage,
                      child: Text("Upload"),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            if (uploadedImages.isNotEmpty)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(uploadedImages.length, (index) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              uploadedImages[index],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            imageNames[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: 18, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            uploadedImages.removeAt(index);
                            imageNames.removeAt(index);
                            itemCount--;
                            dropMessage = "Selected: $itemCount images";
                          });
                        },
                      ),
                    ],
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }
}
