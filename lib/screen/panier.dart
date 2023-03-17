import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PanierPage extends StatefulWidget {
  const PanierPage({Key? key}) : super(key: key);

  @override
  _PanierPageState createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  final Stream<QuerySnapshot> _PanierPageStream = FirebaseFirestore.instance
      .collection("Panier")
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection("items")
      .snapshots();

  double _calculateTotal(QuerySnapshot snapshot) {
    double total = 0.0;
    snapshot.docs.forEach((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      double prix = data['prix'].toDouble();
      total += prix;
    });
    return total;
  }

  void _supprimerProduit(DocumentSnapshot document) {
    FirebaseFirestore.instance
        .collection("Panier")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("items")
        .doc(document.id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Panier'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _PanierPageStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Une erreur a été détectée');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Chargement");
          }

          double total = _calculateTotal(snapshot.data!);

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                    return ListTile(
                      title: Text(data['titre'] ?? ''),
                      subtitle: Text(data['taille'] ?? ''),
                      leading: SizedBox(
                        width: 100,
                        child: data['image'] != null
                            ? Image.network(data['image'])
                            : SizedBox.shrink(),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${data['prix']} €",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _supprimerProduit(document),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$total €',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
