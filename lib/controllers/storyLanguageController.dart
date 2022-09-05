import 'package:select_dialog/select_dialog.dart';
import 'package:flutter/material.dart';
import '../modal/curd.dart';
import '../modal/storyLanguage.dart';

class StoryLanguageFunctions {
  Dbconnect db = Dbconnect();
  //Story Content
  Future<Map<String, StoryLanguage>> StoryLanguageList() async {
    Map<String, StoryLanguage> container = {};
    final List maps = await db.getDataByQuery("select * from  story_language");
    List.generate(maps.length, (i) {
      Map json = maps[i];
      container[json["title"].toString()] = StoryLanguage(
          server_id: json["id"].toString(),
          title: json["title"],
          display_index: json["display_index"].toString(),
          is_default: json["is_default"],
          is_active: json["is_active"].toString());
    });
    return container;
  }

  Future languageDialog(BuildContext context,
      {String? selectedLanguage, onChange}) async {
    Map<String, StoryLanguage> languagelist = await StoryLanguageList();
    List<String> langkeys = (languagelist.keys.toList());
    SelectDialog.showModal<String>(
      context,
      label: "Select Language",
      // titleStyle: TextStyle(color: Colors.brown),
      showSearchBox: false,
      selectedValue: selectedLanguage,

      // backgroundColor: Colors.amber,
      items: List.generate(langkeys.length, (index) => langkeys[index]),
      onChange: (String selected) {
        StoryLanguage? selectedLanguage = languagelist[selected];
        Map updateData = {"attr_value": selectedLanguage?.server_id};

        db.updateTableCondition(
            "init_setup", updateData, {"attr_type": "story_language"});
        onChange(languagelist[selected]);
      },
    );
  }
}
