import 'package:flutter/material.dart';
import 'package:notes_app/note.dart';
import 'package:notes_app/notedeails.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  Note? selectedNote;
  List<Note> notes = [];
  late int index;

  @override
  void initState() {
    super.initState();
    notes.add(Note('Hey how are you there'));
  }

  @override
  Widget build(BuildContext context) {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final int maxCharacters = isLandscape ? 15 : 10;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 231, 255),
        title: const Text('Notes'),
      ),
      body: isLandscape
          ? Row(
              children: [
                Expanded(
                  flex: 1,
                  child: notesListWidget(notes, maxCharacters, isLandscape),
                ),
                Expanded(
                  flex: 2,
                  child: selectedNote != null
                      ? NoteDetailsScreen(note: selectedNote!)
                      : const Text(''), // Fragment for details
                ),
              ],
            )
          : notesListWidget(notes, maxCharacters, isLandscape),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String noteContent = '';
              return AlertDialog(
                title: const Text('Add Note'),
                content: TextField(
                  onChanged: (value) {
                    noteContent = value;
                  },
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (noteContent.isNotEmpty) {
                        setState(() {
                          notes.add(Note(noteContent));
                        });
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, int index, bool isLandscape) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Note"),
          content: const Text("You really want to delete this note ?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  notes.removeAt(index);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Note Deleted")),
                );
                if (isLandscape) {
                  selectedNote = null;
                }
              },
              child: const Text("Delele"),
            ),
          ],
        );
      },
    );
  }

  Widget notesListWidget(
      List<Note> notes, int maxCharacters, bool isLandscape) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            isLandscape
                ? setState(() {
                    selectedNote = notes[index];
                  })
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteDetailsScreen(
                        note: notes[index],
                      ),
                    ),
                  );
          },
          onLongPress: () {
            _showDeleteConfirmationDialog(context, index, isLandscape);
          },
          leading: const Image(image: AssetImage('assets/girl.png')),
          title: const Text('Belbachir Chaimaa'),
          subtitle: Text(
            notes[index].content.length <= maxCharacters
                ? notes[index].content
                : '${notes[index].content.substring(0, maxCharacters)}...',
            style: const TextStyle(
                fontSize: 14, color: Color.fromARGB(255, 119, 119, 119)),
          ),
        );
      },
    );
  }
}
