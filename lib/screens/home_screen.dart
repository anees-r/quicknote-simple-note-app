import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_note_app/app_assets.dart';
import 'package:simple_note_app/services/firestore_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // initializing text controller
  final TextEditingController _textController = TextEditingController();

  // initializing a firestoreservice object
  final FirestoreService _firestoreService = FirestoreService();

  //open new note box
  void openNoteBox({String? docID}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                cursorColor: Theme.of(context).colorScheme.secondaryContainer,
                controller: _textController,
                style: TextStyle(
                  fontFamily: "Hoves",
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Add a new Note",
                    hintStyle: TextStyle(
                      fontFamily: "Hoves",
                      fontSize: 16,
                      color: Theme.of(context)
                          .colorScheme
                          .secondaryContainer
                          .withOpacity(0.4),
                    )),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (_textController.text.isEmpty) {
                      // Show error SnackBar if input is empty

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "A Note cannot be empty!",
                            style: TextStyle(
                              fontFamily: "Hoves",
                              fontSize: 16,
                              color: AppAssets.darkBackgroundColor,
                            ),
                          ),
                          backgroundColor: AppAssets.mainIconColor,

                          // Margin from the top and sides
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    if (docID == null) {
                      _firestoreService.addNote(_textController.text);
                    }

                    // update note
                    else {
                      _firestoreService.updateNote(docID, _textController.text);
                    }
                    // clear the text field
                    _textController.clear();
                    // close note box
                    Navigator.pop(context);
                  },
                  child: const Text("Add"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    foregroundColor: Theme.of(context)
                        .colorScheme
                        .primaryContainer, // Background color
                    shadowColor: Colors.black.withOpacity(0.5), // Shadow color
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: _buildAppBar(),
      body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              // Text(
              //   "My Notes",
              //   style: TextStyle(
              //     fontFamily: "Hoves",
              //     fontSize: 20,
              //     fontWeight: FontWeight.bold,
              //     color: Theme.of(context).colorScheme.secondaryContainer,
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              _buildNoteList()
            ],
          )),
      floatingActionButton: _buildFloatingButton(),
    );
  }

  Expanded _buildNoteList() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: _firestoreService.getNotes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List notesList = snapshot.data!.docs;

              return ListView.builder(
                  itemCount: notesList.length,
                  itemBuilder: (context, index) {
                    // get individual document
                    DocumentSnapshot document = notesList[index];
                    String docID = document.id;

                    // get note text from document
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    String noteText = data["note"];

                    // display in list view
                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: ListTile(
                          leading: Icon(
                            Icons.circle,
                            size: 10,
                            color: AppAssets.mainIconColor,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          tileColor:
                              Theme.of(context).colorScheme.tertiaryContainer,
                          title: Text(
                            noteText,
                            style: TextStyle(
                              fontFamily: "Hoves",
                              fontSize: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // update icon
                              IconButton(
                                onPressed: () => openNoteBox(docID: docID),
                                icon: SvgPicture.asset(
                                  AppAssets.editIcon,
                                  height: 30,
                                  width: 30,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer
                                      .withOpacity(0.5),
                                ),
                              ),
                              // delete button
                              IconButton(
                                onPressed: () =>
                                    _firestoreService.deleteNote(docID),
                                icon: SvgPicture.asset(
                                  AppAssets.deleteIcon,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer
                                      .withOpacity(0.5),
                                ),
                              )
                            ],
                          )),
                    );
                  });
            } else {
              // return const Text("No notes");
              return Center(
                child: Text(
                  "No Notes!",
                  style: TextStyle(
                    fontFamily: "Hoves",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                ),
              );
            }
          }),
    );
  }

  // build a floating action button
  FloatingActionButton _buildFloatingButton() {
    return FloatingActionButton(
      onPressed: () {
        openNoteBox();
      },
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: SvgPicture.asset(
        AppAssets.plusIcon,
        height: 20,
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }

  // build an app bar
  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      title: Center(
        child: Text(
          "QuickNote",
          style: TextStyle(
            fontFamily: "Hoves",
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
        ),
      ),
    );
  }
}
