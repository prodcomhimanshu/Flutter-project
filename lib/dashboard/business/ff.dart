import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FourthPage extends StatefulWidget {
  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  List<File> selectedImages = [];
  List<TextEditingController> imageDescriptions = [];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        selectedImages.add(File(pickedFile.path));
        imageDescriptions.add(TextEditingController());
      } else {
        print('No image selected.');
      }
    });
  }

  void _removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
      imageDescriptions.removeAt(index);
    });
  }

  Future<void> _uploadImages() async {
    // Implement your upload logic here
    // Example: Loop through selectedImages and imageDescriptions to upload each image
    for (int i = 0; i < selectedImages.length; i++) {
      File image = selectedImages[i];
      String description = imageDescriptions[i].text;

      print('Uploading Image $i: $image');
      print('Image Description $i: $description');

      // Add your upload logic here (e.g., using http package to upload to a server)
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: <Widget>[
        const Text('Upload Images',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Column(
          children: List.generate(selectedImages.length, (index) {
            return Column(
              children: [
                Image.file(selectedImages[index]),
                TextFormField(
                  controller: imageDescriptions[index],
                  decoration:
                      const InputDecoration(labelText: 'Image Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () => _removeImage(index),
                  child: const Text('Remove Image'),
                ),
                SizedBox(height: 20),
              ],
            );
          }),
        ),
        ElevatedButton(
          onPressed: _pickImage,
          child: const Text('Choose Image'),
        ),
        ElevatedButton(
          onPressed: _uploadImages,
          child: const Text('Upload Images'),
        ),
      ],
    );
  }
}
