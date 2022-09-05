import '../modal/curd.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../modal/story.dart';
import '../modal/initSetup.dart';
import '../controllers/apiController.dart';

class StoryController {
  Dbconnect db = Dbconnect();
  StoryController();
  late Dio dio = Dio();

  //Story Content
  Future<List<Story>> storyByLanguage(String language_id) async {
    final List maps = await db.getContentByLanguage(language_id);
    return List<Story>.generate(maps.length, (i) {
      return Story(
        id: maps[i]['id'].toString(),
        image: maps[i]['image'],
        display_index: maps[i]['display_index'].toString(),
        content: maps[i]['content'],
        local_path: maps[i]['local_path'],
      );
    });
  }

  Future<Story> downloadFile(Story storyobj,
      {ProgressCallback? onReceiveProgress}) async {
    try {
      Dio dio = Dio();
      String fileName =
          storyobj.image.substring(storyobj.image.lastIndexOf("/") + 1);
      Directory tempDir = await getApplicationDocumentsDirectory();
      String savePath = '${tempDir.path}/$fileName';

      await dio.download(storyobj.image, savePath,
          onReceiveProgress: onReceiveProgress);

      Map updateData = {"local_path": savePath};

      await db.updateTableCondition(
          "story_images", updateData, {"id": storyobj.id});
      storyobj.local_path = savePath;
      return storyobj;
    } catch (e) {
      print(e.toString());
      return storyobj;
    }
  }
}

class InitSetupClass {
  Dbconnect db = Dbconnect();
  ApiController apiobj = ApiController();
  //Initial Status
  Future<InitSetup> initSetupGet() async {
    final List maps = await db
        .getDataByQuery("select attr_type, attr_value from  init_setup");
    Map<dynamic, dynamic> inisetupmap = {};
    maps.forEach((element) {
      inisetupmap[element["attr_type"]] = element["attr_value"];
    });
    // print(iniset);
    return InitSetup(
      data_version: inisetupmap["data_version"],
      review_status: inisetupmap["review_status"],
      story_language: inisetupmap["story_language"],
      font_size: double.parse(inisetupmap["font_size"]),
      app_version_android: inisetupmap["app_version_android"],
      app_version_ios: inisetupmap["app_version_ios"],
    );
  }

  Future<List?> checkInitSetup() async {
    Map initsetup = {
      'api': 'initialSetup',
      'title': "initialSetup",
      "table_name": "init_setup",
    };
    try {
      List? initsetupData = await apiobj.getDataFromServer(initsetup["api"]);
      return initsetupData;
    } on Exception catch (_) {
      return [];
    }
  }

  Future deleteDatabase() async {
    await db.deleteTableData("story_language");
    await db.deleteTableData("story_images");
    await db.deleteTableData("story_content");
    await db.deleteTableData("init_setup");
  }

  Future<Map<String, bool>> initDataCheck() async {
    List<dynamic>? initSetupApiData = await this.checkInitSetup();
    Map<dynamic, dynamic> iniSetupApi = {};
    initSetupApiData?.forEach((element) {
      iniSetupApi[element["attr_type"]] = element["attr_value"];
    });
    InitSetup dbInitSetup = await this.initSetupGet();
    InitSetup dbInitSetupApi = dbInitSetup;
    if (initSetupApiData != null) {
      dbInitSetupApi = InitSetup(
        data_version: iniSetupApi["data_version"],
        review_status: iniSetupApi["review_status"],
        story_language: iniSetupApi["story_language"],
        font_size: double.parse(iniSetupApi["font_size"]),
        app_version_android: iniSetupApi["app_version_android"],
        app_version_ios: iniSetupApi["app_version_ios"],
      );
    }
    print("check init data db and api");
    print(dbInitSetup.toMap());
    print(dbInitSetupApi.toMap());
    Map<String, bool> checkUpdateData = {
      "isUpdate": false,
      "updateDB": false,
      "updateAndroid": false,
      "updateIos": false
    };
    if (dbInitSetup.data_version != dbInitSetupApi.data_version) {
      checkUpdateData["updateDB"] = true;
    }
    if (dbInitSetup.app_version_android != dbInitSetupApi.app_version_android) {
      checkUpdateData["updateAndroid"] = true;
    }
    if (dbInitSetup.app_version_ios != dbInitSetupApi.app_version_ios) {
      checkUpdateData["updateIos"] = true;
    }
    checkUpdateData.forEach((key, value) {
      if (value) {
        checkUpdateData["isUpdate"] = true;
      }
    });
    return checkUpdateData;
  }
}
