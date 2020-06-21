import 'package:random_Fun/models/dog.dart';
import 'package:random_Fun/models/joke.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Api {
  List<Joke_Model> jokes = [];
  List<String> dogs_images = [];
  Future<List<Joke_Model>> getJoke() async {
    var url = "https://official-joke-api.appspot.com/jokes/ten";
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jokes_data = convert.jsonDecode(response.body);

        jokes_data.forEach((joke) => {jokes.add(Joke_Model.fromJson(joke))});
      }
      return jokes;
    } catch (e) {
      print(e.toString());
      return Future.error(e.toString());
    }
  }

  Future getDogs(int breed) async {
    var url = "https://dog.ceo/api/breed/${Dog().breeds[breed]}/images";
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var dogs_data = convert.jsonDecode(response.body);

        dogs_data['message'].forEach((dog_img) => {dogs_images.add(dog_img)});
      }
      return dogs_images;
    } catch (e) {
      print(e.toString());
      return Future.error(e.toString());
    }
  }
}
