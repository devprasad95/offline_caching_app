import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:offline_caching_app/data_base_helper.dart';
import 'package:offline_caching_app/random_data.dart';
import 'package:http/http.dart' as http;

class RandomProvider extends ChangeNotifier {
  List<RandomData> _randomDatas = [];
  bool _isLoading = false;
  late BuildContext _context;

  List<RandomData> get randomDatas => _randomDatas;
  bool get isLoading => _isLoading;

  void init(BuildContext context) {
    _context = context;
  }

  Future<void> fetchDatas() async {
    try {
      _isLoading = true;
      notifyListeners();

      final dbHelper = DatabaseHelper.instance;
      List<Map<String, dynamic>> dbData = await dbHelper.queryAllRows();
      if (dbData.isNotEmpty) {
        _randomDatas = dbData.map((item) => RandomData.fromJson(item)).toList();
      }

      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      if (response.statusCode == 200) {
        await dbHelper.clearTable();
        List<dynamic> datas = jsonDecode(response.body);
        List<RandomData> newDatas =
            datas.map((item) => RandomData.fromJson(item)).toList();

        for (var data in newDatas) {
          await dbHelper.insert(data.toJson());
        }
        dbData = await dbHelper.queryAllRows();
        _randomDatas = dbData.map((item) => RandomData.fromJson(item)).toList();
      } else {
        print('failed at 1');
        _showErrorSnackbar();
      }
    } catch (e) {
      print('failed: $e');
      _showErrorSnackbar();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _showErrorSnackbar() {
    ScaffoldMessenger.of(_context).showSnackBar(
      const SnackBar(
        content: Text('Failed to fetch data. Please try again later.'),
      ),
    );
  }
}
