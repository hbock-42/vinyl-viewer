import 'package:flutter/material.dart';
import 'package:vinyl_viewer/theme/main_theme.dart';

class ButtonHover extends StatefulWidget {
  final void Function() onClick;
  final String text;

  const ButtonHover(this.text, {Key key, this.onClick}) : super(key: key);

  @override
  _ButtonHoverState createState() => _ButtonHoverState();
}

class _ButtonHoverState extends State<ButtonHover> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (event) => widget.onClick(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 200, minHeight: 65),
        child: Container(
          decoration: BoxDecoration(
            color: isHovered ? Color.fromRGBO(0, 137, 184, 1) : Colors.blue,
            borderRadius: AppTheme.borderRadius,
          ),
          child: MouseRegion(
            onEnter: (event) => setState(() => isHovered = true),
            onExit: (event) => setState(() => isHovered = false),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 10,
              ),
              child: Center(
                child: Text(
                  widget.text,
                  style: AppTheme.whiteText.button,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
