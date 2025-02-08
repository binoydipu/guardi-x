/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learningflutter/services/cloud/cloud_note.dart';
import 'package:learningflutter/services/cloud/cloud_storage_exception.dart';
import 'package:learningflutter/services/cloud/cloud_storage_constants.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) => notes
      .snapshots() // notes.snapshots(): Listens for real-time updates to the Firestore collection.
      .map((event) => event
          .docs // .map((event) => event.docs...): Transforms each snapshot into a list of documents.
          .map((doc) => CloudNote.fromSnapshot(
              doc)) // .map((doc) => CloudNote.fromSnapshot(doc)): Converts Firestore documents into CloudNote objects.
          .where((note) =>
              note.ownerUserId ==
              ownerUserId)); // .where((note) => note.ownerUserId == ownerUserId): Filters notes to only include those belonging to the specified ownerUserId.

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            // .then((value) => value.docs.map(...)): Converts the fetched documents into a list of CloudNote objects.
            (value) => value.docs.map(
              (doc) => CloudNote.fromSnapshot(doc),
              /*(doc) {
                return CloudNote(
                  documentId: doc.id,
                  ownerUserId: doc.data()[ownerUserIdFieldName] as String,
                  text: doc.data()[textFieldName] as String,
                );
              },*/
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });

    final fetchedNote = await document.get();

    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
*/