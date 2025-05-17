import 'package:flutter/material.dart';

showMySnackbar({
  required BuildContext context,
  required String content,
  Color? color
}){
  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(content),
                    backgroundColor:color ?? Colors.green,
                    behavior: SnackBarBehavior.floating,
                     ),
                );
}