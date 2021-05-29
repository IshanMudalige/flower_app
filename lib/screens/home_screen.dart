import 'package:flower_app/utils/colors.dart';
import 'package:flower_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  double width,height;

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
        backgroundColor:Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children:[Image.asset('assets/images/flower_logo.png',width: 25,height: 25,),SizedBox(width: 4,), Text('Flower App',style: TextStyle(color:logoPink),)]),
      ),
      body: _body()
    );
  }
  
  
  Widget _body(){
    return Container(
      margin: EdgeInsets.fromLTRB(16,16,16,0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(bottom: 16),
            child:Text('Categories',style: TextStyle(fontSize: 18),),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              catItem('Orchids','assets/images/orchid.png'),
              catItem('Lilies','assets/images/lily.png'),
              catItem('Roses','assets/images/rose.png'),
              catItem('Lotus','assets/images/lotus.png'),
            ],
          ),
          Padding(padding: EdgeInsets.only(bottom: 16,top: 32),
            child:Text('Featured',style: TextStyle(fontSize: 18),),
          ),

          Expanded(child:listArea())


        ],
      ),
    );
    
  }
  
  Widget catItem(String category,String img){
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8),
            height: 90,
            width: 90,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Padding(padding: EdgeInsets.all(16), child:Image.asset(img)),
          ),
          Text('$category',style: TextStyle(fontWeight: FontWeight.bold,color: darkGreen),)
        ],
      ),
    );
  }

  Widget listArea(){
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 16,mainAxisSpacing: 20),
      itemBuilder: (_, index) => listItem(),
      itemCount:10,
    );

  }


  Widget listItem(){
    return Container(
      height: 180,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Column(
        children: [
          Container(
            height: 130,
            width: double.infinity,
            child:ClipRRect(
              borderRadius: BorderRadius.only(topLeft:Radius.circular(10),topRight:Radius.circular(10)),
              child: Image.asset('assets/images/flower.jpg',height: 130,fit: BoxFit.fill,),
          ),),
          Padding(
            padding: EdgeInsets.all(8),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Flower',style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
              Align(
                alignment: Alignment.center,
                child:
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text('10k'),
                  Icon(Icons.remove_red_eye,size: 16,)
                ],
              ),),
            ],
          ),
            Text('Category',style: TextStyle(fontSize: 14,color: darkGreen),)
        ],))
        ]
      ),
    );
  }




}