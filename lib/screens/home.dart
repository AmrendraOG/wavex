import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isPlaying = false;
  final player = AudioPlayer();
  List<Map<String, String>> songs = [
    {"title": "I Really Do", "artists": "Karan Aujla, Ikky"},
    {"title": "52 Bars", "artists": "Karan Aujla, Ikky"},
    {"title": "Winning Speech", "artists": "Karan Aujla, MXRCI"},
  ];
  late String songName = songs[0]["title"]!;
  late String artistName = songs[0]["artists"]!;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();

    player.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
    });

    player.onPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void playMusic() async {
      if (isPlaying) {
        await player.pause();
        setState(() {
          isPlaying = false;
        });
      } else {
        await player.play(UrlSource(
          'https://github.com/AmrendraOG/wavex/raw/refs/heads/master/assets/songs/$songName.mp3',
        ));
        setState(() {
          isPlaying = true;
        });
      }
    }

    return Container(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          title: Text("WaveX", style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.black38,
          foregroundColor: Colors.cyan,
          centerTitle: true,
        ),
        backgroundColor: Colors.black87,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://raw.githubusercontent.com/AmrendraOG/wavex/refs/heads/master/assets/covers/$songName.jpg',
                  width: 240,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 32),
                      child: Text(
                        songName,
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 32),
                      child: Text(
                        artistName,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
              Slider(
                activeColor: Colors.cyan,
                min: 0,
                max: _duration.inSeconds.toDouble(),
                value: _position.inSeconds
                    .clamp(0, _duration.inSeconds)
                    .toDouble(),
                onChanged: (value) async {
                  final newPosition = Duration(seconds: value.toInt());
                  await player.seek(newPosition);
                  setState(() {
                    _position = newPosition;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () async {
                      Duration position =
                          await player.getCurrentPosition() ?? Duration.zero;
                      Duration newPos = position - Duration(seconds: 10);
                      if (newPos.isNegative) newPos = Duration.zero;
                      await player.seek(newPos);
                    },
                    icon: Icon(Icons.fast_rewind),
                    iconSize: 40,
                    style: IconButton.styleFrom(foregroundColor: Colors.cyan),
                  ),
                  IconButton(
                    onPressed: playMusic,
                    icon: isPlaying
                        ? Icon(Icons.pause)
                        : Icon(Icons.play_arrow),
                    iconSize: 48,
                    style: IconButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.cyan,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      Duration position =
                          await player.getCurrentPosition() ?? Duration.zero;
                      Duration newPos = position + Duration(seconds: 10);
                      await player.seek(newPos);
                    },
                    icon: Icon(Icons.fast_forward),
                    iconSize: 40,
                    style: IconButton.styleFrom(foregroundColor: Colors.cyan),
                  ),
                ],
              ),
              Container(
                height: 180,
                color: Colors.black26,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.music_note, color: Colors.cyan),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            songs[index]["title"]!,
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            songs[index]["artists"]!,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      onTap: () async {
                        songName = songs[index]["title"]!;
                        artistName = songs[index]["artists"]!;
                        await player.stop();
                        await player.play(
                          UrlSource(
                            'https://github.com/AmrendraOG/wavex/raw/refs/heads/master/assets/songs/$songName.mp3',
                          ),
                        );
                        setState(() {
                          isPlaying = true;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
