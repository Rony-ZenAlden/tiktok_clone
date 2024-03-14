import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/Controller/Authentication/signin_controller.dart';
import 'package:tiktok_clone/Model/user_model.dart' as model;

import '../../View/screens/splash/onBoarding_screen.dart';
import '../../View/screens/splash/splash_screen.dart';

class AuthController extends GetxController {
  // late Rx<File?> _pickedFile;
  //
  // File? get profileImage => _pickedFile.value;
  //
  // void chooseImageFromGallery() async {
  //   final pickedImageFile =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //
  //   if (pickedImageFile != null) {
  //     Get.snackbar(
  //         'ProfileImage', 'you have successfully selected your profile image.');
  //   }
  //
  //   _pickedFile = Rx<File?>(File(pickedImageFile!.path));
  // }
  //
  // void chooseImageFromCamera() async {
  //   final pickedImageFile =
  //   await ImagePicker().pickImage(source: ImageSource.camera);
  //
  //   if (pickedImageFile != null) {
  //     Get.snackbar(
  //         'ProfileImage', 'you have successfully selected your profile image.');
  //   }
  //
  //   _pickedFile = Rx<File?>(File(pickedImageFile!.path));
  // }

  /// Variables
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  late Rx<User?> _currentUser;

  // pickProfileImage(ImageSource source) async {
  //   final ImagePicker imagePicker = ImagePicker();
  //
  //   XFile? file = await imagePicker.pickImage(source: source);
  //   if (file != null) {
  //     return await file.readAsBytes();
  //   } else {
  //     return print('No Image Select');
  //   }
  // }
  /// Pick-Image
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> takePicture(SignInController imagePickerController) async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      Uint8List bytes = await image.readAsBytes();
      imagePickerController.setImageBytes(bytes);
    }
  }

  Future<void> pickImageFromGallery(
      SignInController imagePickerController) async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Uint8List bytes = await image.readAsBytes();
      imagePickerController.setImageBytes(bytes);
    }
  }

  /// Upload Image
  Future<String> uploadImageToStorage(Uint8List? image) async {
    Reference ref =
        _storage.ref().child('Profile Images').child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(image!);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  /// Create Account To User
  void createAccountForUser(
      String userName, String email, String password, Uint8List? image) async {
    try {
      // 1.Create user in the firebase authentication
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 2.Save the user profile image to firebase storage
      String imageDownloadUrl = await uploadImageToStorage(image);

      // 3.Save user data to the fireStore database
      model.User user = model.User(
        name: userName,
        email: email,
        password: password,
        image: imageDownloadUrl,
        uid: credential.user!.uid,
        facebook: '',
        youtube: '',
        instagram: '',
        twitter: '',
      );
      await _fireStore
          .collection('Users')
          .doc(credential.user!.uid)
          .set(user.toJson());
    } catch (e) {
      Get.snackbar('Warning', e.toString());
    }
  }

  /// Login To User
  void loginForUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar('Warning', e.toString(),backgroundColor: Colors.black87,);
    }
  }

  /// Check User Situation
  goToScreen(User? currentUser) {
    // When user is not login
    // When user click on logout button
    if (currentUser == null) {
      Get.offAll(const OnBoardingScreen());
    }
    // When user is already login
    else {
      Get.offAll(const SplashScreen());
    }
  }

  @override
  void onReady() {
    super.onReady();
    _currentUser = Rx<User?>(FirebaseAuth.instance.currentUser);
    _currentUser.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(_currentUser, goToScreen);
  }
}
