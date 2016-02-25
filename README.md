# Dartmuti
Dartmuti aims to be a simple turn-based game playable on web browsers.
The design is heavily inspired by [The Great Dalumti](https://en.wikipedia.org/wiki/The_Great_Dalmuti).
The previous is based on [President](https://en.wikipedia.org/wiki/President_(card_game))
also known by the names of *Capitalism* and *Asshole* among others.
And this game shares many similarities with [Dai Hin Min](https://en.wikipedia.org/w/index.php?title=Dai_Hin_Min) which in turn resembles other games as well.

## Why
To try the beta of [AngularJS 2](https://angular.io/) out from scratch.
More specifically the [Dart](https://www.dartlang.org/) implementation of said framework.
A playful light card game seemed fit for the project.

## Developing
### Setup
1. Get [Dart](https://www.dartlang.org/) and [Dartium](https://www.dartlang.org/tools/dartium/)
  - MacOS
    - `brew tap dart-lang/dart`
    - `brew install dart --with-content-shell --with-dartium`
  - For other OS [see documentation](https://www.dartlang.org/downloads/)

2. Get all dependencies
  - `pub get`

3. Serve the files (any HTTP server should work)
  - `python -m SimpleHTTPServer`

4. Navigate it through!
  - Open `dartium`
  - Go to `http://0.0.0.0:8000/web/` by default
  - Also check out [Observatory](https://dart-lang.github.io/observatory/)

5. **If you don't want to Dartium...**
  - You may skip steps 3 and 4. Just type `pub serve` instead.
  - By default, type `http://localhost:8080` in your browser navigation bar.
  - It will be slower, as it needs to compile the Dart code into JavaScript...

### Contributing
Apply [dartfmt](https://github.com/dart-lang/dart_style) to your code before
you push to the repository, to get nice formatting.
`dartfmt -w . | grep Formatted`

### Version 0.0.1
- Add as many players as you want
- Support for the basic 80 card deck (minus 2 jokers)
- Customisable random seed
