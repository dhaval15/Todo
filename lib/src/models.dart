class Todo {
  static const KEY = 'k',
      NAME = 'n',
      CREATION_DATE = 'c',
      DUE_DATE = 'd',
      PROGRESS = 'p';

  final String key;
  final String name;
  final DateTime creationDate;
  final DateTime dueDate;
  final double progress;

  Todo._({
    this.key,
    this.name,
    this.creationDate,
    this.dueDate,
    this.progress,
  });

  factory Todo.create(String name) => Todo._(
        name: name,
        progress: 0.0,
        creationDate: DateTime.now(),
      );

  factory Todo.fromJson(dynamic json) => Todo._(
      key: json[KEY],
      name: json[NAME],
      creationDate: DateTime.fromMillisecondsSinceEpoch(json[CREATION_DATE]),
      dueDate: DateTime.fromMillisecondsSinceEpoch(json[DUE_DATE]),
      progress: json[PROGRESS]);

  Todo copyWith({
    String key,
    String name,
    DateTime creationDate,
    DateTime dueDate,
    double progress,
  }) =>
      Todo._(
        key: key ?? this.key,
        name: name ?? this.name,
        creationDate: creationDate ?? this.creationDate,
        dueDate: dueDate ?? this.dueDate,
        progress: progress ?? this.progress,
      );

  Todo copyWithMap(
    Map<String, dynamic> map,
  ) =>
      Todo._(
        key: map[KEY] ?? this.key,
        name: map[NAME] ?? this.name,
        creationDate: map[CREATION_DATE] ?? this.creationDate,
        dueDate: map[DUE_DATE] ?? this.dueDate,
        progress: map[PROGRESS] ?? this.progress,
      );

  Map<String, dynamic> toJson() => {
        KEY: key,
        NAME: name,
        CREATION_DATE: creationDate.millisecondsSinceEpoch,
        DUE_DATE: dueDate.millisecondsSinceEpoch,
        PROGRESS: progress,
      };

  Map<String, dynamic> toMap() => {
        KEY: key,
        NAME: name,
        CREATION_DATE: creationDate,
        DUE_DATE: dueDate,
        PROGRESS: progress,
      };
}
