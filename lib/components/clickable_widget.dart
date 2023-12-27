import 'package:flutter/material.dart';

class ClickableWidget extends StatelessWidget {
  ClickableWidget({required this.child, this.onTap});

  Widget child;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (this.onTap != null) this.onTap!.call();
        },
        child: this.child,
      ),
    );
  }
}
