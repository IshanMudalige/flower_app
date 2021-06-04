class Flower {
  String name;
  String imgName;
  String imgUrl;
  String desc;
  String cat;
  String token;
  String id;
  String rating;

  Flower(this.name, this.imgName, this.imgUrl, this.desc,this.cat,this.token,this.id,this.rating);

  Flower.fromSnapshot(dynamic value) :
        name = value["name"],
        imgName = value["imgName"],
        desc = value["desc"],
        cat = value["cat"],
        token = value["token"],
        rating = value["rating"],
        id = value["id"];

}