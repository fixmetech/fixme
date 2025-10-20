import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixme/features/translation/controllers/translation_controller.dart';

class TranslatableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TranslatableText(
    this.text, {
    Key? key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translationController = Get.find<TranslationController>();
    
    return Obx(() {
      if (translationController.isTranslationNeeded()) {
        return FutureBuilder<String>(
          future: translationController.translateText(text),
          builder: (context, snapshot) {
            final displayText = snapshot.data ?? text;
            return Text(
              displayText,
              style: style,
              textAlign: textAlign,
              maxLines: maxLines,
              overflow: overflow,
            );
          },
        );
      } else {
        return Text(
          text,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      }
    });
  }
}

class TranslatableRichText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TranslatableRichText(
    this.text, {
    Key? key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translationController = Get.find<TranslationController>();
    
    return Obx(() {
      if (translationController.isTranslationNeeded()) {
        return FutureBuilder<String>(
          future: translationController.translateText(text),
          builder: (context, snapshot) {
            final displayText = snapshot.data ?? text;
            return RichText(
              text: TextSpan(
                text: displayText,
                style: style ?? DefaultTextStyle.of(context).style,
              ),
              textAlign: textAlign ?? TextAlign.start,
              maxLines: maxLines,
              overflow: overflow ?? TextOverflow.clip,
            );
          },
        );
      } else {
        return RichText(
          text: TextSpan(
            text: text,
            style: style ?? DefaultTextStyle.of(context).style,
          ),
          textAlign: textAlign ?? TextAlign.start,
          maxLines: maxLines,
          overflow: overflow ?? TextOverflow.clip,
        );
      }
    });
  }
}