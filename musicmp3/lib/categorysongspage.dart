import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'ApiService.dart'; // Import the ApiService for HTTP requests

class CategorySongsPage extends StatefulWidget {
  @override
  _CategorySongsPageState createState() => _CategorySongsPageState();
}

class _CategorySongsPageState extends State<CategorySongsPage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> _songs = [];
  Map<String, List<SongModel>> _albums = {
    'Liked Songs': [],
    'Favourite': [],
    'Recently Played': [],
    'All Time Favourite': [],
    'Top Artists': [],
    'Weekend Chill': [],
  };

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  Future<void> fetchSongs() async {
    if (await Permission.storage.request().isGranted) {
      List<SongModel> songs = await _audioQuery.querySongs();
      setState(() {
        _songs = songs;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Storage permission denied")),
      );
    }
  }

  void _addToAlbum(String albumId, SongModel song) async {
    try {
      await ApiService.addSongToAlbum(albumId, song.id.toString()); // Use API to add song to album
      setState(() {
        _albums[albumId]?.add(song);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${song.title} added to album")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add song to album")),
      );
    }
  }

  void _showAlbumOptions(BuildContext context, SongModel song) async {
    // Fetch albums from backend
    final albums = await ApiService.getSongsFromAlbum('albumId'); // This should be fetched dynamically

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black,
          child: ListView(
            children: albums.map((album) {
              return ListTile(
                title: Text(album['name'], style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _addToAlbum(album['_id'], song); // Add the song to the selected album
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Category Songs", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.black,
      body: _songs.isEmpty
          ? Center(child: Text("No songs found!", style: TextStyle(color: Colors.white)))
          : ListView.builder(
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          final song = _songs[index];
          return ListTile(
            leading: QueryArtworkWidget(
              id: song.id,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: Icon(Icons.music_note, color: Colors.green),
            ),
            title: Text(song.title, style: TextStyle(color: Colors.white)),
            subtitle: Text(song.artist ?? "Unknown Artist", style: TextStyle(color: Colors.grey)),
            trailing: IconButton(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onPressed: () => _showAlbumOptions(context, song),
            ),// In your CategorySongsPage
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MusicPlayerPage(
                    songUrl: song.uri.toString(), // Assuming you have song URI
                    songName: song.title,
                    artistName: song.artist ?? "Unknown Artist",
                    albumArt: 'URL or local path to song image',  // Set the image path
                  ),
                ),
              );
            },

          );
        },
      ),
    );
  }
}
