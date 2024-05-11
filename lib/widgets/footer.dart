import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
  children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: Color.fromARGB(38, 0, 0, 0),
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
                    Image.network('https://i.ibb.co/QnyXWBP/bizlogo.png',
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
                                
                              ),
                            ),
                          ),
                           InkWell(
                    onTap: () {},
                    child: Text(
                      'Tezos Commons',
                      style: TextStyle(
                        fontSize: 14,
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
                        'Developed by ',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                       InkWell(
                    onTap: () {
                      launch("https://actual.monster");
                    },
                    child: Text(
                      'EightRice',
                      style: TextStyle(
                        fontSize: 14,
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