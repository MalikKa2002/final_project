import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';

class ImageUploadWidget extends StatefulWidget {
  final int maxImages;
  final bool isMultiple;
  final void Function(List<Uint8List>)? onImagesSelected;

  const ImageUploadWidget({
    super.key,
    required this.maxImages,
    this.isMultiple = false,
    this.onImagesSelected,
  });

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
      allowMultiple: widget.isMultiple,
      withData: true,
    );
    if (result != null) {
      setState(() {
        for (var file in result.files) {
          if (uploadedImages.length >= widget.maxImages) break;
          if (file.bytes != null) {
            uploadedImages.add(file.bytes!);
            imageNames.add(file.name);
            itemCount++;
          }
        }
        dropMessage = "Selected: $itemCount/${widget.maxImages} images";
      });
      // Notify the parent widget of the updated images.
      if (widget.onImagesSelected != null) {
        widget.onImagesSelected!(uploadedImages);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
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
                      onPressed: uploadedImages.length >= widget.maxImages
                          ? null
                          : _pickImage,
                      child: Text("Upload"),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            if (uploadedImages.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.start,
                  children: List.generate(uploadedImages.length, (index) {
                    return Stack(
                      children: [
                        // Display the image thumbnail.
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            uploadedImages[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Close icon positioned in the top right corner to remove the image.
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                uploadedImages.removeAt(index);
                                imageNames.removeAt(index);
                                itemCount--;
                                dropMessage = "Selected: $itemCount images";
                              });
                              if (widget.onImagesSelected != null) {
                                widget.onImagesSelected!(uploadedImages);
                              }
                            },
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.black54,
                              child: Icon(Icons.close,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
