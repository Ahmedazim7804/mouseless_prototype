class Window {
  final bool isActive;
  final int row;
  final int col;
  final int strechRows;
  final int strechCols;
  final int id;

  List<int> get occupyingRows =>
      List.generate(strechRows + 1, (index) => row + index);
  List<int> get occupyingCols =>
      List.generate(strechCols + 1, (index) => col + index);

  Window({
    required this.isActive,
    required this.id,
    required this.row,
    required this.col,
    required this.strechRows,
    required this.strechCols,
  });

  Window copyWith({
    bool? isActive,
    int? row,
    int? col,
    int? strechRows,
    int? strechCols,
  }) {
    return Window(
      isActive: isActive ?? this.isActive,
      id: id,
      row: row ?? this.row,
      col: col ?? this.col,
      strechRows: strechRows ?? this.strechRows,
      strechCols: strechCols ?? this.strechCols,
    );
  }
}
