import 'package:assistant/global_variable.dart';
import 'package:flutter/material.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String desc;
  const FeatureBox({
    super.key,
    required this.color,
    required this.headerText,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headerText,
            style: TextStyle(
              fontFamily: 'Cera Pro',
              color: GlobalVariable.blackColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            desc,
            style: TextStyle(
              fontFamily: 'Cera Pro',
              color: GlobalVariable.blackColor,
            ),
          ),
        ],
      ),
    );
  }
}
