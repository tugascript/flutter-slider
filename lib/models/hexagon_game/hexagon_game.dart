import 'package:flutter/rendering.dart';

import '../base/game.dart';
import '../base/position.dart';
import '../enums/game_status_enum.dart';
import 'hexagon_next.dart';
import 'triangular_piece.dart';

class HexagonGame implements Game {
  @override
  final List<List<TriangularPiece>> puzzle;
  @override
  final GameStatusEnum status;
  @override
  final HexagonNext next;

  const HexagonGame({
    required this.next,
    required this.status,
    required this.puzzle,
  });

  @override
  factory HexagonGame.newGame(int level) {
    final edgeLen = level + 1;
    final halfLen = edgeLen * 2;
    final len = halfLen * 2;
    final puzzle = <List<TriangularPiece>>[];

    bool inverted = true;
    int innerLen = edgeLen;
    for (int i = 0; i < len; i++) {
      final row = <TriangularPiece>[];

      for (int j = 0; j < innerLen; j++) {
        row.add(
          TriangularPiece(Position(i, j), inverted),
        );
      }

      puzzle.add(row);
      inverted = !inverted;

      if (!inverted) {
        if (i < halfLen) {
          innerLen++;
        } else {
          innerLen--;
        }
      }
    }

    final next = HexagonNext(
      normal: Position(len - 1, level),
      inverted: Position(len - 2, edgeLen),
    );
    puzzle[next.normal.row][next.normal.column].empty = true;
    puzzle[next.inverted.row][next.inverted.column].empty = true;

    return HexagonGame(
      next: next,
      status: GameStatusEnum.starting,
      puzzle: puzzle,
    );
  }

  @override
  HexagonGame handleMove(Position pos) {
    final puzzle = this.puzzle;
    final len = puzzle.length;
    final halfLen = (len / 2).floor();
    final edgeLen = (halfLen / 2).floor();
    // variables
    GameStatusEnum status = this.status;

    if (pos.row < len) {
      final currentRow = puzzle[pos.row];

      if (pos.column < currentRow.length) {
        final piece = currentRow[pos.column];
        final halfIndex = halfLen + 1;
        final nNext = next.normal;
        final iNext = next.inverted;

        if (nNext.row > iNext.row) {
          // Pieces move diagonally
          if (nNext.column < halfLen &&
              pos.column < halfIndex &&
              pos.column == nNext.column) {
            _changeDiagonalRow(puzzle, pos.row, pos.column, nNext.row);
          } else {}
        } else {}
      }
    }

    return this;
  }

  @override
  HexagonGame addImageToGame(List<List<CustomPainter>> painters) {
    return this;
  }

  @override
  HexagonGame shuffleGame(int shuffles) {
    return this;
  }

  @override
  HexagonGame updateStatus(GameStatusEnum st) {
    return this;
  }

  void _changeDiagonalRow(
    List<List<TriangularPiece>> puzzle,
    int row,
    int column,
    int nextRow,
  ) {
    if (row < nextRow) {
      // ISTO TEM DE ANDAR 2 E NÃO 1
      for (int i = nextRow; i > row; i--) {
        final currentOne = puzzle[i][column];
        final prevOne = puzzle[i - 1][column];
        puzzle[i][column] = prevOne;
        puzzle[i - 1][column] = currentOne;
      }
    } else {
      for (int i = nextRow; i < row; i++) {
        final currentOne = puzzle[i][column];
        final nextOne = puzzle[i + 1][column];
        puzzle[i][column] = nextOne;
        puzzle[i + 1][column] = currentOne;
      }
    }
  }
}
