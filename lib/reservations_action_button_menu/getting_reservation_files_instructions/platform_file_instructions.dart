import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:url_launcher/url_launcher.dart";

class PlatformFileInstructions extends StatelessWidget {
  const PlatformFileInstructions({
    required this.platformName,
    required this.platformFilesURL,
    required this.imageAssetNames,
    required this.instructionsDescription,
    required this.localized,
    super.key,
  });

  final String platformName;
  final String platformFilesURL;
  final List<String> imageAssetNames;
  final Widget instructionsDescription;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    final double imageHeight = MediaQuery.sizeOf(context).height * 0.5;

    return SizedBox(
      width: kMaxWidthLargest,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          childrenPadding: const EdgeInsets.symmetric(vertical: 16),
          title: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              child: Text(localized.getTheFiles.capitalized),
              onPressed: () {
                launchUrl(Uri.parse(platformFilesURL));
              },
            ),
          ),
          leading: Text(
            platformName.capitalized,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          children: <Widget>[
            instructionsDescription,
            SizedBox(
              height: kSmallScreenWidth,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: imageAssetNames.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: Image(
                      // width: imageWidth , //? Our desired aspect ratio is 1.616
                      height: imageHeight,

                      /// 1.6161,
                      image: AssetImage(
                        imageAssetNames[index],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
