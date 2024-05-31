
  // Future<void> _pickImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       selectedImage = File(pickedFile.path);
  //     });

  //       final Directory appDir = await getApplicationDocumentsDirectory();
  //       final String imagePath = '${appDir.path}/selected_image.jpg';
  //       final File newImage = await pickedFile.copy(imagePath);

  //   }
  // }

//    Future<void> _pickImage() async {
//   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//   if (pickedFile != null) {
//     // Convert XFile to File
//     final File pickedFileAsFile = File(pickedFile.path);

//     // Get the directory for saving files
//     final Directory appDir = await getApplicationDocumentsDirectory();
//     final String imagesDirectory = '${appDir.path}/ram/images';

//     // Create the 'ram/images' directory if it doesn't exist
//     final Directory directory = Directory(imagesDirectory);
//     if (!await directory.exists()) {
//       await directory.create(recursive: true);
//     }

//     // Get the original filename
//     final String originalFilename = path.basename(pickedFile.path);

//     // Define the image path within the 'ram/images' directory using the original filename
//     final String imagePath = '$imagesDirectory/$originalFilename';

//     try {
//       // Copy the image file to the 'ram/images' directory
//       final File newImage = await pickedFileAsFile.copy(imagePath);

//       setState(() {
//         selectedImage = newImage;
//       });
//        print('Image copied successfully: $imagePath');

//       // Now you can use the 'newImage' file object to manipulate or display the image
//     } catch (e) {
//       print('Error copying image: $e');
//     }
//   }
// }



Future<void> _pickImage() async {
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    // Convert XFile to File
    final File pickedFileAsFile = File(pickedFile.path);

    try {
      // Get the directory for saving files
      final Directory appDir = await getApplicationDocumentsDirectory();
      
      // Create the 'images' directory if it doesn't exist
      final String imagesDirectory = '${appDir.path}/images';
      final Directory directory = Directory(imagesDirectory);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Generate a unique filename for the image
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String filename = 'image_$timestamp.jpg';
      
      // Define the image path within the 'images' directory
      final String imagePath = '$imagesDirectory/$filename';

      // Copy the image file to the 'images' directory
      final File newImage = await pickedFileAsFile.copy(imagePath);

      setState(() {
        selectedImage = newImage;
      });
      
      print('Image copied successfully: $imagePath');

      // Now you can use the 'newImage' file object to manipulate or display the image
    } catch (e) {
      print('Error copying image: $e');
    }
  }
}
