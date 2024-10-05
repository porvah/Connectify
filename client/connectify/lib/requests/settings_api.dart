import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class SettingsApi {
  final _url = dotenv.env['API_URL'];

  Future<bool> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse(_url! + 'logout/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{'token': token}),
      );

      if (response.statusCode == 200) {
        print('Data posted: ${response.body}');
        return true;
      } else {
        print(
            'Failed with status: ${response.statusCode}, body: ${response.body}');
        throw Exception('Failed to log out');
      }
    } catch (e) {
      print('Log out failed! Error: $e');
      return false;
    }
  }

  Future<bool> deleteAccount(String token) async {
    try {
      final response = await http.post(
        Uri.parse(_url! + 'deleteaccount/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{'token': token}),
      );

      if (response.statusCode == 200) {
        print('Data posted: ${response.body}');
        return true;
      } else {
        print(
            'Failed with status: ${response.statusCode}, body: ${response.body}');
        throw Exception('Failed to delete account');
      }
    } catch (e) {
      print('Delete account failed! Error: $e');
      return false;
    }
  }

  Future<bool> uploadImage(File imageFile, String phone) async {
    var url = Uri.parse(_url! + 'uploadphoto/');

    var request = http.MultipartRequest('POST', url);
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    request.fields['phone'] = phone;

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        return true;
      } else {
        print('Image upload failed with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Image upload error: $e');
      return false;
    }
  }

  Future<File?> getImage(String phone) async {
    try {
      final response = await http.post(
        Uri.parse(_url! + 'getimage/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{'phone': phone}),
      );

      if (response.statusCode == 200) {
        print('Data posted: ${response.body}');
        Map<String, dynamic> data = jsonDecode(response.body);
        String? imageUrl = data['image'];
        print(imageUrl);
        return await _downloadImage(imageUrl);
      } else {
        print('Failed to get image with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Get image failed! Error: $e');
      return null;
    }
  }

  Future<File?> _downloadImage(String? imageUrl) async {
    if (imageUrl == null) return null;

    try {
      var response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        var directory = await getApplicationDocumentsDirectory();
        var filePath = path.join(directory.path, 'profile_image.png');
        var file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        print(file);
        return file;
      } else {
        print('Failed to download image with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Download failed! Error: $e');
      return null;
    }
  }
}
