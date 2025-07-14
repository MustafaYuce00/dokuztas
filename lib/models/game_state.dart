enum GamePhase { placing, moving }

enum Player { red, blue }

class GameState {
  GamePhase phase = GamePhase.placing;
  Player currentPlayer = Player.red;
  List<Player?> board = List.filled(9, null); // 9 positions on the board
  int redStonesPlaced = 0;
  int blueStonesPlaced = 0;
  int? selectedStoneIndex;
  int redWins = 0;
  int blueWins = 0;
  bool gameEnded = false;
  Player? winner;

  // Dot positions on 3x3 grid (grid coordinates)
  static const List<List<int>> dotPositions = [
    [0, 0], // 0: top-left
    [1, 0], // 1: top-center
    [2, 0], // 2: top-right
    [0, 1], // 3: middle-left
    [1, 1], // 4: center
    [2, 1], // 5: middle-right
    [0, 2], // 6: bottom-left
    [1, 2], // 7: bottom-center
    [2, 2], // 8: bottom-right
  ];

  // Valid connections between dots
  static const List<List<int>> connections = [
    [1, 3, 4], // 0: connects to 1, 3, 4
    [0, 2, 4], // 1: connects to 0, 2, 4
    [1, 4, 5], // 2: connects to 1, 4, 5
    [0, 4, 6], // 3: connects to 0, 4, 6
    [0, 1, 2, 3, 5, 6, 7, 8], // 4: center connects to all
    [2, 4, 8], // 5: connects to 2, 4, 8
    [3, 4, 7], // 6: connects to 3, 4, 7
    [4, 6, 8], // 7: connects to 4, 6, 8
    [4, 5, 7], // 8: connects to 4, 5, 7
  ];

  // Winning lines (indices of dots that form winning lines)
  static const List<List<int>> winningLines = [
    [0, 1, 2], // top row
    [3, 4, 5], // middle row
    [6, 7, 8], // bottom row
    [0, 3, 6], // left column
    [1, 4, 7], // center column
    [2, 5, 8], // right column
    [0, 4, 8], // diagonal
    [2, 4, 6], // diagonal
  ];

  bool canMoveTo(int fromIndex, int toIndex) {
    return connections[fromIndex].contains(toIndex) && board[toIndex] == null;
  }

  List<int> getValidMoves(int fromIndex) {
    return connections[fromIndex].where((index) => board[index] == null).toList();
  }

  bool checkWin() {
    for (var line in winningLines) {
      if (board[line[0]] != null &&
          board[line[0]] == board[line[1]] &&
          board[line[1]] == board[line[2]]) {
        winner = board[line[0]];
        gameEnded = true;
        if (winner == Player.red) {
          redWins++;
        } else {
          blueWins++;
        }
        return true;
      }
    }
    return false;
  }

  void switchPlayer() {
    currentPlayer = currentPlayer == Player.red ? Player.blue : Player.red;
  }

  void resetGame() {
    phase = GamePhase.placing;
    currentPlayer = Player.red;
    board = List.filled(9, null);
    redStonesPlaced = 0;
    blueStonesPlaced = 0;
    selectedStoneIndex = null;
    gameEnded = false;
    winner = null;
  }

  int get totalStonesPlaced => redStonesPlaced + blueStonesPlaced;
  
  bool get allStonesPlaced => redStonesPlaced == 3 && blueStonesPlaced == 3;
}
