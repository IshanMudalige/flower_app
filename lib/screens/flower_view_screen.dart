import 'package:flower_app/model/flower.dart';
import 'package:flower_app/utils/colors.dart';
import 'package:flutter/material.dart';

class ViewScreen extends StatefulWidget {
  final Flower flower;

  const ViewScreen({Key key, this.flower}) : super(key: key);

  @override
  _ViewScreen createState() => _ViewScreen();
}

class _ViewScreen extends State<ViewScreen> {
  double width, height;
  Flower flower;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    flower = widget.flower;
    return Scaffold(backgroundColor: Colors.white, body: _body());
  }

  Widget _body() {
    return CustomScrollView(
      slivers: <Widget>[
        //Header area
        SliverAppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          pinned: true,
          floating: false,
          title: Text(
            flower.name,
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: Icon(
                isSelected ? Icons.favorite : Icons.favorite_border,
                color: Colors.redAccent,
              ),
              onPressed: () {
                setState(() {
                  isSelected ? isSelected = false : isSelected = true;
                });
              },
              color: Colors.black,
            )
          ],

          //floating: _floating,
          expandedHeight: 250.0,
          flexibleSpace: FlexibleSpaceBar(
              // title: Text(flower.name,style: TextStyle(color: Colors.black),),
              //titlePadding: EdgeInsets.only(left:50),
              centerTitle: true,
              background: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  child: Image.network(
                    flower.imgUrl,
                    fit: BoxFit.fill,
                  ))),
          backgroundColor: Colors.white,
        ),
        //First Card(Hours)
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        flower.name,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            flower.rating,
                            style: TextStyle(fontSize: 18),
                          ),
                          Icon(
                            Icons.star,
                            color: lightGreen,
                            size: 24,
                          )
                        ],
                      )
                    ]),
                Text(
                  flower.cat,
                  style: TextStyle(color: darkGreen),
                ),
                Divider(),
                SizedBox(
                  height: 16,
                ),
                Text(flower.desc)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
