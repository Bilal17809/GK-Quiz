import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common_widgets/grid_data.dart';
import '../../../core/constant/constant.dart';
import '../../../core/routes/routes_name.dart';
import '../../../core/common_widgets/custom_app_bar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../controller/ai_explain_topics_controller.dart';

class AiExplainTopics extends StatelessWidget {
  AiExplainTopics({super.key});

  final AiExplainTopicsController controller = Get.put(
    AiExplainTopicsController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(subtitle: 'Learning Hub'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kBodyHp),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            shrinkWrap: true,
            itemCount: gridTexts.length,
            itemBuilder: (context, index) {
              final color = gridColors[index % gridColors.length].withValues(
                alpha: 0.75,
              );
              final icon = gridIcons[index % gridIcons.length];
              final text = gridTexts[index % gridTexts.length];

              return InkWell(
                onTap: () {
                  Get.toNamed(RoutesName.aiExplain, arguments: text);
                },
                child: Container(
                  decoration: roundedDecorationWithShadow.copyWith(
                    color: color,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: kWhite.withValues(alpha: 0.2),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            icon,
                            color: kWhite,
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          text,
                          style: context.textTheme.titleSmall?.copyWith(
                            color: kWhite,
                          ),
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
      bottomNavigationBar:
          controller.isInterstitialReady
              ? const SizedBox()
              : Obx(() => controller.getBannerAdWidget('ad11')),
    );
  }
}
