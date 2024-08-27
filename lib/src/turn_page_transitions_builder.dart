import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turn_page_transition/src/turn_direction.dart';
import 'package:turn_page_transition/src/turn_page_animation.dart';

class TurnPageTransitionsBuilder extends PageTransitionsBuilder {
  const TurnPageTransitionsBuilder({
    required this.textureAsset,
    this.animationTransitionPoint,
    this.direction = TurnDirection.rightToLeft,
  });

  final String textureAsset;
  final double? animationTransitionPoint;
  final TurnDirection direction;

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return _TexturedPageTransition(
      animation: animation,
      textureAsset: textureAsset,
      animationTransitionPoint: animationTransitionPoint,
      direction: direction,
      child: child,
    );
  }
}

class _TexturedPageTransition extends StatefulWidget {
  const _TexturedPageTransition({
    Key? key,
    required this.animation,
    required this.textureAsset,
    this.animationTransitionPoint,
    required this.direction,
    required this.child,
  }) : super(key: key);

  final Animation<double> animation;
  final String textureAsset;
  final double? animationTransitionPoint;
  final TurnDirection direction;
  final Widget child;

  @override
  _TexturedPageTransitionState createState() => _TexturedPageTransitionState();
}

class _TexturedPageTransitionState extends State<_TexturedPageTransition> {
  late Future<ui.Image> _textureImageFuture;

  @override
  void initState() {
    super.initState();
    _textureImageFuture = _loadImage(widget.textureAsset);
  }

  Future<ui.Image> _loadImage(String assetName) async {
    final ByteData data = await rootBundle.load(assetName);
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(data.buffer.asUint8List(), (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: _textureImageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return TurnPageAnimation(
            animation: widget.animation,
            texture: snapshot.data!,
            animationTransitionPoint: widget.animationTransitionPoint,
            direction: widget.direction,
            child: widget.child,
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}