library constants;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wp_flutter_app/models/siteInformation.dart';

const String WordpressUrl = "https://www.houstonzoo.org/";
const int PostsPerPage = 10;
const String SiteLogo = "assets/logo.png";
const Color AppBarBackgroundColor = Color.fromRGBO(0, 103, 71, 1);
const Color PageBackgroundColor = Colors.white;

const Color RefreshBackgroundColor = Color.fromRGBO(0, 103, 71, 1);
const Color RefreshColor = Colors.white;

List<Department> emails = [
  Department("Membership", "membership@houstonzoo.org"), 
  Department("Development", "development@houstonzoo.org"),
  Department("Volunteers", "volunteer@houstonzoo.org")
];

List<SocialMedia> socialMedia = [
  SocialMedia(FontAwesomeIcons.facebook, "https://www.facebook.com/houstonzoo"),
  SocialMedia(FontAwesomeIcons.twitter, "https://twitter.com/houstonzoo"),
  SocialMedia(FontAwesomeIcons.instagram, "https://www.instagram.com/houstonzoo/"),
  SocialMedia(FontAwesomeIcons.youtube, "https://www.youtube.com/user/houstonzoo")
];

SiteInformation siteInformation = SiteInformation(
  '6200 Hermann Park Drive, Houston, TX 77030', // must use the same pattern (splitting everything with comma ",")
  'https://maps.app.goo.gl/AQw4KYKxHTesMhmL9',
  'The Houston Zoo connects communities with animals to inspire action to save wildlife and is committed to being a leader in the global effort to save animals in the wild. We are home to over 6,000 permanent residents (our animals) for whom we provide the highest standard in animal care. Each year, we welcome over two million guests who come to experience our incredible animals and ecosystems, and through their admission ticket or membership, help us fund the protection efforts of the counterparts of every species at the Zoo, in the wild.', 
  'E. William Barnett', 
  '713-533-6500', 
  '6944175828', 
  emails,
  socialMedia);