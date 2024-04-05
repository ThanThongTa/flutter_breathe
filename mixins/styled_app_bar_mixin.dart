import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// Mixin, damit alle Screens den gleichen Style für die AppBar
// verwenden. Nur der angezeigte Titel ändert sich

// wir verwenddn ein Mixin, weil Scaffold explizit ein PreferredSizeWidget erwartet
// und kein StatefulWidget oder StatelessWidget, und ich keine Zeit hatte, mich
// mit den Overrides des PreferredSizeWidgets zu beschäftigen.
mixin StyledAppBarMixin {
  AppBar getStyledAppBar(BuildContext context, {required String title}) {
    return AppBar(
      // verwendet das Chevron nach links anstatt des Pfeils nach links
      // Icon wird nur angezeigt, wenn auch zurück navigiert werden kann
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      title: Text(title),
      centerTitle: true,
      backgroundColor: Colors.indigo,
      titleTextStyle: TextStyle(
        // Titel wird in weiß dargestellt, weil schwarz auf indigo
        // nur schwer zu lesen war
        color: Colors.white,
        fontSize: 20.sp,
      ),
    );
  }
}
