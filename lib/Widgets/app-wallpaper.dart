import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Wallpaper extends StatelessWidget {
  const Wallpaper({
    Key key,
    @required this.wallpaper,
  }) : super(key: key);

  final String wallpaper;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) => LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.center,
        colors: [Colors.black45, Colors.transparent],
      ).createShader(rect),
      blendMode: BlendMode.darken,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(wallpaper),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
            )
        ),
      ),
    );
  }
}