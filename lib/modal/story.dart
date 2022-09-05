class Story {
  final String id;
  final String image;
  final String display_index;
  final String content;
  String local_path;

  Story({
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
}
