import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Importing the Audioplayer package

class MusicPlayerPage extends StatefulWidget {
  final String songUrl;  // URL or path of the song
  final String songName;
  final String artistName;
  final String albumArt;  // URL or path to the song's album image

  MusicPlayerPage({
    required this.songUrl,
    required this.songName,
    required this.artistName,
    required this.albumArt,
  });

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  double currentPosition = 0.0;
  double songLength = 1.0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Setting up the audio player listener
    _audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        currentPosition = duration.inSeconds.toDouble();
      });
    });

    // Setting up the audio player listener to get the total song duration
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        songLength = duration.inSeconds.toDouble();
      });
    });

    // Start playing the song when the page is opened
    _playSong();
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();  // Dispose the player when the page is closed
  }

  void _playSong() async {
    await _audioPlayer.play(widget.songUrl);
    setState(() {
      isPlaying = true;
    });
  }

  void _pauseSong() async {
    await _audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

  void _stopSong() async {
    await _audioPlayer.stop();
    setState(() {
      isPlaying = false;
      currentPosition = 0.0;
    });
  }

  void _seekToPosition(double value) {
    _audioPlayer.seek(Duration(seconds: value.toInt()));
  }

  void _nextSong() {
    // Add logic for moving to the next song
    // For now, just stop the current song
    _audioPlayer.stop();
    setState(() {
      currentPosition = 0.0;
      isPlaying = false;
    });
  }

  void _previousSong() {
    // Add logic for moving to the previous song
    // For now, just stop the current song
    _audioPlayer.stop();
    setState(() {
      currentPosition = 0.0;
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Now Playing')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Song Image
          Image.network(
            widget.albumArt, // Can replace with Image.asset if you have local images
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20),
          // Song and Artist Name
          Text(widget.songName, style: TextStyle(fontSize: 24, color: Colors.white)),
          Text(widget.artistName, style: TextStyle(color: Colors.white)),
          SizedBox(height: 20),

          // Song Progress (Slider)
          Slider(
            value: currentPosition,
            min: 0.0,
            max: songLength,
            onChanged: _seekToPosition,
            activeColor: Colors.green,
            inactiveColor: Colors.white,
          ),

          // Play / Pause Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.skip_previous, color: Colors.white),
                onPressed: _previousSong,
              ),
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: isPlaying ? _pauseSong : _playSong,
              ),
              IconButton(
                icon: Icon(Icons.skip_next, color: Colors.white),
                onPressed: _nextSong,
              ),
            ],
          ),

          // Volume Control
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.volume_down, color: Colors.white),
              Slider(
                value: 0.5,  // Volume Control Slider (add your volume functionality here)
                min: 0.0,
                max: 1.0,
                onChanged: (value) {
                  _audioPlayer.setVolume(value);
                },
                activeColor: Colors.green,
                inactiveColor: Colors.white,
              ),
              Icon(Icons.volume_up, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}
