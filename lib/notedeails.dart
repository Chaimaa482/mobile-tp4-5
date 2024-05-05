import 'package:flutter/material.dart';
import 'package:notes_app/note.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tts/flutter_tts.dart';

class NoteDetailsScreen extends StatefulWidget {
  final Note note;

  const NoteDetailsScreen({Key? key, required this.note}) : super(key: key);

  @override
  _NoteDetailsScreenState createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 240, 250),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isLandscape
                  ? const SizedBox(height: 0)
                  : const SizedBox(height: 60),
              isLandscape
                  ? const Image(
                      image: AssetImage('assets/girl.png'), width: 100)
                  : const Image(
                      image: AssetImage('assets/girl.png'), width: 150),
              isLandscape
                  ? const SizedBox(height: 20)
                  : const SizedBox(height: 60),
              const Text(
                'Belbachir Chaimaa',
                style: TextStyle(fontSize: 14),
              ),
              isLandscape
                  ? const SizedBox(height: 10)
                  : const SizedBox(height: 10),
              Text(
                widget.note.content,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              Text(
                'Created: ${DateFormat('yyyy-MM-dd – kk:mm').format(widget.note.dateTime)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              isLandscape
                  ? const SizedBox(height: 20)
                  : const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  if (!isPlaying) {
                    _speak(widget.note.content);
                    setState(() {
                      isPlaying = true;
                    });
                  } else {
                    _stop();
                    setState(() {
                      isPlaying = false;
                    });
                  }
                },
                child: Text(isPlaying ? 'Stop Reading' : 'Read Note'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage('en-EN');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  Future<void> _stop() async {
    await flutterTts.stop();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}
