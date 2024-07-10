/// Extension to add a time formatting method to the Duration class
extension DurationExtension on Duration {
  /// Getter to format Duration as a time string
  String get time {
    /// Get the total number of hours in the Duration
    final hour = inHours;

    /// Get the total number of minutes in the Duration and take the remainder after dividing by 60
    final minute = inMinutes % 60;

    /// Get the total number of seconds in the Duration and take the remainder after dividing by 60
    final second = inSeconds % 60;

    /// Construct the time string in the format HH.MM.SS
    /// If hours are not zero, include hours in the string
    /// Ensure two digits for minutes and seconds
    return "${hour != 0 ? ("${hour < 10 ? "0$hour" : hour}.") : ""}${minute < 10 ? "0$minute" : minute}.${second < 10 ? "0$second" : second}";
  }
}
