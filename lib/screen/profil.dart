import 'package:appli_miaged/login/login-page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _user;
  TextEditingController _addressController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    DocumentSnapshot snapshot = await _firestore.collection('Users').doc(
        _user.uid).get();
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
    setState(() {
      _addressController.text = userData['adresse'] ?? '';
      _postalCodeController.text = userData['codePostal'] ?? '';
      _cityController.text = userData['ville'] ?? '';
      _selectedDate = (userData['anniversaire'] as Timestamp?)?.toDate();
    });
  }

  Future<void> _saveUserData() async {
    await _firestore.collection('Users').doc(_user.uid).update({
      'adresse': _addressController.text,
      'codePostal': _postalCodeController.text,
      'ville': _cityController.text,
      'anniversaire': _selectedDate != null
          ? Timestamp.fromDate(_selectedDate!)
          : null,
    });
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Données sauvegardées')));
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Informations personnelles',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Login',
              ),
              controller: TextEditingController(text: _user.email),
            ),
            SizedBox(height: 16.0),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
              ),
              controller: TextEditingController(text: '********'),
            ),
            SizedBox(height: 16.0),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Anniversaire',
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate != null
                          ? '${_selectedDate!.day}/${_selectedDate!
                          .month}/${_selectedDate!.year}'
                          : 'Sélectionner une date',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Adresse',
              ),
              controller: _addressController,
            ),
            SizedBox(height: 16.0),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Code postal',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: _postalCodeController,
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Ville',
              ),
              controller: _cityController,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _saveUserData,
              child: Text('Valider'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text('Se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}
