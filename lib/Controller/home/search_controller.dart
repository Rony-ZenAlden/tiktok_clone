import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/Model/user_model.dart';

class SearchsController extends GetxController {

  /// Variables
  final _fireStore = FirebaseFirestore.instance;
  final searchUser = TextEditingController();
  final Rx<List<User>> _userSearchedList = Rx<List<User>>([]);

  List<User> get userSearchedList => _userSearchedList.value;

  searchForUser(String textInput) async {
    _userSearchedList.bindStream(
        _fireStore.collection('Users').where(
            'name', isGreaterThanOrEqualTo: textInput).snapshots().map((
            QuerySnapshot searchUsersQuerySnapshot) {
              List<User> searchList = [];
              for(var user in searchUsersQuerySnapshot.docs){
                searchList.add(User.fromSnap(user));
              }
              return searchList;
        })
    );
  }

}