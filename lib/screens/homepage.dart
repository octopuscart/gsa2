import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gsa/modal/dbsync.dart';
import 'package:gsa/modal/curd.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:gsa/screens/uiElements.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DBSync dbsobj = DBSync();
  Dbconnect db = Dbconnect();
  UIElements uiobj = UIElements();
  String loadingString = "";
  int steps = 0;
  List storyline = [];
  CarouselController buttonCarouselController = CarouselController();
  late Dio dio;
  @override
  void initState() {
    dio = Dio();
    print("init homepage");
    getSyncLocalData();
    super.initState();
  }

  Future getSyncLocalData() async {
    List res_story = await db.getContentByLanguage("1");
    print(res_story);
    setState(() {
      storyline = res_story;
    });
  }

  setPercentData(String message) {
    print(message);
    setState(() {
      loadingString = message;
    });
  }

  bool loadingdata = true;

  var progress = "";
  String savePath = "";

  bool downloading = true;
  String downloadingStr = "No data";
  var temp = '';

  Future downloadFile(image_detail) async {
    print("download function");

    try {
      Dio dio = Dio();
      String fileName = image_detail['image']
          .substring(image_detail['image'].lastIndexOf("/") + 1);
      Directory tempDir = await getApplicationDocumentsDirectory();
      String savePath = '${tempDir.path}/$fileName';

      await dio.download(image_detail['image'], savePath,
          onReceiveProgress: (rec, total) {
        setState(() {
          downloading = true;
          // download = (rec / total) * 100;
          downloadingStr = "Downloading URL : $rec";
          temp = savePath;
        });
      });
      print(temp);
      Map updateData = {"local_path": savePath};
      db.updateTable("story_images", updateData, image_detail["id"]);
      setState(() {
        downloading = false;
        downloadingStr = "Completed";
      });
    } catch (e) {
      print(e.toString());
    }
  }

  checkImage(commingData, index) {
    print(commingData);
    // print(commingData['local_path']);
    var res = commingData['local_path'].toString();
    if (res != '') {
    } else {
      downloadFile(commingData);
    }
  }

  Future changeLanguage() async {
    List languageData = await db.getDataByQuery(
        "select id, title, is_active, is_default from  story_language order by display_index asc");
    print(languageData);

    List initSetupData = await db.getDataByQuery("select * from  init_setup");
    print(initSetupData);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add', // used by assistive technologies
        onPressed: () {
          changeLanguage();
        },
        child: Icon(Icons.translate),
      ),
      body: Builder(
        builder: (context) {
          final double height = MediaQuery.of(context).size.height;
          return CarouselSlider(
            carouselController: buttonCarouselController,
            options: CarouselOptions(
                height: height,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                onPageChanged: (int index, pagereason) {
                  print(storyline[index]);
                  //Downloading images
                  checkImage(storyline[index], index);
                }
                // autoPlay: false,
                ),
            items: storyline
                .map((item) => SingleChildScrollView(
                        child: Column(children: [
                      Center(
                          child: uiobj.imageBlock(
                              localpath: item['local_path'].toString(),
                              imagepath: item['image'].toString())),
                      Container(
                          margin: EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 20),
                          child: HtmlWidget(
                            """${item['content']}""",
                            textStyle: TextStyle(fontSize: 18),
                          ))
                    ])))
                .toList(),
          );
        },
      ),
    );
  }
}
