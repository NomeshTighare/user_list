import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? id;
  String? title;
  String? firstName;
  String? lastName;
  String? picture;
  String? gender;
  String? email;
  String? dateOfBirth;
  String? phone;
  Location? location;
  String? registerDate;
  String? updatedDate;

  User(
      {this.id,
      this.title,
      this.firstName,
      this.lastName,
      this.picture,
      this.gender,
      this.email,
      this.dateOfBirth,
      this.phone,
      this.location,
      this.registerDate,
      this.updatedDate});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    picture = json['picture'];
    gender = json['gender'];
    email = json['email'];
    dateOfBirth = json['dateOfBirth'];
    phone = json['phone'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    registerDate = json['registerDate'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['picture'] = this.picture;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['dateOfBirth'] = this.dateOfBirth;
    data['phone'] = this.phone;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['registerDate'] = this.registerDate;
    data['updatedDate'] = this.updatedDate;
    return data;
  }

  Future getAllUser({int page = 0, String query = ''}) async {
    var result;
    Response response = await get(
      Uri.parse('https://dummyapi.io/data/v1/user' +
          '?page=' +
          page.toString() +
          '&query=' +
          query),
      headers: {'app-id': '61151dc619e074b995f40062'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print('User data');
      print(response.body);

      List<User> users = [];
      users =
          List<User>.from(responseData['data'].map((x) => User.fromJson(x)));

      return {
        'data': users,
      };
    } else {
      result = {'status': 'false', 'message': 'An error occurred'};
    }

    return result;
  }
}

class Location {
  String? street;
  String? city;
  String? state;
  String? country;
  String? timezone;

  Location({this.street, this.city, this.state, this.country, this.timezone});

  Location.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['street'] = this.street;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['timezone'] = this.timezone;
    return data;
  }
}
