enum TaskPriority {
  none,     // 0
  low,      // 1
  medium,   // 2
  high,     // 3
  critical; // 4

  static TaskPriority fromInt(int value) =>
      TaskPriority.values[value.clamp(0, TaskPriority.values.length - 1)];

  int toInt() => index;

  String get label => switch (this) {
    TaskPriority.none      => 'None',
    TaskPriority.low      => 'Low',
    TaskPriority.medium   => 'Medium',
    TaskPriority.high     => 'High',
    TaskPriority.critical => 'Critical',
  };
}