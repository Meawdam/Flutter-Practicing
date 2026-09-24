import 'dart:math';

import 'package:flutter/material.dart';

class Rating extends StatefulWidget {
  const new({super.key});

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  Random rand = Random();
  TextEditingController input_1 = TextEditingController();
  TextEditingController input_2 = TextEditingController();
  TextEditingController input_3 = TextEditingController();

  int rating_1 = 0;
  int rating_2 = 0;
  int rating_3 = 0;
  double avg = 0;
  String result = '';

  void random() {
    rating_1 = rand.nextInt(5) + 1;
    rating_2 = rand.nextInt(5) + 1;
    rating_3 = rand.nextInt(5) + 1;
    avg = (rating_1 + rating_2 + rating_3) / 3;
    setState(() {
      input_1.text = rating_1.toString();
      input_2.text = rating_2.toString();
      input_3.text = rating_3.toString();

      result = 'Average rating : ${avg.toStringAsFixed(2)}';
    });
  }

  void rate() {
    int? rate_1 = int.tryParse(input_1.text.trim());
    int? rate_2 = int.tryParse(input_2.text.trim());
    int? rate_3 = int.tryParse(input_3.text.trim());

    if (rate_1 == null || rate_2 == null || rate_3 == null) {
      setState(() {
        result = 'Error: Invalid input';
      });
      return;
    }

    if (rate_1 < 1 ||
        rate_1 > 5 ||
        rate_2 < 1 ||
        rate_2 > 5 ||
        rate_3 < 1 ||
        rate_3 > 5) {
      setState(() {
        result = 'Error: Invalid input';
      });
      return;
    }

    avg = (rating_1 + rating_2 + rating_3) / 3;
    setState(() {
      rating_1 = rate_1;
      rating_2 = rate_2;
      rating_3 = rate_3;
      result = 'Average rating : ${avg.toStringAsFixed(2)}';
    });
  }

  void clear() {
    rating_1 = 0;
    rating_2 = 0;
    rating_3 = 0;
    avg = 0;
    input_1.clear();
    input_2.clear();
    input_3.clear();
    setState(() {
      result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text('Quiz 1 : Food Rating App'),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.blue,
                    child: Column(
                      children: [
                        Image.asset('assets/images/apple.png', width: 75),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            textAlign: .center,
                            textAlignVertical: .center,
                            controller: input_1,
                            decoration: InputDecoration(hintText: '1-5'),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: .center,
                          children: [
                            for (int i = 0; i < 5; i++)
                              Icon(
                                Icons.star,
                                color: i < rating_1
                                    ? Colors.amber
                                    : Colors.black,
                                size: 18,
                              ),
                          ],
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Container(
                    color: Colors.blue,
                    child: Column(
                      children: [
                        Image.asset('assets/images/apple.png', width: 75),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            textAlign: .center,
                            textAlignVertical: .center,
                            controller: input_2,
                            decoration: InputDecoration(hintText: '1-5'),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: .center,
                          children: [
                            for (int i = 0; i < 5; i++)
                              Icon(
                                Icons.star,
                                color: i < rating_2
                                    ? Colors.amber
                                    : Colors.black,
                                size: 18,
                              ),
                          ],
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Container(
                    color: Colors.blue,
                    child: Column(
                      children: [
                        Image.asset('assets/images/apple.png', width: 75),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            textAlign: .center,
                            textAlignVertical: .center,
                            controller: input_3,
                            decoration: InputDecoration(hintText: '1-5'),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: .center,
                          children: [
                            for (int i = 0; i < 5; i++)
                              Icon(
                                Icons.star,
                                color: i < rating_3
                                    ? Colors.amber
                                    : Colors.black,
                                size: 18,
                              ),
                          ],
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: .center,
              children: [
                ElevatedButton(onPressed: random, child: Text('Random Rate')),
                SizedBox(width: 8),
                ElevatedButton(onPressed: rate, child: Text('Rate')),
                SizedBox(width: 8),
                ElevatedButton(onPressed: clear, child: Text('Reset')),
              ],
            ),
            SizedBox(height: 16),
            Row(mainAxisAlignment: .center, children: [Text(result)]),
            Row(
              mainAxisAlignment: .center,
              children: [
                for (int i = 0; i < 5; i++)
                  Icon(
                    Icons.star,
                    color: i < avg.round() ? Colors.amber : Colors.black,
                    size: 18,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
