import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ButtonWithIcon extends StatelessWidget {
  final IconData iconData;

  final VoidCallback? onPressed;

  final String label;

  const ButtonWithIcon({
    Key? key,
    required this.iconData,
    this.onPressed,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: FaIcon(iconData),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
