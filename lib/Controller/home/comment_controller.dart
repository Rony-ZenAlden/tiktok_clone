import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentController extends GetxController {
  final comment = TextEditingController();
  GlobalKey<FormState> commentFormKey = GlobalKey<FormState>();
}