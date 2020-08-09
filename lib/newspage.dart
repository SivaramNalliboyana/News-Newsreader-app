import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsreader/apikey.dart';
import 'package:http/http.dart' as http;
import 'package:newsreader/vieweb.dart';

class NewsPage extends StatefulWidget {
  final String name;
  NewsPage(this.name);
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  FlutterTts tts = FlutterTts();

  getnews() async {
    var url =
        'https://newsapi.org/v2/top-headlines?country=in&apiKey=$apikey&category=${widget.name}';
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    List<News> newslist = List<News>();
    for (var article in result['articles']) {
      News news = News(article['title'], article['urlToImage'], article['url'],
          article['description']);
      newslist.add(news);
    }
    return newslist;
  }

  speak(String text) async {
    print(await tts.getLanguages);
    await tts.setLanguage('en-IN');
    await tts.setPitch(1);
    await tts.setVolume(1.0);
    await tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 30.0),
              child: Text("Top ${widget.name} news",
                  style: GoogleFonts.montserrat(
                      fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            FutureBuilder(
                future: getnews(),
                builder: (BuildContext context, dataSnapshot) {
                  if (!dataSnapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: dataSnapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.only(top: 10.0),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              Text(
                                dataSnapshot.data[index].title,
                                style: GoogleFonts.montserrat(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              Image(
                                image: NetworkImage(
                                    dataSnapshot.data[index].image),
                                fit: BoxFit.cover,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () => speak(
                                        dataSnapshot.data[index].description),
                                    child: Icon(
                                      Icons.play_arrow,
                                      size: 60,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await tts.stop();
                                    },
                                    child: Icon(
                                      Icons.stop,
                                      size: 60,
                                      color: Colors.red,
                                    ),
                                  ),
                                  RaisedButton(
                                    color: Colors.deepOrange,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ViewWeb(
                                                  dataSnapshot
                                                      .data[index].url)));
                                    },
                                    child: Text(
                                      "View",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      });
                })
          ],
        ),
      ),
    );
  }
}

class News {
  final String title;
  final String image;
  final String url;
  final String description;

  News(this.title, this.image, this.url, this.description);
}
