import 'package:flutter/material.dart';
import 'package:template/core/common_widgets/round_image.dart';
import 'package:template/core/constant/constant.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/extension/extension.dart';
import 'package:template/core/models/grid_data.dart';

class TakeATestList extends StatefulWidget {
  const TakeATestList({super.key});

  @override
  State<TakeATestList> createState() => _TakeATestListState();
}

class _TakeATestListState extends State<TakeATestList> {
  @override
  Widget build(BuildContext context) {
    final mobileHeight = MediaQuery.of(context).size.height;
    final mobileWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GK Quiz',
              style: context.textTheme.titleMedium?.copyWith(color: kRed),
            ),
            Text('Take a Test', style: context.textTheme.bodyLarge),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
          child: RoundedButton(
            backgroundColor: kRed,
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/back.png', color: kWhite),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kBodyHp),
          child: ListView.builder(
            itemCount: gridColors.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: mobileWidth * 1,
                height: mobileHeight * 0.10,
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  color: kWhite,
                  child: Row(
                    children: [
                      Container(
                        width: mobileWidth * 0.20,
                        height: mobileHeight * 0.10,
                        decoration: BoxDecoration(
                          color: gridColors[index].withValues(alpha: 0.64),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),

                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(gridIcons[index]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            gridTexts[index],
                            style: context.textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            'Total Questions: 248',
                            style: context.textTheme.bodySmall,
                          ),
                          trailing: Icon(Icons.check_box),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
