import 'package:flutter/material.dart';

class FollowingVideoScreen extends StatefulWidget {
  const FollowingVideoScreen({super.key});

  @override
  State<FollowingVideoScreen> createState() => _FollowingVideoScreenState();
}

class _FollowingVideoScreenState extends State<FollowingVideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Following Video Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Following Video Screen')
          ],
        ),
      ),
    );
  }
}
