import 'dart:async';

import 'package:apunto_yo/game.dart';
import 'package:apunto_yo/player.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlHelper {
  static Future<Database> db() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), 'la_libreta.db'),
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE game (
              g_id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT UNIQUE,
              date TEXT NOT NULL,
              d_date TEXT,
              random INTEGER NOT NULL,
              current_round INTEGER NOT NULL
          )
          ''');
        // A game is automatically deleted after 30 days
        db.execute('''
          CREATE TRIGGER delete_game AFTER INSERT ON game
          BEGIN
            DELETE FROM game WHERE d_date < date('now', '-30 days');
          END
          ''');
        db.execute('''
          CREATE TABLE player (
            p_id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE,
            scores TEXT NOT NULL,
            g_id INTEGER NOT NULL,
            FOREIGN KEY(g_id) REFERENCES game(g_id)
          )
          ''');
      },
      version: 1,
    );
  }

  /// Inserts a [Game] into the db.
  static Future<int> createGame(Game game) async {
    final db = await SqlHelper.db();

    return await db.insert(
      'game',
      game.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Returns a list of all games without `d_date` with its players inserted.
  static Future<List<Game>> getGames() async {
    final db = await SqlHelper.db();
    final List<Map<String, dynamic>> maps =
        await db.query('game', where: 'd_date IS NULL', orderBy: 'date DESC');

    List<Game> games = List.generate(maps.length, (i) {
      return Game.fromMap(maps[i]);
    });

    for (int i = 0; i < games.length; i++) {
      games[i] = await games[i].gameWithPlayers();
    }

    return games;
  }

  /// Returns a list of all games with a `d_date` set.
  static Future<List<Game>> getDeletedGames() async {
    final db = await SqlHelper.db();
    final List<Map<String, dynamic>> maps =
        await db.query('game', where: 'd_date IS NOT NULL');

    List<Game> games = List.generate(maps.length, (i) {
      return Game.fromMap(maps[i]);
    });

    for (int i = 0; i < games.length; i++) {
      games[i] = await games[i].gameWithPlayers();
    }

    return games;
  }

  /// Returns a [Game] with the given [id] with its players inserted.
  static Future<Game> getGame(int id) async {
    final db = await SqlHelper.db();

    final maps =
        await db.query('game', where: 'g_id = ?', whereArgs: [id], limit: 1);
    return Game.fromMap(maps.first).gameWithPlayers();
  }

  /// Deletes the game with the given [id] and its associated players from the db.
  static Future<void> deleteGame(int id) async {
    final db = await SqlHelper.db();

    await db.delete(
      'game',
      where: 'g_id = ?',
      whereArgs: [id],
    );
    await db.delete(
      'player',
      where: 'g_id = ?',
      whereArgs: [id],
    );
  }

  /// Updates the given [Game] in the db.
  static void updateGame(Game game) async {
    final db = await SqlHelper.db();

    await db.update(
      'game',
      game.toMap(),
      where: 'g_id = ?',
      whereArgs: [game.id],
    );
  }

  /// Inserts a [Player] into the db.
  static Future<Player> createPlayer(Player player) async {
    final db = await SqlHelper.db();

    final id = await db.insert(
      'player',
      player.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return player.copy(id: id);
  }

  /// Returns the [Player] list of the [Game] with the given [gId].
  static Future<List<Player>> getPlayers(int gId) async {
    final db = await SqlHelper.db();

    final List<Map<String, dynamic>> maps = await db.query(
      'player',
      where: 'g_id = ?',
      whereArgs: [gId],
    );
    return List.generate(maps.length, (i) {
      return Player.fromMap(maps[i]);
    });
  }

  /// Updates the given [player] in the db.
  static Future<void> updatePlayer(Player player) async {
    final db = await SqlHelper.db();

    await db.update(
      'player',
      player.toMap(),
      where: 'p_id = ?',
      whereArgs: [player.id],
    );
  }

  /// Deletes the given player from the db.
  static Future<void> deletePlayer(int id) async {
    final db = await SqlHelper.db();

    await db.delete(
      'player',
      where: 'p_id = ?',
      whereArgs: [id],
    );
  }
}
