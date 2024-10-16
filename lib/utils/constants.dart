import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'colors.dart';

/// Returns a random color from the [backgroundColors] list.
///
/// The function uses [math.Random] to generate a random index
/// into the [backgroundColors] list and returns the color at
/// that index.
Color getRandomColors() {
  math.Random random = math.Random();
  return backgroundColors[random.nextInt(backgroundColors.length)];
}

/// Formats a [DateTime] object into a human-readable string
/// that is suitable for display in the app.
///
/// The format string used is 'dd MMM yyyy hh:mm a', which
/// displays the date and time in the format "dd MMM yyyy hh:mm a".
///
String formatDateTime(DateTime dateTime) =>
    DateFormat('dd MMM yyyy hh:mm a').format(dateTime);

class Assets {
  static const String notesImage = "assets/images/notes.png";
}
