import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Loading'.tr,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
