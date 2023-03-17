import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appli_miaged/screen/detail.dart';



String _selectedCategory = 'Tous';
class AchatPage extends StatefulWidget {
  @override
  _AchatPageState createState() => _AchatPageState();
}

class _AchatPageState extends State<AchatPage> {
  final Stream<QuerySnapshot> _vetementStream =
  FirebaseFirestore.instance.collection('Vetements').snapshots();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController( // Add a DefaultTabController widget here
      length: 4, // The number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Liste des vêtements'),
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                switch (index) {
                  case 0:
                    _selectedCategory = "Tous";
                    break;
                  case 1:
                    _selectedCategory = "Homme";
                    break;
                  case 2:
                    _selectedCategory = "Femme";
                    break;
                  case 3:
                    _selectedCategory = "Accessoire";
                    break;
                }
              });
            },
            tabs: [
              Tab(text: "Tous"),
              Tab(text: "Homme"),
              Tab(text: "Femme"),
              Tab(text: "Accessoire"),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Vetements(),
            ),
          ],
        ),
      ),
    );
  }
}


class Vetements extends StatefulWidget {
  const Vetements({Key? key}) : super(key: key);

  @override
  _VetementsState createState() => _VetementsState();
}

class _VetementsState extends State<Vetements> {
  final Stream<QuerySnapshot> _vetementsStream =
  FirebaseFirestore.instance.collection('Vetements').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _vetementsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Une erreur a été détectée');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Chargement");
        }

        Query query = FirebaseFirestore.instance.collection('Vetements');
        if (_selectedCategory != 'Tous') {
          query = query.where('categorie', isEqualTo: _selectedCategory);
        }

        return GridView.count(
          crossAxisCount: 2,
          //padding: EdgeInsets.all(16),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: snapshot.data!.docs
              .where((document) =>
          _selectedCategory == 'Tous' ||
              document['categorie'] == _selectedCategory)
              .map((DocumentSnapshot document) {
            Map<String, dynamic> data =
            document.data()! as Map<String, dynamic>;
            String id = document.id;
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DetailPage(id: id)),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Image.network(
                              data['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['titre'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data['taille'],
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "${data['prix']} €",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

