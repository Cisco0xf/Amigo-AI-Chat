import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/commons/commons.dart';
import 'package:amigo/commons/my_logger.dart';
import 'package:amigo/commons/navigation_key.dart';
import 'package:amigo/constants/app_colors.dart';
import 'package:amigo/constants/app_fonts.dart';
import 'package:amigo/constants/gaps.dart';
import 'package:amigo/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showDeveloper() async {
  final BuildContext context = navigatorKey.currentContext as BuildContext;
  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: borderRadius(10.0)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const DevSection(),
      );
    },
  );
}

class DevSection extends StatelessWidget {
  const DevSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: padding(20.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: SwitchColors.border, width: 2.0),
            ),
            child: Icon(
              Icons.developer_mode,
              color: SwitchColors.secondary,
              size: 35.0,
            ),
          ),
          const Gap(height: 10.0),
          const Text(
            developed,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: FontFamily.mainFont,
            ),
          ),
          const Gap(height: 10.0),
          const Text(
            developer,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: FontFamily.mainFont,
            ),
          ),
          const Gap(height: 10.0),
          const PlatfromsSection(),
          const Gap(height: 10.0),
          const GitHubSourceCode(),
        ],
      ),
    );
  }
}

class GitHubSourceCode extends StatelessWidget {
  const GitHubSourceCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius(10.0),
        color: SwitchColors.opcColor,
        border: Border.all(color: SwitchColors.border),
      ),
      child: Clicker(
        onClick: () async {
          await OpenUrl.openUrl(
            target: "https://github.com/Cisco0xf/Amigo-AI-Chat.git",
          );
        },
        innerPadding: 10.0,
        child: Row(
          children: <Widget>[
            const Icon(FontAwesomeIcons.github),
            SizedBox(
              height: context.screenHeight * .05,
              child: const VerticalDivider(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  sourceCode,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: SwitchColors.text,
                    fontFamily: FontFamily.mainFont,
                  ),
                ),
                const Text(
                  sourceSubTitle,
                  style: TextStyle(
                    fontFamily: FontFamily.mainFont,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OpenUrl {
  static Future<void> openUrl({required String target}) async {
    final Uri uri = Uri.parse(target);

    final bool canLaunch = await launchUrl(uri);

    if (!canLaunch) {
      Log.error("Faild Launch => $target");
      return;
    }

    await launchUrl(uri);
  }
}

class DevModel {
  final String title;
  final String target;
  final IconData icon;
  final Color? color;

  const DevModel({
    required this.icon,
    required this.target,
    required this.title,
    required this.color,
  });
}

const List<DevModel> devData = [
  DevModel(
    icon: FontAwesomeIcons.github,
    target: "https://github.com/Cisco0xf",
    title: "GitHub",
    color: null,
  ),
  DevModel(
    icon: FontAwesomeIcons.linkedin,
    target: "https://www.linkedin.com/in/mahmoud-al-shehyby/",
    title: "LinkedIn",
    color: Colors.blue,
  ),
  DevModel(
    icon: FontAwesomeIcons.stackOverflow,
    target: "https://stackoverflow.com/users/23598383/mahmoud-al-shehyby",
    title: "StackOverflow",
    color: Colors.amber,
  ),
];

class PlatfromsSection extends StatelessWidget {
  const PlatfromsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List<Widget>.generate(
            devData.length,
            (index) {
              return SizedBox.square(
                dimension: context.screenHeight * .1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius(7.0),
                    color: SwitchColors.bgColor,
                    border:
                        Border.all(color: devData[index].color ?? Colors.grey),
                  ),
                  child: Clicker(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          devData[index].icon,
                          color: devData[index].color,
                        ),
                        const Gap(height: 8.0),
                        Text(
                          devData[index].title,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                    onClick: () async {
                      await OpenUrl.openUrl(target: devData[index].target);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
