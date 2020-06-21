class Post {
  String todo, desc, link, category;

  Post({this.todo, this.desc, this.link, this.category});

  Map<String, dynamic> toMap(String todo, String desc, String link, String category) {
    return ({'todo': todo, 'desc': desc, 'link': link, 'category': category});
  }

  factory Post.fromJson(Map<String, dynamic> post_json) {
    return Post(todo: post_json['todo'], desc: post_json['desc'], link: post_json['link'], category: post_json['category']);
  }
}
