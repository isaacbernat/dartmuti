class Card {
    final int ID;
    final int value;
    final String name;

    Card(this.ID, this.value, [this.name]);

    String toString() => '$ID: $value ($name)';
}
