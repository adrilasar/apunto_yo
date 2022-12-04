import 'package:apunto_yo/player.dart';
import 'package:apunto_yo/sql_helper.dart';

class Game {
  final int? id;
  final String title;
  final List<Player>? playerList;
  final DateTime date;
  late DateTime? dDate;
  final int random;
  int currentRound;

  Game({
    this.id,
    required this.title,
    this.playerList,
    required this.date,
    this.dDate,
    required this.random,
    required this.currentRound,
  });

  Game copy({
    int? id,
    String? title,
    List<Player>? playerList,
    DateTime? date,
    DateTime? dDate,
    int? random,
    int? currentRound,
  }) =>
      Game(
          id: id ?? this.id,
          title: title ?? this.title,
          playerList: playerList ?? this.playerList,
          date: date ?? this.date,
          dDate: dDate ?? this.dDate,
          random: random ?? this.random,
          currentRound: currentRound ?? this.currentRound);

  Future<Game> gameWithPlayers() async {
    final playerList = await SqlHelper.getPlayers(id!);
    return copy(playerList: playerList);
  }

  ///Convert a [Game] into a [Map].
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date.toString(),
      'd_date': dDate?.toString(),
      'random': random,
      'current_round': currentRound,
    };
  }

  static Game fromMap(Map<String, Object?> map) => Game(
        id: map['g_id'] as int?,
        title: map['title'] as String,
        date: DateTime.tryParse(map['date'].toString()) as DateTime,
        dDate: DateTime.tryParse(map['d_date'].toString()),
        random: map['random'] as int,
        currentRound: map['current_round'] as int,
      );
}
