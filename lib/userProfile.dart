import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_list/models/user.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class UserProfile extends StatefulWidget {
  // final String userId;
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool _isFirstLoadRunning = true;
  bool _isLoadMoreRunning = false;

  late Future<User> futureUser;

  List<User> userprofile = [];
  User _profile = User();

  Future<User> fetchUser() async {
    final response = await http.get(
      Uri.parse('https://dummyapi.io/data/v1/user/60d0fe4f5311236168a109ca'),
      headers: {'app-id': '61151dc619e074b995f40062'},
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print('fetch user');
      _profile = User.fromJson(jsonDecode(response.body));
      print(_profile.id);
      return _profile;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load User');
    }
  }

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
    print(futureUser.toString());
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new_outlined)),
        title: Text(
          'User Profile Data',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.network(
                          _profile.picture ??
                              'https://www.pngfind.com/pngs/m/610-6104451_image-placeholder-png-user-profile-placeholder-image-png.png',
                        ).image,
                      ),
                    )),
              ),
              Container(
                height: size.height * 0.5,
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Username : ',
                              style: GoogleFonts.raleway(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${_profile.firstName ?? ''} ${_profile.lastName ?? ''}',
                              style: GoogleFonts.poppins(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email : ',
                              style: GoogleFonts.raleway(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${_profile.email ?? ''}',
                              style: GoogleFonts.poppins(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DOB : ',
                              style: GoogleFonts.raleway(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${_profile.dateOfBirth ?? ''}',
                              style: GoogleFonts.poppins(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gender : ',
                              style: GoogleFonts.raleway(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${_profile.gender ?? ''}',
                              style: GoogleFonts.poppins(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Phone : ',
                              style: GoogleFonts.raleway(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${_profile.phone ?? ''}',
                              style: GoogleFonts.poppins(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
