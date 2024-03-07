import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/Model/user_model.dart';
import 'package:tiktok_clone/View/screens/home/profile/profile_screen.dart';
import '../../../../Controller/home/search_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = Get.put(SearchsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          titleSpacing: 6,
          backgroundColor: Colors.black54,
          title: TextFormField(
            controller: controller.searchUser,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.white70,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(6.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.white70,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(6.0),
              ),
              hintText: 'Search here...',
              hintStyle: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            ),
            onFieldSubmitted: (textInput) {
              controller.searchForUser(textInput);
            },
          ),
        ),
        body: controller.userSearchedList.isEmpty
            ? Center(
                child: Image.asset(
                  'assets/images/search.png',
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
              )
            : ListView.builder(
                itemCount: controller.userSearchedList.length,
                itemBuilder: (context, index) {
                  User eachUserRecord = controller.userSearchedList[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 4,
                    ),
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          Get.to(
                            ProfileScreen(
                              visitUserID : eachUserRecord.uid.toString(),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              eachUserRecord.image.toString(),
                            ),
                          ),
                          title: Text(
                            eachUserRecord.name.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            eachUserRecord.email.toString(),
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.navigate_next_outlined,
                              size: 24,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      );
    });
  }
}
