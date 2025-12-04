import 'package:flutter/material.dart';

/// Enum to represent the state of a network request
enum NetworkState { idle, loading, success, error }

/// Model to hold the state and data/error of a network request
class NetworkResponse<T> {
  final NetworkState state;
  final T? data;
  final String? error;
  final String? message;

  NetworkResponse({
    this.state = NetworkState.idle,
    this.data,
    this.error,
    this.message,
  });

  factory NetworkResponse.idle() => NetworkResponse(state: NetworkState.idle);

  factory NetworkResponse.loading() =>
      NetworkResponse(state: NetworkState.loading);

  factory NetworkResponse.success(T data) =>
      NetworkResponse(state: NetworkState.success, data: data);

  factory NetworkResponse.error(String error, {String? message}) =>
      NetworkResponse(
        state: NetworkState.error,
        error: error,
        message: message,
      );

  bool get isLoading => state == NetworkState.loading;
  bool get isError => state == NetworkState.error;
  bool get isSuccess => state == NetworkState.success;
  bool get isIdle => state == NetworkState.idle;
}

/// Provider for managing network state of a single resource
class NetworkStateProvider<T> with ChangeNotifier {
  NetworkResponse<T> _response = NetworkResponse.idle();

  NetworkResponse<T> get response => _response;
  NetworkState get state => _response.state;
  T? get data => _response.data;
  String? get error => _response.error;
  String? get message => _response.message;
  bool get isLoading => _response.isLoading;
  bool get isError => _response.isError;
  bool get isSuccess => _response.isSuccess;

  /// Set to loading state
  void setLoading() {
    _response = NetworkResponse.loading();
    notifyListeners();
  }

  /// Set to success state with data
  void setSuccess(T data) {
    _response = NetworkResponse.success(data);
    notifyListeners();
  }

  /// Set to error state
  void setError(String error, {String? message}) {
    _response = NetworkResponse.error(error, message: message);
    notifyListeners();
  }

  /// Reset to idle state
  void reset() {
    _response = NetworkResponse.idle();
    notifyListeners();
  }

  /// Execute an async operation and update state accordingly
  Future<void> executeAsync(
    Future<T> Function() operation, {
    void Function()? onSuccess,
    void Function(String error)? onError,
  }) async {
    try {
      setLoading();
      final result = await operation();
      setSuccess(result);
      onSuccess?.call();
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      setError(errorMessage);
      onError?.call(errorMessage);
    }
  }
}

/// Provider for managing network state of a list of items
class NetworkListStateProvider<T> with ChangeNotifier {
  NetworkResponse<List<T>> _response = NetworkResponse.idle();

  NetworkResponse<List<T>> get response => _response;
  NetworkState get state => _response.state;
  List<T>? get data => _response.data;
  String? get error => _response.error;
  String? get message => _response.message;
  bool get isLoading => _response.isLoading;
  bool get isError => _response.isError;
  bool get isSuccess => _response.isSuccess;

  /// Set to loading state
  void setLoading() {
    _response = NetworkResponse.loading();
    notifyListeners();
  }

  /// Set to success state with data
  void setSuccess(List<T> data) {
    _response = NetworkResponse.success(data);
    notifyListeners();
  }

  /// Set to error state
  void setError(String error, {String? message}) {
    _response = NetworkResponse.error(error, message: message);
    notifyListeners();
  }

  /// Reset to idle state
  void reset() {
    _response = NetworkResponse.idle();
    notifyListeners();
  }

  /// Execute an async operation and update state accordingly
  Future<void> executeAsync(
    Future<List<T>> Function() operation, {
    void Function()? onSuccess,
    void Function(String error)? onError,
  }) async {
    try {
      setLoading();
      final result = await operation();
      setSuccess(result);
      onSuccess?.call();
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      setError(errorMessage);
      onError?.call(errorMessage);
    }
  }

  /// Append items to the current data
  void appendItems(List<T> items) {
    if (isSuccess && data != null) {
      final updatedList = [...data!, ...items];
      setSuccess(updatedList);
    }
  }

  /// Replace an item in the list
  void updateItem(T item, bool Function(T) predicate) {
    if (isSuccess && data != null) {
      final index = data!.indexWhere(predicate);
      if (index != -1) {
        final updatedList = [...data!];
        updatedList[index] = item;
        setSuccess(updatedList);
      }
    }
  }

  /// Remove an item from the list
  void removeItem(bool Function(T) predicate) {
    if (isSuccess && data != null) {
      final updatedList = data!.where((item) => !predicate(item)).toList();
      setSuccess(updatedList);
    }
  }
}
