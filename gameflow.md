# Gameflow
This document aims to provide an overview of the game flow.
This should ease implementation efforts.

## First glance
- SetUpGame()
- While not HasGameEnded():
    - PlayTurn()
- EndGame()

## Zoomed in view
- SetUpGame
    - ChooseRuleSet()
    - InitGame()
- Do:
    - PlayTurn
        - actions = GetPlayableActions()
        - PlayAction(actions[x]) *// x | 0 >= x > len(actions)*
        - CurrentPlayer = (CurrentPlayer + 1) % len(Players)
        - DisplayOnlyVisibleInformation(CurrentPlayer)
    - While not HasGameEnded()
- EndGame
    - DisplayStats()

### SetUpGame
Set the environment before normal gameplay can proceed.
Order of actions may not matter for some steps:
- ChooseRuleSet()  *// which includes...*
    - SelectCardSet()
    - SetAvailableTokens()
    - SelectNumberOfPlayers()
    - DetermineFirstPlayer()
- InitGame() *// which includes...*
    - ShuffleDeck(seed)
    - DealCards()
    - CurrentPlayer = 0
    - DisplayOnlyVisibleInformation(CurrentPlayer)

### HasGameEnded
Returns true if and only if any of the following conditions are met:
- No further advancement towards game goal is possible *(generalisation)*
- FuseTokens == 0
- len(ActionsPlayedAfterEmptyDeck) == len(Players)

### PlayTurn
- actions = GetPlayableActions()
- PlayAction(actions[x]) *// player must choose `x | 0 >= x > len(actions)`*
- CurrentPlayer = (CurrentPlayer + 1) % len(Players)
- DisplayOnlyVisibleInformation(CurrentPlayer)

### EndGame
- DisplayStats()
