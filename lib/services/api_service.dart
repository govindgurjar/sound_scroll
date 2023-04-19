import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../model/news_model.dart';

List<String> listOfCategory = [
  "all",
  "business",
  "sports",
  "science",
  "technology",
  "startup",
  "world",
  "politics",
  "entertainment",
  "automobile",
  "national",
  "miscellaneous",
  "hatke",
];

class MyApiService {
  String BASE_URL = 'https://inshorts.deta.dev/news?category=';

  Future<NewsData?> apiGet(int catIndex) async {
    NewsData? newsData;

    final response = await http.get(Uri.parse(BASE_URL + listOfCategory[catIndex]));

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> bodyData = jsonDecode(response.body);
        newsData = NewsData.fromJson(bodyData);

        log(newsData.success.toString());
      } catch (e) {
        log(e.toString());
      }
    } else {
      return null;
    }

    // log(newsData.data!.length.toString());

    return newsData;
  }
}
