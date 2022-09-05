import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../controllers/storyController.dart';
import '../modal/storyLanguage.dart';
import 'uiElements.dart';
import 'fontSizePicker.dart';
import 'package:flutter/services.dart';
import 'package:custom_floating_action_button/custom_floating_action_button.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:in_app_review/in_app_review.dart';
import '../controllers/storyLanguageController.dart';
import '../modal/story.dart';
import '../modal/initSetup.dart';
import 'dart:io';
import 'package:update_checker/update_checker.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StoryController storyObj = StoryController();
  StoryLanguageFunctions languageObj = StoryLanguageFunctions();
  UIElements uiobj = UIElements();
  InitSetupClass initsetupobj = InitSetupClass();

  String loadingString = "";
  int steps = 0;
  List<Story> storyList = [];
  CarouselController buttonCarouselController = CarouselController();
  InitSetup? initSetupData;
  double _currentFontSize = 18.0;
  double _currentFontSizeTemp = 18.0;
  final InAppReview _inAppReview = InAppReview.instance;

  @override
  void initState() {
    initSetup();
    disableScreenShot();
    // _chackUpdate();
    super.initState();
  }

  disableScreenShot() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future initSetup() async {
    InitSetup initSetupData = await initsetupobj.initSetupGet();
    setState(() {
      _currentFontSize = initSetupData.font_size;
    });
    getSyncLocalData(initSetupData.story_language);
  }

  bool isDataAvailable = false;
  bool isloading = true;

  Future getSyncLocalData(initLanguage) async {
    List<Story> res_story = await storyObj.storyByLanguage(initLanguage);

    print(res_story);
    setState(() {
      isloading = false;
      storyList = res_story;
      if (storyList.length > 0) {
        isDataAvailable = true;
      }
      checkImage(storyList[0], 0);
    });
  }

  var temp = '';

  checkImage(Story commingData, index) async {
    print(commingData.toMap());
    var res = commingData.local_path.toString();
    print("${commingData.toMap()}, currentd data");
    if (res != '') {
    } else {
      var updatestoryObj = await storyObj.downloadFile(commingData,
          onReceiveProgress: ((count, total) {
        print("$count, $total");
      }));
      print("${updatestoryObj.toMap()} update data");
      storyList[index] = updatestoryObj;
    }
  }

  bool islandscap = false;
  Future _changeOrientations() async {
    // _showFontSizePickerDialog();
    setState(() {
      islandscap = !islandscap;
    });
    if (islandscap) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  void _changeFontSizePickerDialog() async {
    final selectedFontSize = await showDialog<double>(
      context: context,
      builder: (context) =>
          FontSizePickerDialog(initialFontSize: _currentFontSize),
    );
    if (selectedFontSize != null) {
      setState(() {
        _currentFontSize = selectedFontSize;
      });
    }
  }

  Future<void> _requestForReview() {
    return _inAppReview.requestReview();
  }

  void _changeLanguage() {
    languageObj.languageDialog(context,
        selectedLanguage: initSetupData?.story_language.toString(),
        onChange: (StoryLanguage selected) {
      print(selected);
      getSyncLocalData(selected.server_id);
    });
  }

  void _chackUpdate() async {
    var checker = UpdateChecker(); // create an object from UpdateChecker

    //check your OS if android pass the play store URL and so do iOS
    if (Platform.isIOS) {
      checker.checkForUpdates("YOUR_APP_STORE_URL").then((value) => {
            // if value is true you can show a dialog to redirect user to app store to perform update
          });
    } else if (Platform.isAndroid) {
      checker
          .checkForUpdates(
            "YOUR_PLAY_STORE_URL",
          )
          .then((value) => {
                // if value is true you can show a dialog to redirect user to play store to perform update
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return isDataAvailable
        ? CustomFloatingActionButton(
            body: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [],
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
                          print(storyList[index].toMap());
                          //Downloading images
                          checkImage(storyList[index], index);
                        }
                        // autoPlay: false,
                        ),
                    items: storyList
                        .map((item) => SingleChildScrollView(
                                child: Column(children: [
                              Center(
                                  child: uiobj.imageBlock(
                                      localpath: item.local_path.toString(),
                                      imagepath: item.image.toString())),
                              Container(
                                  margin: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 20, right: 20),
                                  child: HtmlWidget(
                                    """${item.content.toString()}""",
                                    textStyle:
                                        TextStyle(fontSize: _currentFontSize),
                                  ))
                            ])))
                        .toList(),
                  );
                },
              ),
            ),
            openFloatingActionButton: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            closeFloatingActionButton: const Icon(
              color: Colors.white,
              Icons.close,
            ),
            floatinButtonColor: Colors.red,
            type: CustomFloatingActionButtonType.verticalUp,
            spaceFromBottom: 15,
            spaceFromRight: 15,
            options: [
              uiobj.menuButton(
                title: "Language",
                icon: Icons.translate,
                onPressed: () => _changeLanguage(),
              ),
              uiobj.menuButton(
                title: "Rotate",
                icon: Icons.screen_rotation_outlined,
                onPressed: () => _changeOrientations(),
              ),
              uiobj.menuButton(
                title: "Text Size",
                icon: Icons.format_size,
                onPressed: () => _changeFontSizePickerDialog(),
              ),
              // uiobj.menuButton(
              //   title: "Feedback",
              //   icon: Icons.feedback,
              //   // onPressed: () => _chackUpdate(),
              // ),
            ],
          )
        : Scaffold(
            backgroundColor: Colors.white,
            // extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [],
            ),
            body: Container(
              height: height,
              width: double.infinity,
              child: isloading
                  ? SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icon.png",
                          height: 150,
                        ),
                        Text(
                            "Unable to start app, \nplease check internet and restart app.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18)),
                      ],
                    ),
            ),
          );
  }
}
