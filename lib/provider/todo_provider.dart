import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todo_app/services/todo_services.dart';

import '../utlis/snackbar_helper.dart';


class TodoProvider with ChangeNotifier {
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get items => _items;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
   Future<void> fetchTodo(BuildContext context) async  {
    setLoading(true);
    try {
    final response = await TodoServices.fetchTodos();
    if (response != null) {
      _items = List<Map<String, dynamic>>.from(response);
    } else {
      showErrorMessage(context, message: 'Something went wrong');
    }
  } on SocketException catch (e) {
    // Handle network errors
    showErrorMessage(context, message: 'Network error: ${e.message}');
  } on HttpException catch (e) {
    // Handle HTTP protocol errors
    showErrorMessage(context, message: 'HTTP error: ${e.message}');
  } on FormatException catch (e) {
    // Handle data format errors
    showErrorMessage(context, message: 'Data format error: ${e.message}');
  } catch (e) {
    // Handle any other errors
    showErrorMessage(context, message: 'An unexpected error occurred: $e');
  }finally {
    setLoading(false);
  }
  }

  Future<void> deleteById(BuildContext context, String id) async {
    final isSuccess = await TodoServices.deleteById(id);
    if (isSuccess) {
      _items = _items.where((element) => element['_id'] != id).toList();
       CircularProgressIndicator(
          backgroundColor: Colors.grey,
        );
      notifyListeners();
    } else {
      // Handle error
      showErrorMessage(context, message: 'Unable to delete');
    }
  }

  void setItems(List<Map<String, dynamic>> newItems) {
    _items = newItems;
    notifyListeners();
  }

  void addItem(Map<String, dynamic> item) {
    _items.add(item);
    notifyListeners();
  }

  void updateItem(Map<String, dynamic> item) {
    int index = _items.indexWhere((element) => element['_id'] == item['_id']);
    if (index != -1) {
      _items[index] = item;
      notifyListeners();
    }
  }
}

