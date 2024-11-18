import 'package:flutter/material.dart';
import 'package:musicmp3/categorysongspage.dart';
import 'package:musicmp3/apiService.dart'; // Assuming your API service is in this file

class HomePage extends StatelessWidget {
  final String username;

  HomePage({required this.username});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, $username', style: TextStyle(fontSize: 24, color: Colors.green)),
            SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                'Liked Songs',
                'Favourite',
                'Recently Played',
                'All Time Favourite',
                'Top Artists',
                'Weekend Chill',
              ].map((text) => GestureDetector(
                onTap: () async {
                  // Fetch songs from backend based on category
                  List<Map<String, dynamic>> songs = await ApiService.getSongsFromAlbum(text);  // Replace 'text' with dynamic album/category fetch
                  // Pass the fetched songs to the CategorySongsPage
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => CategorySongsPage(
                      category: text,
                      songs: songs,
                    ),
                  ));
                },
                child: Card(
                  color: Colors.grey[900],
                  elevation: 4,
                  child: Center(child: Text(text, style: TextStyle(color: Colors.green))),
                ),
              )).toList(),
            ),
            SizedBox(height: 20),
            Text('Songs', style: TextStyle(fontSize: 18, color: Colors.green)),
            Container(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 20,  // Replace this with your dynamic list of songs
                itemBuilder: (context, index) => Container(
                  width: 120,
                  margin: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/song_image.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text('Song ${index + 1}', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Example: Navigate to a page for adding songs to an album
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AddSongPage(), // This page allows you to select albums and songs to add
                ));
              },
              child: Text('Add Song to Album', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(primary: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
