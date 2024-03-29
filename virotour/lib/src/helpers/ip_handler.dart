import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class IPHandler {
  static const List<String> _ipsToTry = [
    'virotour2023-flask-server.azurewebsites.net',
    '192.168.1.180',
    '127.0.0.1'
  ];
  static const int _port = 8081;

  Future<http.Response> get(String endpoint) async {
    for (final String ip in _ipsToTry) {
      String url;

      if (ip.contains('azurewebsites.net')) {
        url = 'https://$ip$endpoint';
      } else {
        url = 'http://$ip:$_port$endpoint';
      }

      try {
        final http.Response response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          // The request was successful, return the response
          return response;
        }
      } catch (e) {
        debugPrint('Error connecting to $url: $e');
        throw 'Error connecting to $url: $e';
      }
    }

    // If we reach this point, none of the IPs worked
    return http.Response('Could not connect to any IP', 404);
  }

  Future<http.Response> post(
    String endpoint, [
    Map<String, String>? options,
  ]) async {
    for (final String ip in _ipsToTry) {
      final String url = 'http://$ip:$_port$endpoint';

      try {
        final http.Response response = await http.post(
          Uri.parse(url),
          headers: options!['headers'] as Map<String, String>?,
          body: options['body'],
          encoding: options['encoding'] as Encoding?,
        );

        if (response.statusCode == 200) {
          // The request was successful, return the response
          return response;
        }
      } catch (e) {
        throw 'Error connecting to $url: $e';
      }
    }

    // If we reach this point, none of the IPs worked
    return http.Response('Could not connect to any IP', 404);
  }

  Future<http.BaseResponse> requestMultipart(
    String endpoint, [
    Map<String, String>? options,
  ]) async {
    for (final String ip in _ipsToTry) {
      final String url = 'http://$ip:$_port$endpoint';

      try {
        final http.MultipartRequest request = http.MultipartRequest(
          'POST',
          Uri.parse(url),
        );

        final response = await request.send();
        if (response.statusCode == 200) {
          // The request was successful, return the response
          return response;
        }
      } catch (e) {
        throw 'Error connecting to $url: $e';
      }
    }

    // If we reach this point, none of the IPs worked
    return http.Response('Could not connect to any IP', 404);
  }
}
