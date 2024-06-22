
  // Future<void> _updateBusiness() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString('jwt_token');
  //     final userId = prefs.getInt('user_id');

  //     if (token == null || userId == null) {
  //       throw Exception('Token or user ID not found');
  //     }
  //     int businessId = widget.initialData!['id'] ?? 0;
  //     const apiUrl =
  //         'http://62.72.13.94:9081/api/ramusrg/updateserviceProvider';

  //     final Map<String, dynamic> updatedData = {
  //       'id': businessId,
  //       'businessName': _businessNameController.text,
  //       'email': _emailController.text,
  //       'businessType': _businessTypeController.text,
  //       'businessUrlHandle': _businessUrlHandleController.text,
  //       'primaryPhone': _primaryPhoneController.text,
  //       'status': true,
  //       'owner': true,
  //       'ramOwn': {'id': userId},

  //       "contacts": [],
  //       "favorites": [],
       
  //       "registeredViaApp": false,
  //       "emailVerified": false,
  //       "phoneVerified": false,

  //       'profile': {
  //         "id": widget.initialData!['profile']['id'],
  //         'businessText': _profileController.text,
  //         "userName": " ",
  //         "favoriteCount": 0,
  //         "lifetimeHitCount": 0
  //       },
  //       'userAssociations': _userAssociations,
  //       'zipCodes': _zipCodes
  //           .map((zip) => {
  //                 'zipCode': zip,
  //                 'zipCodeHitCount': 0,
  //                 'id': widget.initialData!['zipCodes']
  //                     ?.firstWhere((element) => element['zipCode'] == zip)['id']
  //               })
  //           .toList(),
  //       'skillSets': _skillSets
  //           .map((skill) => {
  //                 'skillText': skill,
  //                 'skillHitCount': 0,
  //                 'id': widget.initialData!['skillSets']?.firstWhere(
  //                     (element) => element['skillText'] == skill)['id']
  //               })
  //           .toList(),

  //       // something mistake here in phone numbers
  //       // 'phoneNumbers': _phoneNumbers
  //       //     .map((phone) => {
  //       //           'phoneNumber': phone,
  //       //           'phoneNumberType': 0,
  //       //           'id': widget.initialData!['phoneNumbers']?.firstWhere(
  //       //               (element) => element['phoneNumber'] == phone)['id']
  //       //         })
  //       //     .toList(),

  //       // 'phoneNumbers': _phoneNumbers.map((phone) {
  //       //   final initialPhone = widget.initialData!['phoneNumbers']?.firstWhere(
  //       //       (element) => element['phoneNumber'] == phone,
  //       //       orElse: () => {'id': 0});
  //       //   return {
  //       //     'phoneNumber': phone,
  //       //     'phoneNumberType': 0,
  //       //     'id': initialPhone != null ? initialPhone['id'] : 0,
  //       //   };
  //       // }).toList(),

  //       'emailAddresses': _emailAddresses
  //           .map((email) => {
  //                 'emailAddress': email,
  //                 'emailAddressType': 0,
  //                 'id': widget.initialData!['emailAddresses']?.firstWhere(
  //                     (element) => element['emailAddress'] == email)['id']
  //               })
  //           .toList(),
  //       'addresses': _addresses
  //           .map((address) => {
  //                 'address': address,
  //                 "latitude": 25.4484257,
  //                 "longitude": 78.5684594,
  //                 'id': widget.initialData!['addresses']?.firstWhere(
  //                         (element) => element['address'] == address)['id'] ??
  //                     0
  //               })
  //           .toList(),
  //     };
  //     print(updatedData);

  //     final response = await http.put(
  //       Uri.parse(apiUrl),
  //       headers: {
  //         'Authorization': token,
  //         'Content-Type': 'application/json',
  //       },
  //       body: json.encode(updatedData),
  //     );

  //     print('Response status code: ${response.statusCode}');
  //     print('Response body: ${response.body}');

  //     if (response.statusCode == 200) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Business updated successfully')),
  //       );
  //     } else {
  //       throw Exception('Failed to update business: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     print('Error updating business: $error');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error updating business: $error')),
  //     );
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }