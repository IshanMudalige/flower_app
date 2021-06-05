import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flower_app/model/flower.dart';
import 'package:flower_app/screens/flower_view_screen.dart';
import 'package:flower_app/screens/update_screen.dart';
import 'package:flower_app/utils/colors.dart';
import 'package:flutter/material.dart';

class MyFlowers extends StatefulWidget {

  final Callback goBack;

  const MyFlowers({Key key, this.goBack}) : super(key: key);

  @override
  _MyFlowers createState() => _MyFlowers();
}

class _MyFlowers extends State<MyFlowers> {
  double width, height;

  String url;
  bool isLoaded = false;
  final flwList = [];

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() => {
          getMyFlowersList(),
        });
  }

  getMyFlowersList() async {
    isLoaded = false;
    flwList.clear();
    print('>>>>>>>>>>>>>> getting my flowers');
    final dbRef = FirebaseDatabase.instance.reference().child('FlowersList');
    DataSnapshot dataSnapshot = await dbRef.once();
    Map<dynamic, dynamic> map = dataSnapshot.value;

    if (map != null) {
      print("not null");
      map.forEach((key, value) async {
        print('$key: $value');
        Flower flower = Flower.fromSnapshot(value);
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child(flower.imgName);
        flower.imgUrl = (await ref.getDownloadURL()).toString();
        setState(() {
          if (flower.token == 'my') flwList.add(flower);
          isLoaded = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: lightPink2,
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'My Flowers',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_sharp,
            ),
            onPressed: () {widget.goBack();},
            color: Colors.black,
            splashRadius: 20,
          ),
        ),
        body: _body());
  }

  Widget _body() {
    return isLoaded ? Container(
      margin: EdgeInsets.fromLTRB(4, 10, 4, 0),
      child: ListView.builder(
          itemCount: flwList.length,
          itemBuilder: (context, index) {
            return listItem(flwList[index],index);
          }),
    ) : Center(child: CircularProgressIndicator(),);
  }

  Widget listItem(Flower flower,int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.white,
        boxShadow: [ BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(0, 3), // changes position of shadow
        ),],
      ),

      margin: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child:InkWell(child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              child: Image.network(
                flower.imgUrl,
                height: 110,
                width: 180,
                fit: BoxFit.fill,
              ),
            ),
              onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ViewScreen(flower: flower,)),);},
          ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(flower.name, style: TextStyle(fontSize: 16)),
                  Text(flower.cat, style: TextStyle(color: darkGreen)),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.all(4),
                          width: 60,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: darkPink,
                          ),
                          child: Center(
                              child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                        onTap:  (){

                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>_deleteFlower(context,flower.id,index));


                        }

                      ),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        child: Container(
                          width: 60,
                          height: 30,
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              border: Border.all(color: darkPink)),
                          child: Center(
                            child: Text(
                              'Edit',
                              style: TextStyle(color: darkPink),
                            ),
                          ),
                        ),
                        onTap: (){Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UpdateScreen(flower: flower,)),).whenComplete(() => getMyFlowersList());},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //delete flower from db
  Widget _deleteFlower(BuildContext context,String id,int index){
    return new AlertDialog(
      title: Text('Delete Flower'),
      content: Text('Do you really want to delete flower? Once delete you cannot undo'),
      actions: [
        FlatButton(
          child: Text('No'),
          onPressed: () =>  Navigator.of(context).pop(),
        ),
        FlatButton(
          child: Text('Yes'),
          onPressed: () {
            FirebaseDatabase.instance.reference().child("FlowersList").child(id).remove();
            setState(() {
              flwList.removeAt(index);
            });
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }


}

typedef Callback = void Function();
