import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      home: MusicPlayerPage(),
    );
  }
}

class MusicPlayerPage extends StatefulWidget {
  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  final _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  final Duration _position = Duration.zero;

  final List<Map<String, dynamic>> _playlist = [
    {
      'title': 'Song 1',
      'artist': 'Artist 1',
      'albumArt': 'assets/album_art_1.jpg',
      'url': 'https://example.com/song1.mp3',
    },
    {
      'title': 'Song 2',
      'artist': 'Artist 2',
      'albumArt': 'assets/album_art_2.jpg',
      'url': 'https://example.com/song2.mp3',
    },
    // Add more songs to the playlist
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.PLAYING) {
        setState(() {
          _isPlaying = true;
        });
      } else if (state == PlayerState.PAUSED || state == PlayerState.STOPPED) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  void _playPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(_playlist[_currentIndex]['url']);
    }
  }

  void _skipForward() {
    if (_currentIndex < _playlist.length - 1) {
      _currentIndex++;
      _audioPlayer.play(_playlist[_currentIndex]['url']);
    }
  }

  void _skipBackward() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _audioPlayer.play(_playlist[_currentIndex]['url']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(_playlist[_currentIndex]['albumArt']),
          const SizedBox(height: 16),
          Text(
            _playlist[_currentIndex]['title'],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _playlist[_currentIndex]['artist'],
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 32),
          Slider(
            value: _position.inMilliseconds.toDouble(),
            min: 0,
            max: _duration.inMilliseconds.toDouble(),
            onChanged: (value) {
              final position = Duration(milliseconds: value.toInt());
              _audioPlayer.seek(position);
            },
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: _skipBackward,
              ),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: _playPause,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: _skipForward,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
