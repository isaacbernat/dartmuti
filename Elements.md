# Elements
This document aims to provide an overview of the game elements.
This should ease implementation efforts.

## A first glance
- Players `[]Player`
  - StartPosition `Integer`
  - EndPosition `Integer`
  - Hand `[]Card`

- GameArea `TableTop`
  - DiscardPile `[]Card`
  - CurrentTricks `[][]Card`
  - CurrentPassedPlayers `[]Integer`
