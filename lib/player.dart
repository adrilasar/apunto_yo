class Player {
  final int? id;
  final int? gId;
  final Map<int, int> scores;
  final String name;

  Player({
    this.id,
    this.gId,
    this.scores = const {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0},
    required this.name,
  });

  /// Returns a [Map] representation of the [Player].
  Map<String, dynamic> toMap() {
    String parseScores() {
      String scoresString = '';
      for (int i = 0; i <= 6; i++) {
        scoresString += '${scores[i]},';
      }
      return scoresString;
    }

    return {
      'g_id': gId,
      'name': name,
      'scores': parseScores(),
    };
  }

  @override
  String toString() {
    return 'Player{id: $id, name: $name}';
  }

  Player copy({
    int? id,
    int? gId,
    Map<int, int>? scores,
    String? name,
  }) =>
      Player(
        id: id ?? this.id,
        gId: gId ?? this.gId,
        scores: scores ?? this.scores,
        name: name ?? this.name,
      );

  static Player fromMap(Map<String, Object?> map) => Player(
        id: map['p_id'] as int?,
        gId: map['g_id'] as int?,
        scores: parseScores(map['scores'].toString()),
        name: map['name'] as String,
      );

  static parseScores(String string) {
    Map<int, int> scores = {};
    List<String> scoresList = string.split(',');
    for (int i = 0; i <= 6; i++) {
      scores[i] = int.parse(scoresList[i]);
    }
    return scores;
  }
}
