import 'package:flutter/material.dart';
import 'package:mental_health_calendar/pages/questionare_response.dart';

class QuestionarePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QuestionarePageState();
  }
}

class _QuestionarePageState extends State<QuestionarePage> {
  final questions = [
    _Question(1, "1. Feeling reduced interest in everyday activities?"),
    _Question(1, "2. Feeling sad or depressed?"),
    _Question(1, "3. Having a hard time sleeping or waking up?"),
    _Question(1, "4. Feeling tired, sleepy, or low energy?"),
    _Question(1, "5. Feeling worried?"),
    _Question(1, "6. Overeating or undereating?"),
    _Question(1, "7. Having a hard time concentrating?"),
    _Question(2, "8. Thinking about hurting yourself or others?"),
  ];

  @override
  Widget build(BuildContext context) {
    final canSubmit =
        !questions.any((question) => question.selectedAnswer == null);

    return Scaffold(
      appBar: AppBar(
        title: Text("How often are you:"),
      ),
      body: ListView.separated(
        itemCount: questions.length,
        itemBuilder: (BuildContext context, int index) => _QuestionPrompt(
          questions[index],
          (value) => setState(() => questions[index].selectedAnswer = value),
        ),
        separatorBuilder: (BuildContext context, int index) => Divider(),
      ),
      floatingActionButton: Opacity(
        opacity: canSubmit ? 1.0 : 0.75,
        child: FloatingActionButton.extended(
          label: Text("Submit"),
          icon: Icon(Icons.check),
          backgroundColor:
              canSubmit ? Theme.of(context).accentColor : Colors.grey,
          onPressed: canSubmit ? _submit : null,
        ),
      ),
    );
  }

  void _submit() {
    final score = questions
        .map(
          (question) =>
              _Question.answers[question.selectedAnswer].weight *
              question.weight,
        )
        .fold(0, (total, weight) => total + weight);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => QuestionareResponsePage(score: score)),
    );
  }
}

@immutable
class _Answer {
  final String text;
  final int weight;

  _Answer(this.weight, this.text);
}

class _Question {
  static final answers = [
    _Answer(0, "Rarely or never"),
    _Answer(1, "Some days"),
    _Answer(2, "Most Days"),
    _Answer(3, "Everyday"),
  ];

  final String question;
  final int weight;
  int selectedAnswer;

  _Question(this.weight, this.question);
}

class _QuestionPrompt extends StatelessWidget {
  final _Question question;
  final void Function(int) onChanged;

  const _QuestionPrompt(this.question, this.onChanged, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ListTile(
            title: Text(
              question.question,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _Question.answers.length,
              itemBuilder: (context, index) {
                final answer = _Question.answers[index];

                return RadioListTile(
                  title: Text(answer.text),
                  value: index,
                  selected: index == question.selectedAnswer,
                  groupValue: question.selectedAnswer,
                  onChanged: onChanged,
                );
              })
        ],
      );
}
