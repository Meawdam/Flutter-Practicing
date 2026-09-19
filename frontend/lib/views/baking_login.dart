import 'package:flutter/material.dart';

class BakingLogin extends StatelessWidget {
  const BakingLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF202020),
      body: Column(
        crossAxisAlignment: .stretch,
        children: [
          Expanded(
            flex: 2,
            child: Image.asset('assets/images/baking.jpg', fit: .cover),
          ),
          SizedBox(height: 10),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        'sign in'.toUpperCase(),
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      Text(
                        'sign up'.toUpperCase(),
                        style: TextStyle(fontSize: 16, color: Colors.amber),
                      ),
                    ],
                  ),
                  SizedBox(height: 48),
                  Row(
                    children: [
                      Icon(Icons.alternate_email, color: Colors.amber),
                      SizedBox(width: 5),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hint: Text(
                              'Email Address',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.lock, color: Colors.amber),
                      SizedBox(width: 5),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hint: Text(
                              'Password',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
              child: Row(
                children: [
                  Ink(
                    decoration: ShapeDecoration(
                      shape: CircleBorder(side: BorderSide(color: Colors.grey)),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.android, color: Colors.grey),
                    ),
                  ),
                  SizedBox(width: 10),
                  Ink(
                    decoration: ShapeDecoration(
                      shape: CircleBorder(side: BorderSide(color: Colors.grey)),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.chat, color: Colors.grey),
                    ),
                  ),
                  Spacer(),
                  Ink(
                    decoration: const ShapeDecoration(
                      color: Colors.amber,
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.skip_next),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
