import 'package:apunto_yo/data/entities/player.dart';
import 'package:apunto_yo/data/sql_helper.dart';

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

  /// Returns a [Map] representation of the [Game].
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

  /// Returns the index of the [Player] with the lowest sum of points.
  int getWinner() {
    if (currentRound != 7) {
      return -1;
    }
    int winner = 0;
    int min = double.maxFinite.toInt();
    for (int i = 0; i < playerList!.length; i++) {
      int total = 0;
      for (int j = 0; j < playerList![i].scores.length; j++) {
        total += playerList![i].scores[j]!;
      }
      if (total < min) {
        min = total;
        winner = i;
      }
    }
    return winner;
  }

  String getDate() {
    return getFormattedDate(date);
  }

  String getDeleteDate() {
    return getFormattedDate(dDate!);
  }

  String getFormattedDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}   ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
