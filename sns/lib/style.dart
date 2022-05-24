import 'package:flutter/material.dart';

const titleFont = 'Billabong';
const regularFont = 'NotoSansJP_Medium';
const boldFont = 'NotoSansJP_Bold';

// テーマ
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: Colors.white30,
    ),
  ),
  primaryIconTheme: const IconThemeData(
    color: Colors.white,
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  fontFamily: regularFont,
);

final lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: Colors.white,
      onPrimary: Colors.black,
    ),
  ),
  primaryIconTheme: const IconThemeData(
    color: Colors.black,
  ),
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),
  fontFamily: regularFont,
);

// Login
const loginTitleTextStyle = TextStyle(fontFamily: titleFont, fontSize: 48.0);

// Post
const postCaptionTextStyle = TextStyle(fontFamily: regularFont, fontSize: 14.0);
const postLocationTextStyle =
    TextStyle(fontFamily: regularFont, fontSize: 16.0);

// Feed
const userCardTitleTextStyle = TextStyle(fontFamily: boldFont, fontSize: 14.0);
const userCardSubTitleTextStyle =
    TextStyle(fontFamily: regularFont, fontSize: 12.0);

const numberOfLikesTextStyle =
    TextStyle(fontFamily: regularFont, fontSize: 14.0);

const numberOfCommentsTextStyle =
    TextStyle(fontFamily: regularFont, fontSize: 13.0, color: Colors.grey);

const timeAgoTextStyle =
    TextStyle(fontFamily: regularFont, fontSize: 10.0, color: Colors.grey);

const commentNameTextStyle = TextStyle(fontFamily: boldFont, fontSize: 13.0);
const commentContentTextStyle =
    TextStyle(fontFamily: regularFont, fontSize: 13.0);

// Comments
const commentInputTextStyle =
    TextStyle(fontFamily: regularFont, fontSize: 14.0);

// Profile
const profileRecordScoreTextStyle =
    TextStyle(fontFamily: boldFont, fontSize: 20.0);

const profileRecordTitleTextStyle =
    TextStyle(fontFamily: regularFont, fontSize: 14.0);

const changeProfilePhotoTextStyle = TextStyle(
    fontFamily: regularFont, fontSize: 18.0, color: Colors.blueAccent);

const editProfileTitleTextStyle =
    TextStyle(fontFamily: regularFont, fontSize: 14.0);

const profileBioTextStyle = TextStyle(fontFamily: regularFont, fontSize: 13.0);

// Search
const searchPageAppBarTitleTextStyle =
    TextStyle(fontFamily: regularFont, color: Colors.grey);
