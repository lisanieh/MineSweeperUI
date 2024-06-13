# MineSweeperUI
a testing UI for minesweeper

## initial setups
1. download flutter from the website: https://docs.flutter.dev/get-started/install
2. create a new dart file, then replace the code in both `lib/` and `pubspec.yamel`
3. be sure to put both `home` and `main` into the `lib/` folder
4. connect to a mobile device or a virtual device to test it!

### changes in `pubspec.yamel`
```
dependencies:
  flutter:
    sdk: flutter
  minesweeper:
    git:
      url: https://github.com/lisanieh/MineSweeper.git
      ref: master
  fluttertoast: ^8.2.4
```
