class Tabletop {
  String name;
  List<int> discardPile;
  List<List<int>> currentTricks;
  List<int> currentPassedPlayers;

  Tabletop(this.name, [this.discardPile, this.currentTricks, this.currentPassedPlayers]);

  String toString() => '$name -> trick to beat: $currentTricks.last . $discardPile.length cards discarded.';
}
