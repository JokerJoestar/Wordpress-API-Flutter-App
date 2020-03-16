library constants;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const String WordpressUrl = "https://www.houstonzoo.org/";
const int PostsPerPage = 10;
const String SiteLogo = "assets/logo.png";
const Color AppBarBackgroundColor = Color.fromRGBO(0, 103, 71, 1);
const Color PageBackgroundColor = Colors.white;

const Color RefreshBackgroundColor = Color.fromRGBO(0, 103, 71, 1);
const Color RefreshColor = Colors.white;

const List<dynamic> CategoryList = [
  ["Animal Care, Training and Enrichment", FontAwesomeIcons.briefcaseMedical, 80],
  ["Bird News", FontAwesomeIcons.dove, 245],
  ["Collegiate Conservation Program", FontAwesomeIcons.graduationCap, 247],
  ["Dining and Shopping at the Zoo", FontAwesomeIcons.shoppingBag, 248],
  ["Chimpanzee", "assets/categories/chimpanzie.png", 255]
];