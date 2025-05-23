import 'package:flutter/material.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileHeight = MediaQuery.of(context).size.height;
    final mobileWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [kCoral, kCoral.withValues(alpha: 0.75)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    // Curved white container
                    Positioned(
                      top: mobileHeight * 0.25,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(mobileWidth, 150),
                            topRight: Radius.elliptical(mobileWidth, 150),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: kBlack.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: Offset(0, -5),
                            ),
                          ],
                        ),

                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 100,
                            left: 30,
                            right: 30,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 40),
                              Expanded(
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      color: kWhite,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: roundedDecoration
                                                  .copyWith(
                                                    color: kCoral.withAlpha(
                                                      100,
                                                    ),
                                                  ),
                                              child: ListTile(
                                                leading: Icon(
                                                  Icons.quiz,
                                                  color: kCoral,
                                                ),
                                                title: Text('Total Questions'),
                                                trailing: Text('20'),
                                              ),
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: roundedDecoration
                                                  .copyWith(
                                                    color: kCoral.withAlpha(
                                                      100,
                                                    ),
                                                  ),
                                              child: ListTile(
                                                leading: Icon(
                                                  Icons.done,
                                                  color: kCoral,
                                                ),
                                                title: Text('Correct Answers'),
                                                trailing: Text('18'),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: roundedDecoration
                                                  .copyWith(
                                                    color: kCoral.withAlpha(
                                                      100,
                                                    ),
                                                  ),
                                              child: ListTile(
                                                leading: Icon(
                                                  Icons.close,
                                                  color: kCoral,
                                                ),
                                                title: Text('Wrong Answers'),
                                                trailing: Text('2'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
