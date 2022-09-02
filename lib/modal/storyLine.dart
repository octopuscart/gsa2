class StoryLine {
  final String id;
  final String image;
  final String display_index;
  final String content;
  final String local_path;

  StoryLine({
    required this.id,
    required this.image,
    required this.display_index,
    required this.content,
    required this.local_path,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'display_index': display_index,
      'content': content,
      'local_path': local_path,
    };
  }

  Future<List<Dog>> storyByLanguage() async {
    // Get a reference to the database.
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }
}
