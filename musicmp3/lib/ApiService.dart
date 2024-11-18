import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://your_backend_url/api'; // Replace with your backend URL

  // Function to add a song to an album
  static Future<void> addSongToAlbum(String albumId, String songId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/albums/add-song'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'albumId': albumId, 'songId': songId}),
    );

    if (response.statusCode == 200) {
      print('Song added to album successfully');
    } else {
      throw Exception('Failed to add song to album');
    }
  }

  // Function to get songs from an album
  static Future<List<Map<String, dynamic>>> getSongsFromAlbum(String albumId) async {
    final response = await http.get(Uri.parse('$baseUrl/albums/$albumId/songs'));

    if (response.statusCode == 200) {
      List<dynamic> songs = json.decode(response.body);
      return songs.map((song) => song as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to fetch songs from album');
    }
  }
}
