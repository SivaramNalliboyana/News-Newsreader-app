import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsreader/newspage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> categorylist = [
    Category('health', 'images/health.jpg'),
    Category('Sports', 'images/sports.jpg'),
    Category('Business', 'images/business.jpg'),
    Category('Entertainment', 'images/entertainment.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30.0),
            alignment: Alignment.center,
            child: Text(
              "News Reader",
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700, fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            crossAxisCount: 2,
            children: categorylist.map((eachcategory) {
              return InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewsPage(eachcategory.name))),
                child: Container(
                    height: 70,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(eachcategory.image),
                        fit: BoxFit.cover,
                      ),
                    )),
              );
            }).toList(),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 170,
            child: Image(
                image: AssetImage('images/technology.jpg'), fit: BoxFit.cover),
          )
        ],
      ),
    ));
  }
}

class Category {
  final String name;
  final String image;

  Category(this.name, this.image);
}
