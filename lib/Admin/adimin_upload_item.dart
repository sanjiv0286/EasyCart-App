// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:easymart/Users/authentication/login.dart';
import 'package:easymart/api_connecction/api_connection.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AdminUploadItemsScreen extends StatefulWidget {
  const AdminUploadItemsScreen({super.key});
  @override
  State<AdminUploadItemsScreen> createState() => _AdminUploadItemsScreenState();
}

class _AdminUploadItemsScreenState extends State<AdminUploadItemsScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImageXFile;

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var ratingController = TextEditingController();
  var tagsController = TextEditingController();
  var priceController = TextEditingController();
  var sizesController = TextEditingController();
  var colorsController = TextEditingController();
  var descriptionController = TextEditingController();
  var imageLink = "";
  var statusMessage = "";
  //defaultScreen methods
  captureImageWithPhoneCamera() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);

    Get.back();

    setState(() => pickedImageXFile);
  }

  pickImageFromPhoneGallery() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);

    Get.back();

    setState(() => pickedImageXFile);
  }

  showDialogBoxForImagePickingAndCapturing() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.black,
            title: const Text(
              "Item Image",
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  captureImageWithPhoneCamera();
                },
                child: const Text(
                  "Capture with Phone Camera",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  pickImageFromPhoneGallery();
                },
                child: const Text(
                  "Pick Image From Phone Gallery",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        });
  }

  //defaultScreen methods ends here
  Widget defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black54,
                Colors.deepPurple,
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            // Get.to(AdminGetAllOrdersScreen());
          },
          child: const Text(
            "New Orders",
            style: TextStyle(
              color: Colors.green,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const LoginScreen());
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black54,
              Colors.deepPurple,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_photo_alternate,
                color: Colors.white54,
                size: 200,
              ),

              //button
              Material(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: () {
                    showDialogBoxForImagePickingAndCapturing();
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 28,
                    ),
                    child: Text(
                      "Add New Item",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ***************************************************************
  Future<void> uploadItemImage() async {
    try {
      // *Prepare the request for the Imgur API
      var requestImgurApi = http.MultipartRequest(
          "POST", Uri.parse("https://api.imgur.com/3/image"));

      // *Generate a unique image name based on the current timestamp
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();

      // *Set request fields and headers
      requestImgurApi.fields['title'] = imageName;
      requestImgurApi.headers['Authorization'] = "Client-ID 912ab96058a9a2b";

      // *Create a multipart file from the selected image
      var imageFile = await http.MultipartFile.fromPath(
        'image',
        pickedImageXFile!.path,
        filename: imageName,
      );

      // *Add the image file to the request
      requestImgurApi.files.add(imageFile);

      // *Send the request to the Imgur API
      var responseFromImgurApi = await requestImgurApi.send();

      // *Read the response data from the Imgur API
      var responseDataFromImgurApi =
          await responseFromImgurApi.stream.toBytes();
      var resultFromImgurApi = String.fromCharCodes(responseDataFromImgurApi);
      print('Raw response from Imgur API: $resultFromImgurApi');

      // *Check if the response status code is 200 (success)
      if (responseFromImgurApi.statusCode == 200) {
        // *Parse the JSON response
        Map<String, dynamic> jsonRes = json.decode(resultFromImgurApi);
        imageLink = (jsonRes["data"]["link"]).toString();
        String deleteHash = (jsonRes["data"]["deletehash"]).toString();

        //* Save the item information to the database
        saveItemInfoToDatabase();

        print('Image link: $imageLink');
        print('Delete hash: $deleteHash');

        // Fluttertoast.showToast(
        //   msg: "Image uploaded successfully!", //$resultFromImgurApi",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.BOTTOM,
        // );
      } else {
        // *Handle non-successful response
        // print(
        //     'Failed to upload image. Status code: ${responseFromImgurApi.statusCode}');
        // print('Response: $resultFromImgurApi');

        // setState(() {
        //   statusMessage =
        //       "Failed to upload image. Status code: ${responseFromImgurApi.statusCode}";
        // });

        Fluttertoast.showToast(
          msg:
              "Failed to upload image. Status code: ${responseFromImgurApi.statusCode}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      // *Log any errors that occur during the request
      // print('Error uploading image: $e');

      // setState(() {
      //   statusMessage = "Error uploading image: $e";
      // });

      Fluttertoast.showToast(
        msg: "Error uploading image: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  // ***************************************************************

  saveItemInfoToDatabase() async {
    List<String> tagsList = tagsController.text.split(',');
    List<String> sizesList = sizesController.text.split(',');
    List<String> colorsList = colorsController.text.split(',');

    try {
      var response = await http.post(
        Uri.parse(API.uploadNewItem),
        body: {
          'item_id': '1',
          'name': nameController.text.trim().toString(),
          'rating': ratingController.text.trim().toString(),
          'tags': tagsList.toString(),
          'price': priceController.text.trim().toString(),
          'sizes': sizesList.toString(),
          'colors': colorsList.toString(),
          'description': descriptionController.text.trim().toString(),
          'image': imageLink.toString(),
        },
      );

      if (response.statusCode == 200) {
        var resBodyOfUploadItem = jsonDecode(response.body);

        if (resBodyOfUploadItem['success'] == true) {
          Fluttertoast.showToast(msg: "New item uploaded successfully");

          setState(() {
            pickedImageXFile = null;
            nameController.clear();
            ratingController.clear();
            tagsController.clear();
            priceController.clear();
            sizesController.clear();
            colorsController.clear();
            descriptionController.clear();
          });

          Get.to(const AdminUploadItemsScreen());
        } else {
          Fluttertoast.showToast(msg: "Item not uploaded. Error, Try Again.");
        }
      } else {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    } catch (errorMsg) {
      stdout.write("Error:: $errorMsg");
    }
  }
  //uploadItemFormScreen methods ends here

  Widget uploadItemFormScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black54,
                Colors.deepPurple,
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: const Text(
          "Upload Form",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            setState(() {
              pickedImageXFile = null;
              nameController.clear();
              ratingController.clear();
              tagsController.clear();
              priceController.clear();
              sizesController.clear();
              colorsController.clear();
              descriptionController.clear();
            });

            Get.to(const AdminUploadItemsScreen());
          },
          icon: const Icon(
            Icons.clear,
          ),
        ),
        // actions: [
        //   TextButton(
        //     onPressed: () {
        //       Fluttertoast.showToast(msg: "Uploading now...");

        //       uploadItemImage();
        //     },
        //     child: const Text(
        //       "Done",
        //       style: TextStyle(
        //         color: Colors.green,
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: ListView(
        children: [
          //image
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(
                  File(pickedImageXFile!.path),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          //upload item form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.all(
                  Radius.circular(60),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black26,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                child: Column(
                  children: [
                    //*email-password-login button
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          //item name
                          TextFormField(
                            controller: nameController,
                            validator: (val) =>
                                val == "" ? "Please write item name" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.title,
                                color: Colors.black,
                              ),
                              hintText: "item name...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          //item ratings
                          TextFormField(
                            controller: ratingController,
                            validator: (val) =>
                                val == "" ? "Please give item rating" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.rate_review,
                                color: Colors.black,
                              ),
                              hintText: "item rating...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          //item tags
                          TextFormField(
                            controller: tagsController,
                            validator: (val) =>
                                val == "" ? "Please write item tags" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.tag,
                                color: Colors.black,
                              ),
                              hintText: "item tags...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          //item price
                          TextFormField(
                            controller: priceController,
                            validator: (val) =>
                                val == "" ? "Please write item price" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.price_change_outlined,
                                color: Colors.black,
                              ),
                              hintText: "item price...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          //item sizes
                          TextFormField(
                            controller: sizesController,
                            validator: (val) =>
                                val == "" ? "Please write item sizes" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.picture_in_picture,
                                color: Colors.black,
                              ),
                              hintText: "item size...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          //item colors
                          TextFormField(
                            controller: colorsController,
                            validator: (val) =>
                                val == "" ? "Please write item colors" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.color_lens,
                                color: Colors.black,
                              ),
                              hintText: "item colors...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          //item description
                          TextFormField(
                            controller: descriptionController,
                            validator: (val) => val == ""
                                ? "Please write item description"
                                : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.description,
                                color: Colors.black,
                              ),
                              hintText: "item description...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          //button
                          Material(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  Fluttertoast.showToast(
                                      msg: "Uploading now...");

                                  uploadItemImage();
                                }
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 28,
                                ),
                                child: Text(
                                  "Upload Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return pickedImageXFile == null ? defaultScreen() : uploadItemFormScreen();
  }
}
