class Joke_Model {
  String type, setup, punchline;

  Joke_Model({this.type, this.setup, this.punchline});

  factory Joke_Model.fromJson(Map<String, dynamic> json) {
    return Joke_Model(
        type: json['type'] ?? "",
        setup: json['setup'] ?? "",
        punchline: json['punchline'] ?? "");
  }
}
