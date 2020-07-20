import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class ListScreen extends StatefulWidget {
  ListScreen({Key key,}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  
  final databaseInstance = Firestore.instance;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;

  String bikeImgURL, bikeCombo;

  String uid = "BBNBYHQwq3aWriNlAc9S"; 

  getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future getData() async {
    QuerySnapshot snapshot = await databaseInstance.collection("bikes").getDocuments();

    return snapshot.documents;  
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
      title: Text('Bike List'),
      ),
      body: 
        Container(
          child: FutureBuilder(
            future: getData(),
            builder: (_, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
                );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index){

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data[index].data["image"]),
                    ),
                    title: Text(snapshot.data[index].data["size"]+" "+snapshot.data[index].data["type"]),
                    onTap: () {
                      Navigator.pushNamed(context, '/add');
                    },
                  ); 

                });

            }
            }
          ) 
        )
    );
  }
}