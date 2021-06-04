import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flower_app/model/flower.dart';
import 'package:flower_app/screens/flower_view_screen.dart';
import 'package:flower_app/utils/colors.dart';
import 'package:flutter/material.dart';

class ListScreen extends StatefulWidget {

  final Callback goBack;
  final String cat;

  const ListScreen({Key key, this.cat,this.goBack}) : super(key: key);

  @override
  _ListScreen createState() => _ListScreen();
}

class _ListScreen extends State<ListScreen> {

  double width, height;

  String url;
  bool isLoaded = false;
  final flowerList = [];
  String cat;


  @override
  void initState() {
    super.initState();
    cat = widget.cat;
    Firebase.initializeApp().whenComplete(() => {
      getFlowersList(),
    });

  }

  getFlowersList() async {
    print('>>>>>>>>>>>>>> getting flowers');
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
          if(cat==null)
            flowerList.add(flower);
          else if(cat == flower.cat){
            flowerList.add(flower);
          }

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
        title: Text(cat == null ? 'All Flowers' : cat, style: TextStyle(color: Colors.black),),
        iconTheme: IconThemeData(color: Colors.black),
        leading: cat == null ? IconButton(icon: Icon(Icons.arrow_back_sharp,),onPressed: (){widget.goBack();},color: Colors.black,splashRadius:20,)
        : IconButton(icon: Icon(Icons.arrow_back_sharp,),onPressed: (){Navigator.pop(context);},color: Colors.black,splashRadius:20,),
      ),
      body: _body()
    );
  }

  Widget _body(){
    return isLoaded ? Container(
        margin: EdgeInsets.fromLTRB(16,16,16,0),
        child:GridView.builder(

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing:15,mainAxisSpacing: 15),
      itemBuilder: (_, index) => listItem(flowerList[index]),
      itemCount:flowerList.length,
    )):Center(child: CircularProgressIndicator(),);
  }

  Widget listItem(Flower flower){
    return InkWell(child:Container(
      height: 180,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [ BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(0, 3), // changes position of shadow
        ),],
      ),
      child: Column(
          children: [
            Container(
              height: 130,
              width: double.infinity,
              child:ClipRRect(
                borderRadius: BorderRadius.only(topLeft:Radius.circular(10),topRight:Radius.circular(10)),
                child: Image.network(flower.imgUrl,height: 130,fit: BoxFit.fill,),
              ),),
            Padding(
                padding: EdgeInsets.all(8),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(flower.name,style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(flower.rating),
                            Icon(Icons.star,size: 18,color: lightGreen,)
                          ],
                        ),
                      ],
                    ),
                    Text(flower.cat,style: TextStyle(fontSize: 14,color: darkGreen),)
                  ],))
          ]
      ),
    ),
      onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ViewScreen(flower: flower,)),);},
    );
  }


}

typedef Callback = void Function();