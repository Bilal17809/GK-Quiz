import 'package:ad_english_dictionary/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/common_widgets/drop_down.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../../../core/common_widgets/logo_widget.dart';
import '../../../core/common_widgets/round_image.dart';
import '../../../core/common_widgets/textform_field.dart';
import '../../../core/constant/constant.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/translator_cubit.dart';

class AiTranslatorPage extends StatelessWidget {
  const AiTranslatorPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackIconButton(),
        title: LogoWidget(title: 'AI Translator',),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:10,vertical:kBodyHp),
          child: Container(
            decoration: roundedDecoration,
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RoundedButton(
                        backgroundColor: dividerColor,
                        child: Icon(Icons.favorite_border, color: kBlue),
                        onTap: () {
                        },
                      ),
                      SizedBox(width: 10,),
                      RoundedButton(
                        backgroundColor: dividerColor,
                        child: Icon(Icons.close, color: kBlue),
                        onTap: () {
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16,),
                  CustomTextFormField(
                    hintText: "Write Something Here...",
                  ),

                  SizedBox(height: 16,),
                  Row(
                    children: [
                      AnimatedRoundedButton(
                        backgroundColor: dividerColor,
                        child: Icon(Icons.keyboard_voice, color: kBlue),
                        onTap: () {
                        },
                      ),
                      SizedBox(width: 16,),
                      Expanded(
                        child: LanguageDropdown(
                          languageCodes: context.read<LanguageCubit>().languageCodesC,
                          languageFlags: context.read<LanguageCubit>().languageFlags,
                          isFirst: true,
                        ),
                      ),
                      SizedBox(width: 12,),
                      AnimatedRoundedButton(
                        backgroundColor: dividerColor,
                        child: Icon(Icons.switch_access_shortcut_add_rounded, color: kBlue),
                        onTap: () {

                        },
                      ),
                      SizedBox(width: 12,),
                      Expanded(
                        child: LanguageDropdown(
                          languageCodes: context.read<LanguageCubit>().languageCodesC,
                          languageFlags: context.read<LanguageCubit>().languageFlags,
                          isFirst: false,
                        ),
                      ),
                      SizedBox(width: 12,),
                      AnimatedRoundedButton(
                        backgroundColor: dividerColor,
                        child: Icon(Icons.keyboard_voice, color: kBlue),
                        onTap: () {
                          print("Search mic tapped");
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



