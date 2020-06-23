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
  final int progress;

  Todo._({
    this.key,
    this.name,
    this.creationDate,
    this.dueDate,
    this.progress,
  });

  factory Todo.create(String name) => Todo._(
        name: name,
        creationDate: DateTime.now(),
      );

  factory Todo.fromJson(dynamic json) => Todo._(
      key: json[KEY],
      name: json[NAME],
      creationDate: json[CREATION_DATE],
      dueDate: json[DUE_DATE],
      progress: json[PROGRESS]);

  Todo copyWith({
    String key,
    String name,
    DateTime creationDate,
    DateTime dueDate,
    int progress,
  }) =>
      Todo._(
        key: key ?? this.key,
        name: name ?? this.name,
        creationDate: creationDate ?? this.creationDate,
        dueDate: dueDate ?? this.dueDate,
        progress: progress ?? this.progress,
      );

  Todo saveProgress(int progress) => copyWith(progress: progress);

  Map<String, dynamic> toJson() => {
        KEY: key,
        NAME: name,
        CREATION_DATE: creationDate.millisecondsSinceEpoch,
        DUE_DATE: dueDate.millisecondsSinceEpoch,
        PROGRESS: progress,
      };
}
