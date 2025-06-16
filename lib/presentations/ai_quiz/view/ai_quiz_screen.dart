import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/custom_app_bar.dart';
import 'package:template/core/service/ai_service.dart';
import 'package:template/core/theme/app_colors.dart';
import '../../../core/common_widgets/textform_field.dart';

class AiQuizScreen extends StatefulWidget {
  const AiQuizScreen({super.key});

  @override
  State<AiQuizScreen> createState() => _AiQuizScreenState();
}

class _AiQuizScreenState extends State<AiQuizScreen> {
  late final AiService controller;
  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = Get.find<AiService>();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    inputController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        subtitle: 'AI Chat',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: kWhite,),
            onPressed: () {
              Get.back();
            },

          ),
        ],
      ),
      body: Stack(
        children: [
          Center(child: Image.asset('assets/images/chatbot.png', color: kSkyBlueColor,width: MediaQuery.of(context).size.width * 0.1,),),
          Column(
            children: [
              // Context Display Banner
              Obx(() => Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: kSkyBlueColor.withValues(alpha: 0.1),
                  border: Border(
                    bottom: BorderSide(
                      color: kSkyBlueColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.psychology, color: kSkyBlueColor, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Context: ${controller.currentContext.value.length > 100 ? '${controller.currentContext.value.substring(0, 100)}...' : controller.currentContext.value}',
                        style: const TextStyle(
                          color: kSkyBlueColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )),
          
              Expanded(
                child: Obx(() {
                  if (controller.chatHistory.isNotEmpty) {
                    scrollToBottom();
                  }
                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: controller.chatHistory.length + (controller.isLoading.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.chatHistory.length && controller.isLoading.value) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              CircularProgressIndicator(strokeWidth: 2),
                              SizedBox(width: 16),
                              Text('AI is thinking...'),
                            ],
                          ),
                        );
                      }
                      final msg = controller.chatHistory[index];
                      final isUser = msg['role'] == 'user';
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isUser) ...[
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: greyColor.withValues(alpha: 0.2),
                                child: const Icon(Icons.smart_toy, size: 16),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isUser ? kSkyBlueColor : greyColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Text(
                                  msg['content']!,
                                  style: TextStyle(
                                    color: isUser ? kWhite : kBlack,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            if (isUser) ...[
                              const SizedBox(width: 8),
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: kSkyBlueColor,
                                child: const Icon(Icons.person, size: 16, color: kWhite),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: kWhite,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, -2),
                      blurRadius: 6,
                      color: kBlack.withValues(alpha: 0.01),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        hintText: 'Type your message...',
                        controller: inputController,
                        onChanged: (value) {
                          if (value.trim().endsWith('\n')) {
                            final text = value.trim();
                            if (text.isNotEmpty) {
                              controller.sendMessage(text);
                              inputController.clear();
                            }
                          }
                        },
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(() => CircleAvatar(
                      backgroundColor: kSkyBlueColor,
                      child: IconButton(
                        icon: controller.isLoading.value
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(kWhite),
                          ),
                        )
                            : const Icon(Icons.send, color: kWhite),
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                          final text = inputController.text.trim();
                          if (text.isNotEmpty) {
                            controller.sendMessage(text);
                            inputController.clear();
                          }
                        },
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}