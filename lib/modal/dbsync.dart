import 'package:Gospal_Sharing_App/controllers/apiController.dart';
import 'initSetup.dart';
import 'curd.dart';
import 'storyLanguage.dart';
import 'storyContent.dart';
import 'storyImages.dart';

class DBSync {
  Dbconnect db = Dbconnect();
  ApiController apiobj = ApiController();

  DBSync() {
    // Dbconnect db = Dbconnect();
  }

  Future<int> insertScriptureData(
      datalist, tablename, int index, callback) async {
    if (datalist.length > index) {
      var singledata = datalist[index];
      await db.insertData(tablename, singledata);
      int perdata = datalist.length;
      int progesspercent = ((index * 100) / perdata).round();
      callback(progesspercent);
      var percent = ((index * 100) / perdata).round();
      await insertScriptureData(datalist, tablename, index + 1, callback);
      return index + 1;
    } else {
      callback(100);
      return 100;
    }
    return index + 1;
  }

  Future<int> syncStoryLanguage(callback) async {
    Map story_language = {
      'api': 'getLanguage',
      'title': "Story Language",
      "table_name": "story_language",
    };
    List story_languageData =
        await apiobj.getDataFromServer(story_language["api"]);
    List story_languageDataParsed =
        story_languageData.map((json) => StoryLanguage.fromJson(json)).toList();
    return await insertScriptureData(
        story_languageDataParsed, story_language["table_name"], 0, callback);
  }

  Future<int> syncStoryImages(callback) async {
    Map story_language = {
      'api': 'getImageData',
      'title': "Story Images",
      "table_name": "story_images",
    };
    List story_languageData =
        await apiobj.getDataFromServer(story_language["api"]);
    List story_languageDataParsed =
        story_languageData.map((json) => StoryImages.fromJson(json)).toList();
    await insertScriptureData(
        story_languageDataParsed, story_language["table_name"], 0, callback);
    return 200;
  }

  Future<int> syncStoryContent(callback) async {
    Map story_language = {
      'api': 'getContent',
      'title': "Stories",
      "table_name": "story_content",
    };
    List story_languageData =
        await apiobj.getDataFromServer(story_language["api"]);
    List story_languageDataParsed =
        story_languageData.map((json) => StoryContent.fromJson(json)).toList();
    await insertScriptureData(
        story_languageDataParsed, story_language["table_name"], 0, callback);
    return 200;
  }

  Future<int> syncInitSetup(callback) async {
    Map initsetup = {
      'api': 'initialSetup',
      'title': "initialSetup",
      "table_name": "init_setup",
    };
    List initsetupData = await apiobj.getDataFromServer(initsetup["api"]);
    List initsetupDataParsed =
        initsetupData.map((json) => InitSetupDB.fromJson(json)).toList();
    await insertScriptureData(
        initsetupDataParsed, initsetup["table_name"], 0, callback);
    return 200;
  }

  Future getDataAndInsert(callback) async {
    await syncStoryLanguage(
        (percent) => {callback("Loading Language $percent%")});
    await syncStoryImages(
        (percent) => {callback("Loading Story Images $percent%")});
    await syncStoryContent(
        (percent) => {callback("Loading Stories $percent%")});
    await syncInitSetup(
        (percent) => {callback("Loading Init Setup $percent%")});
  }

  Future getLastInsertedData(String tablename) async {
    return db.getDataByQuery(
        "select id from  $tablename order by id desc limit 0,1");
  }

  Future getLastDataVersiond() async {
    return db.getDataByQuery(
        "select attr_value as id from init_setup where attr_type = 'data_version' order by id desc limit 0,1");
  }
}
