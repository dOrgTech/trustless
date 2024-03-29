import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
  children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: Color.fromARGB(62, 0, 0, 0),
          padding: EdgeInsets.symmetric(vertical: 26, horizontal: 32),
          child: Center(
            child: Container(
              height: 120,
              // width: 1200,
              constraints: BoxConstraints(maxWidth: 1050),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Terms',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Privacy',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Contact',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                    Image.network(
                                   'https://i.ibb.co/6PXBBLG/business-logo.png',
                                  height: 64,
                                   // color: Colors.red,
                             ),
                          SizedBox(width: 8),
                        
                        ],
                      ),
                      SizedBox(height: 18),
                      Text(
                        '© Tezos-Homebase ${DateTime.now().year}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Powered by ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                           InkWell(
                    onTap: () {},
                    child: Text(
                      'Tezos Commons',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                        ],
                      ),
                        SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Developed by EightRice of ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                       InkWell(
                    onTap: () {},
                    child: Text(
                      'dOrg',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                    ],
                  ),
                    ],
                  ),
                 
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}