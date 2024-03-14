import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? name;
  String? uid;
  String? image;
  String? email;
  String? password;
  String? youtube;
  String? facebook;
  String? twitter;
  String? instagram;

  User({
    this.name,
    this.uid,
    this.image,
    this.email,
    this.password,
    this.youtube,
    this.facebook,
    this.twitter,
    this.instagram,
  });

  Map<String, dynamic> toJson() => {
        // final Map<String, dynamic> data = new Map<String, dynamic>();
        'name': name,
        'uid': uid,
        'image': image,
        'email': email,
        'password': password,
        'youtube': youtube,
        'facebook': facebook,
        'twitter': twitter,
        'instagram': instagram,
        // return data;
      };

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uid = json['uid'];
    image = json['image'];
    email = json['email'];
    password = json['password'];
    youtube = json['youtube'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    instagram = json['instagram'];
  }

  static User fromSnap(DocumentSnapshot snapshot) {
    var dataSnapshot = snapshot.data() as Map<String, dynamic>;

    return User(
      name: dataSnapshot['name'],
      uid: dataSnapshot['uid'],
      image: dataSnapshot['image'],
      email: dataSnapshot['email'],
      password: dataSnapshot['password'],
      youtube: dataSnapshot['youtube'],
      facebook: dataSnapshot['facebook'],
      twitter: dataSnapshot['twitter'],
      instagram: dataSnapshot['instagram'],
    );
  }
}
