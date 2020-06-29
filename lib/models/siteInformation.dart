import 'package:flutter/cupertino.dart';

class SiteInformation {
  SiteInformation(
    this.address,
    this.googleMapLocation,
    this.description,
    this.manager,
    this.telephone,
    this.mobile,
    this.emails,
    this.socialMedia
  );

  final String address;
  final String googleMapLocation;
  final String description;
  final String telephone;
  final String mobile;
  final List<Department> emails;
  final List<SocialMedia> socialMedia;
  final String manager;
}

class Department {
  Department(
    this.title,
    this.link
  );

  final String title;
  final String link;
}

class SocialMedia {
  SocialMedia(
    this.icon,
    this.link
  );

  final IconData icon;
  final String link;
}
