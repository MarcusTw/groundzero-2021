import 'package:flutter/material.dart';

class DailySurvey extends StatefulWidget {
  @override
  _DailySurveyState createState() => _DailySurveyState();
}

class _DailySurveyState extends State<DailySurvey> {
  var _stressLevel = 5.0;
  var _fatigueLevel = 5.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.only(top: 30.0),
              child: Column(
                  children: [
                    Text('On a scale of 1 to 10, how stressed are you?'),
                    Text('(10 being most stressed, 1 being relaxed)')
                  ]
              )
          ),
          Slider.adaptive(
            value: _stressLevel,
            onChanged: (rating) {
              setState(() {
                _stressLevel = rating;
              });
            },
            min: 1,
            max: 10,
            divisions: 9,
            label: "$_stressLevel"
          ),
          Container(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: [
                Text('On a scale of 1 to 10, how tired are you?'),
                Text('(10 being very tired, 1 being fresh)')
              ]
            )
          ),
          Slider.adaptive(
              value: _fatigueLevel,
              onChanged: (rating) {
                setState(() {
                  _fatigueLevel = rating;
                });
              },
              min: 1,
              max: 10,
              divisions: 9,
              label: "$_fatigueLevel"
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  child: Text('Submit'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                  ),
                ),
                SizedBox(width: 20),
                OutlinedButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                  ),
                )
              ]
            ),
          )
        ],
      )
    );
  }
}
