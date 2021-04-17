import 'package:flutter/material.dart';

class QuestionarePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QuestionarePageState();
  }
}

class _QuestionarePageState extends State<QuestionarePage> {
  final questions = [
    _Question(1.0, "Feeling reduced interest in everyday activities?"),
    _Question(1.0, "Feeling sad or depressed?"),
    _Question(1.0, "Having a hard time sleeping or waking up?"),
    _Question(1.0, "Feeling tired, sleepy, or low energy?"),
    _Question(1.0, "Feeling worried?"),
    _Question(1.0, "Overeating or undereating?"),
    _Question(1.0, "Having a hard time concentrating?"),
    _Question(5.0, "Thinking about hurting yourself or others?"),
  ];

  @override
  Widget build(BuildContext context) {
    final canSubmit = !questions.any((question) => question.selectedAnswer == null);

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

  void _submit(){

  }
}

@immutable
class _Answer {
  final String text;
  final double weight;

  _Answer(this.weight, this.text);
}

class _Question {
  static final answers = [
    _Answer(0.0, "Rarely or never"),
    _Answer(1.0, "Some days"),
    _Answer(2.0, "Everyday"),
    _Answer(3.0, "Always"),
  ];

  final String question;
  final double weight;
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
