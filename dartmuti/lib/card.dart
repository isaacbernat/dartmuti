class Card {
  final int ID;
  final int value;
  final String name;
  bool selected = false;

  Card(this.ID, this.value, [this.name]);

  void toggleSelected() {
    this.selected = !selected;
  }

  String toString() => '$ID: $value ($name)';
}
