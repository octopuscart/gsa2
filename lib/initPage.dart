import 'package:flutter/material.dart';
import 'modal/dbsync.dart';
import 'modal/storyLine.dart';
import 'controllers/storyController.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class InitPage extends StatefulWidget {
  const InitPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  DBSync dbsobj = DBSync();
  StoryController storyObj = StoryController();
  InitSetupClass initsetupobj = InitSetupClass();
  String loadingString = "";
  int steps = 0;
  bool enablebutton = false;
  bool loadingdata = true;

  @override
  void initState() {
    print("init homepage");
    startSyncData();
    removeSplash();

    super.initState();
  }

  Future removeSplash() async {
    FlutterNativeSplash.remove();
  }

  startSyncData() {
    dbsobj.getLastInsertedData("story_content").then((value) {
      int lastno = value[0]["id"];
      if (lastno == 0) {
        getSyncLocalData().whenComplete(() {
          setState(() {
            enablebutton = true;
            loadingdata = false;
          });
          print("All Done");
          moveToMainScreen();
        });
      } else {
        print("Db database");
        checkUpdateFunction();
      }
    });
  }

  moveToMainScreen() async {
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));

    print('go!');
    Navigator.pushNamedAndRemoveUntil(
        context, 'home', ModalRoute.withName('home'));
  }

  Future getSyncLocalData() async {
    await dbsobj.syncStoryLanguage(
        (percent) => {setPercentData("Loading Language $percent%")});
    await dbsobj.syncStoryImages(
        (percent) => {setPercentData("Loading Story Images $percent%")});
    await dbsobj.syncStoryContent(
        (percent) => {setPercentData("Loading Stories $percent%")});
    await dbsobj.syncInitSetup(
        (percent) => {setPercentData("Loading Init Setup $percent%")});
  }

  setPercentData(String message) {
    print(message);
    setState(() {
      loadingString = message;
    });
  }

  Map<String, bool> checkUpdateData = {
    "isUpdate": false,
    "updateDB": false,
    "updateAndroid": false,
    "updateIos": false
  };
  checkUpdateFunction() async {
    checkUpdateData = await initsetupobj.initDataCheck();
    print(checkUpdateData);
    if (checkUpdateData["updateDB"] == true) {
      print("dbupdate is available");
      await initsetupobj
          .deleteDatabase()
          .then(
            (value) => () {},
          )
          .whenComplete(
        () {
          startSyncData();
        },
      );
    } else {
      print("no dbupdate is available");

      moveToMainScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Builder(
        builder: (context) {
          final double height = MediaQuery.of(context).size.height;
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/splash.png'),
                fit: BoxFit.fill,
              ),
              // shape: BoxShape.circle,
            ),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                loadingdata
                    ? CircularProgressIndicator()
                    : SizedBox(
                        height: 0,
                      ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Text(loadingString),
                ),
                SizedBox(
                  height: 10,
                ),
                // ElevatedButton(
                //     onPressed: checkUpdateFunction, child: Text("Check Data"))
              ],
            ),
          );
        },
      ),
    );
  }
}
