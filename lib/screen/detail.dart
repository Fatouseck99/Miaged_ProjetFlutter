import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DetailPage extends StatefulWidget {
  final String id;

  DetailPage({required this.id, });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late DocumentSnapshot document;
  late final Stream<DocumentSnapshot> _vetementStream;

  @override
  void initState() {
    super.initState();
    _vetementStream = FirebaseFirestore.instance
        .collection('Vetements')
        .doc(widget.id)
        .snapshots();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du vêtement'),
      ),
      body: Center(
        child: StreamBuilder<DocumentSnapshot>(
          stream: _vetementStream,
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Une erreur a été détectée');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Chargement");
            }

            document = snapshot.data!;
            Map<String, dynamic> data =
            document.data()! as Map<String, dynamic>;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: Image.network(data['image']),
                ),
                Text(
                  data['titre'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Text(
                  'Taille: ${data['taille']}',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Marque: ${data['marque']}',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Etat: ${data['état']}',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  '${data['prix']} €',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Retour'),
                    ),
                    ElevatedButton(
                      onPressed: () => _ajouterAuPanier(data),
                      child: Text('Ajouter au panier'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

//ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                             content: Text(
//                                 'Le vêtement a été ajouté au panier')));
  Future<void> _ajouterAuPanier(Map<String, dynamic> data) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final CollectionReference panierCollection = FirebaseFirestore.instance
          .collection('Panier')
          .doc(user!.email)
          .collection('items');

      await panierCollection.add({
        'titre': data['titre'],
        'marque': data['marque'],
        'taille': data['taille'],
        'prix': data['prix'],
        'image': data['image'],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Le vêtement a été ajouté au panier'),
        ),
      );
    } catch (e) {
      print('Erreur lors de l\'ajout au panier: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Une erreur est survenue, veuillez réessayer.'),
        ),
      );
    }
  }
}



