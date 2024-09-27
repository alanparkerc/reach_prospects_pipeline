import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget loadingCircle() {
  return const CircularProgressIndicator(
    // Show loading icon when isLoading is true
    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey), // Customize color
  );
}

TextStyle mainStyle = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  inherit: false,
);

TextStyle main1Style = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.normal,
  color: Colors.black,
  inherit: false,
);

TextStyle main2Style = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.normal,
  color: Colors.grey,
  inherit: false,
);

TextStyle bolderStyle = const TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w900,
  color: Colors.black,
  inherit: false,
);

SizedBox wSixteenBox = const SizedBox(
  width: 16,
);

SizedBox wSixtyFourBox = const SizedBox(
  width: 64,
);

SizedBox sixtyFourBox = const SizedBox(
  height: 64,
);

SizedBox thirtyTwoBox = const SizedBox(
  height: 32,
);

SizedBox sixteenBox = const SizedBox(
  height: 16,
);

SizedBox eightBox = const SizedBox(
  height: 8,
);

ButtonStyle titleButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.transparent,
  elevation: 0,
  padding: const EdgeInsets.all(0.0),
  alignment: Alignment.center,
  shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      side: BorderSide(color: Colors.transparent)),
);

ButtonStyle rightTitleButtonStyle = ElevatedButton.styleFrom(
  elevation: 0,
  alignment: Alignment.center,
  backgroundColor: Colors.white,
  shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      side: BorderSide(color: Colors.white)),
);

ButtonStyle rightHomeButtonStyle = ElevatedButton.styleFrom(
  elevation: 0,
  alignment: Alignment.center,
  backgroundColor: Colors.transparent,
  shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(0.0)),
      side: BorderSide(color: Colors.white)),
);

ButtonStyle clearButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    elevation: 0,
    shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black)));

ButtonStyle custButStyle(BuildContext context, {int a = 0, b = 0, c = 0}) {
  return ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor:
          (b == 1) ? Colors.transparent : Colors.black, // Text color
      shadowColor: Colors.transparent,
      alignment: Alignment.center,
      enableFeedback: false,
      maximumSize:
          (c == 0) ? null : Size(MediaQuery.of(context).size.width / 7, 40),
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white),
          borderRadius:
              BorderRadius.all(Radius.circular((a == 1) ? 4.0 : 16.0))));
}

Widget returnBackTopRow(BuildContext context) {
  return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: titleButtonStyle,
              child: Row(children: [
                const Icon(Icons.arrow_back_ios, color: Colors.black),
                Text(
                  'BACK',
                  style: mainStyle,
                )
              ])),
        ],
      ));
}

Widget hotIcon() {
  return Icon(
    const IconData(
      0xf672,
      fontFamily: CupertinoIcons.iconFont,
      fontPackage: CupertinoIcons.iconFontPackage,
    ),
    color: Colors.red[900],
  );
}

Widget coldIcon() {
  return const Icon(
    IconData(
      0xf7e7,
      fontFamily: CupertinoIcons.iconFont,
      fontPackage: CupertinoIcons.iconFontPackage,
    ),
    color: Colors.blue,
  );
}
