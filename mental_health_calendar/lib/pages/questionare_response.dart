import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class QuestionareResponsePage extends StatelessWidget {
  final int score;

  const QuestionareResponsePage({Key key, this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: ListTile(
                title: Text(
                  "Your Score: $score",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Your score reflects how you are doing right now. We recommend anyone with a score over 7 seriously consider looking into therapy, but this is a personal journey - it is different for everyone.",
              ),
            ),
          ],
        ),
      );
}
