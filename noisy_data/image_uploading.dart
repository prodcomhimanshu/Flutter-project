import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(
    home: ImageUploadWidget(),
  ));
}

class ImageUploadWidget extends StatefulWidget {
  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  File? _imageFile;
  String? _uploadedImageUrl;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      print('No image to upload.');
      return;
    }

    String apiUrl = 'http://your-api-endpoint/upload'; // Replace with your API endpoint

    try {
      // Create multipart request for image upload
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add file to multipart request
      request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));

      // Send request
      var response = await request.send();

      // Check the status code for the server response
      if (response.statusCode == 200) {
        // If successful, parse the response JSON
        var responseData = await response.stream.toBytes();
        var decodedData = utf8.decode(responseData);
        var parsedJson = jsonDecode(decodedData);

        // Assuming your API returns a URL to the uploaded image
        setState(() {
          _uploadedImageUrl = parsedJson['imageUrl']; // Adjust according to your API response structure
        });

        // Show a success message or handle further operations
        print('Image uploaded successfully. Image URL: $_uploadedImageUrl');
      } else {
        // Handle other cases
        print('Failed to upload image. Error ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload Widget'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_imageFile != null) ...[
            Image.file(_imageFile!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Image'),
            ),
            SizedBox(height: 20),
            if (_uploadedImageUrl != null)
              Text(
                'Uploaded Image URL: $_uploadedImageUrl',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
          ] else ...[
            Text('No image selected.'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: Text('Select Image'),
                ),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  child: Text('Take Photo'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
