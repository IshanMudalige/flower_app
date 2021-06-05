import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flower_app/model/flower.dart';
import 'package:flower_app/screens/flower_view_screen.dart';
import 'package:flower_app/screens/list_screen.dart';
import 'package:flower_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  double width, height;
  String url;
  bool isLoaded = false;
  List<Flower> flowerList = [];

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() => {
          getFlowersList(),
        });
  }

  getFlowersList() async {
    print('>>>>>>>>>>>>>> getting flowers');
    final dbRef = FirebaseDatabase.instance.reference().child('FlowersList');
    DataSnapshot dataSnapshot = await dbRef.once();
    print(dataSnapshot.value);
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
          flowerList.add(flower);
          isLoaded = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
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
          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              'assets/images/flower_logo.png',
              width: 25,
              height: 25,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              'Flower App',
              style: TextStyle(color: darkGreen),
            )
          ]),
        ),
        body: _body());
  }

  //main body
  Widget _body() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Categories',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              catItem('Orchid', 'assets/images/orchid.png'),
              catItem('Lilies', 'assets/images/lily.png'),
              catItem('Roses', 'assets/images/rose.png'),
              catItem('Lotus', 'assets/images/lotus.png'),
            ],
          ),
          Padding(padding: EdgeInsets.only(bottom: 8, top: 16)),
          Divider(),
          Padding(
            padding: EdgeInsets.only(bottom: 16, top: 8),
            child: Text(
              'Featured',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(child: listArea())
        ],
      ),
    );
  }

  //category item
  Widget catItem(String category, String img) {
    return InkWell(
      child: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 8),
              height: width * 0.21,
              width: width * 0.21,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0.5,
                    blurRadius: 3,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child:
                  Padding(padding: EdgeInsets.all(16), child: Image.asset(img)),
            ),
            Text(
              '$category',
              style: TextStyle(fontWeight: FontWeight.bold, color: darkGreen),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ListScreen(
                    cat: category,
                  )),
        );
      },
    );
  }

  //flower list area
  Widget listArea() {
    return isLoaded
        ? GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                childAspectRatio: (width / 2 / 220),
                maxCrossAxisExtent: width / 2,
                //mainAxisExtent: width-200,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16),
            itemCount: flowerList.length,
            itemBuilder: (BuildContext ctx, index) {
              return listItem(flowerList[index]);
            })
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  //flower list item
  Widget listItem(Flower flower) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(
          left: 2,
          right: 2,
        ),
        //height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.5,
              blurRadius: 3,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(children: [
          Container(
            height: 130,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Image.network(
                flower.imgUrl,
                height: 130,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(flower.name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(flower.rating),
                          Icon(
                            Icons.star,
                            size: 18,
                            color: lightGreen,
                          )
                        ],
                      ),
                    ],
                  ),
                  Text(
                    flower.cat,
                    style: TextStyle(fontSize: 14, color: darkGreen),
                  )
                ],
              ))
        ]),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ViewScreen(flower: flower,),),);
      },
    );
  }
}
