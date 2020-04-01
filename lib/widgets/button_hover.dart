import 'package:flutter/material.dart';
import 'package:vinyl_viewer/theme/main_theme.dart';

class ButtonHover extends StatefulWidget {
  final void Function() onClick;

  const ButtonHover({Key key, this.onClick}) : super(key: key);

  @override
  _ButtonHoverState createState() => _ButtonHoverState();
}

class _ButtonHoverState extends State<ButtonHover> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isHovered ? Color.fromRGBO(0, 137, 184, 1) : Colors.blue,
        borderRadius: AppTheme.borderRadius,
      ),
      child: Listener(
        onPointerUp: (event) => widget.onClick(),
        child: MouseRegion(
          onEnter: (event) => setState(() => isHovered = true),
          onExit: (event) => setState(() => isHovered = false),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 10,
            ),
            child: Text(
              'get file',
              style: AppTheme.whiteText.button,
            ),
          ),
        ),
      ),
    );
  }
}