import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class BlocContainer extends StatelessWidget{

  void navigateTo(BuildContext blocContext, BlocContainer container) {
    Navigator.of(blocContext).push(MaterialPageRoute(
      builder: (context) => container,
    ));
  }

}