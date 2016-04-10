# Dartmuti
Dartmuti aims to be a simple turn-based game playable on web browsers.
The design is heavily inspired by [The Great Dalumti](https://en.wikipedia.org/wiki/The_Great_Dalmuti).
The previous is based on [President](https://en.wikipedia.org/wiki/President_(card_game))
also known by the names of *Capitalism* and *Asshole* among others.
And this game shares many similarities with [Dai Hin Min](https://en.wikipedia.org/w/index.php?title=Dai_Hin_Min) which in turn resembles other games as well.

A WIP version may be tried live [here](http://isaacbernat.github.io/dartmuti/).

## Why
To try the beta of [AngularJS 2](https://angular.io/) out from scratch.
More specifically the [Dart](https://www.dartlang.org/) implementation of said framework.
A playful light card game seemed fit for the project.

## How to play?
### Glossary of terms
| Name          | Definition                                                                  |
|---------------|-----------------------------------------------------------------------------|
| Active player | a player who still has cards remaining in their hand.                       |
| Hand          | set of cards belonging to a player.                                         |
| Round         | game division made of consecutive turns (more of this in it's own section). |
| Trick         | set of cards a player put into play (more of this in it's own section).     |
| Turn          | smallest game division where a given active player passes or plays a trick. |

### Goal
The goal of the game is to get rid of one's cards as soon as possible.
Players are ranked according to their finishing order (e.g. 1st, 3rd, etc.)

### Deck of cards
- The deck of cards consists of 78 cards.
- Cards have a numerical value ranging from 1 to 12.
- There are as many cards of each value as their value number. E.g. 5 cards valued 5, but only 2 cards with value 2.
- Cards are dealt randomly to each player in a way that all players have the same amount of cards.
- Excess cards are discarded.

### Tricks
- A trick is a set of cards whith the same value.
- A trick is build from a single player's hand.
- A trick may only be build (and played) when it's that player's turn.
- A trick must have lower values to beat other tricks.
- A trick must have at least the same amount of cards to beat other tricks.
- **Exception**: the trick made with a single card with value 1.

#### Examples:
| New trick | Beats | Previous trick |
|-----------|-------|----------------|
| [4]       | yes   | [5]            |
| [4]       | no    | [4]            |
| [4, 4]    | no    | [4]            |
| [4, 4]    | yes   | [5]            |
| [4, 4]    | yes   | [5, 5]         |
| [4, 4]    | no    | [5, 5, 5]      |
| [4, 4, 4] | yes   | [5, 5]         |
| [1]       | yes   | any trick      |

### Rounds
- A round is a set of turns played in clockwise order.
- The first round is started by the first player.
- A round ends when all active players have passed.
- When a round ends all tricks in play are discarded.
- A round starts with the active player closest to the one who passed last.
- **Note**: The player who passed last is the closest one. Distance is clockwise.

## Developing
### Setup
1. Get [Dart](https://www.dartlang.org/) and [Dartium](https://www.dartlang.org/tools/dartium/)
  - MacOS
    - `brew tap dart-lang/dart`
    - `brew install dart --with-content-shell --with-dartium`
  - For other OS [see documentation](https://www.dartlang.org/downloads/)

2. Get all dependencies
  - `pub get`

3. Serve the files within `dartmuti/dartmuti/web` directory (any HTTP server should work)
  - `python -m SimpleHTTPServer 8080`

4. Open the browser
  - Open `dartium`
  - Also check out [Observatory](https://dart-lang.github.io/observatory/)
  - Opening the console will show you which url is running on.

5. Navigate it through!
  - Go to `http://0.0.0.0:8080/`

6. **If you don't want Dartium...**
  - You may skip steps 3 and 4. Just type `pub serve` instead (from `dartmuti/dartmuti`).
  - It will be slower, as it needs to compile the Dart code into JavaScript...

### Contributing
Apply [dartfmt](https://github.com/dart-lang/dart_style) to your code before
you push to the repository, to get nice formatting.
`dartfmt -w . | grep Formatted`

#### TODOs
In no specific order:

- Port stylesheet to SASS and clean it up.
- GUI/UX improvements.
- Artwork + style improvements.
- More customisable logic (e.g. decks, comparison rules, support jokers).
- Responsive design.
- Sample AI to play using this API.
- Central server to take care of all API calls to remote players, CORS, etc.
- Refactor (you didn't expect that one, did you?).
- Tests.
- Stats.
- etc.

### Versions
#### 0.1.2
- Add game play instructions
- Add support for remote players via endpoint calls
- Sample remote player server written in Dart

#### 0.1.1
- Remove players
- Settings tab to more easily configure gameplay
- Minor style improvements

#### 0.1.0
- Add as many players as you want
- Support for the basic 80 card deck (minus 2 jokers)
- Customisable random seed
