import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:random_Fun/Animations/fade_in.dart';

class Todo extends StatefulWidget {
  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  List<String> todos = [
    "Write a letter to your future self. Talk about your hopes, dreams and goals. Keep it in an envelope addressed to your future self (maybe even set a date for when to open it). Your future self will appreciate it.",
    "Can you talk over a distance with two cans and a string? Great time to find out.",
    "See if you can bottle flip 20 times in a row. Good luck.",
    "Watch scary movies. Friday the 13th but like…every night.",
    "Invent fresh memes. Meme a picture in your camera roll and watch it go viral. Bonus points if your memes are quarantine-themed.",
    "Attempt Zentangling. By drawing structured patterns over and over again you could create an art masterpiece.",
    "Re-watch shows from your childhood. You can find “Danny Phantom” on Hulu or “The Proud Family” on Disney+. Notice any “adult” references that you didn’t catch as a kid ? :p",
    "Make a YouTube video. I hear “What to Do When You’re Bored” is trending. We’re all losing our minds.",
    "Reminisce by watching old home videos. Does your mom still have the same clothing she wore 20 years ago? Because same.",
    "Here’s a bold one: Text your crush. Now’s the perfect time to shoot your shot. You’re both bored and longing for human interaction. Maybe you’ll come out of this quarantine with a date.",
    "Tone your abs. Do sit-ups, planking, squats and lunges. Come out of this quarantine looking ripped.",
    "Learn to play an instrument. You can find millio,ns of tutorials on YouTube.",
    "Go outside and stretch your legs. As long as you stay six feet away from others.",
    "Try to put a shirt on while doing a handstand. It’s definitely as hard as it sounds.",
    "Teach yourself ASL or a foreign language using Duolingo.",
    " Check in on your friends. Talk about life until all hours of the night.",
    "Find out what Hogwarts house you belong to with the Pottermore quiz. Ravenclaw gang.",
    "Watch a silent movie and make up the dialogue. Doing it with someone else may make you feel a little bit more sane.",
    "Learn how to juggle. Now when someone asks if you have a secret talent you can finally say, “Yes, I do.” Show off your juggling skills.",
    "Listen to a TED Talk for inspiration and motivation.",
    "Make slime. Start a collection. Mix colors together or try different slime recipes.",
    "Watch the sunset. Welcome a new day and try all of this stuff again."
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Never get bored !'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                child: Text(
              'Try these amazing random things !',
              style: TextStyle(fontSize: 20.0),
            )),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return FadeAnimation(
                    1.2,
                    Container(
                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(
                                FontAwesomeIcons.arrowCircleRight,
                                size: 20.0,
                              ),
                            ),
                            Flexible(
                                child: Text(
                              todos[index],
                              style: TextStyle(fontSize: 16.0),
                            )),
                          ],
                        ),
                      ),
                    ));
              },
            ),
          )
        ],
      ),
    );
  }
}
