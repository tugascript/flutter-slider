import 'package:flutter/material.dart';
import 'package:v1/models/enums/game_type_enum.dart';
import 'package:v1/widgets/home_screen/start_game.dart';

import '../models/enums/difficulty_enum.dart';
import '../utilities/sizes/app_bar_sizes.dart';
import '../utilities/sizes/break_point.dart';
import '../utilities/sizes/home_screen_sizes.dart';
import '../widgets/home_screen/animated_icon.dart';
import '../widgets/home_screen/difficulty_input/difficulty_input.dart';
import '../widgets/home_screen/select_game.dart';
import '../widgets/layout/normal_icon.dart';
import '../widgets/layout/theme_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _difficultyIndex = 0;
  int _gameIndex = 0;

  void _changeDifficulty(int i) {
    setState(() {
      _difficultyIndex = i;
    });
  }

  void _changeGame(int i) {
    setState(() {
      _gameIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final appbarSizes = AppBarSizes.getAppBarSizes(width);
    final sizes = HomeScreenSizes.getHomeScreenSizes(width);
    final breakPoint = BreakPoint(width);
    final theme = Theme.of(context);
    final isLightTheme = theme.colorScheme.primary.value == 0xFF02569B;

    final widgets = <Widget>[
      LocalAnimatedIcon(size: sizes.buttonWidth),
      DifficultyInput(
        difficultyIndex: _difficultyIndex,
        changeDifficulty: _changeDifficulty,
      ),
      SelectGame(
        currentIndex: _gameIndex,
        changeGame: _changeGame,
      ),
      StartGame(
        difficulty: _kDifficulties[_difficultyIndex],
        gameType: _kGameTypes[_gameIndex],
      ),
    ];

    Widget _buildHomeScreen() {
      final children = <Widget>[];
      final initial = breakPoint.greatLG ? 1 : 0;

      for (int i = initial; i < 4; i++) {
        children.addAll([
          widgets[i],
          SizedBox(
            height: sizes.marginBottom,
          ),
        ]);
      }

      final column = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      );

      return breakPoint.greatLG
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widgets[0],
                SizedBox(
                  width: sizes.marginBottom * 3,
                ),
                column,
              ],
            )
          : column;
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: appbarSizes.height,
        title: Row(
          children: [
            NormalIcon(size: appbarSizes.icon),
            SizedBox(
              width: appbarSizes.title,
            ),
            Text(
              'Flutter ',
              style: TextStyle(
                fontSize: appbarSizes.title,
                fontWeight: FontWeight.w600,
                color: isLightTheme
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onPrimary,
              ),
            ),
            Text(
              'Slidder',
              style: TextStyle(
                fontSize: appbarSizes.title,
                fontWeight: FontWeight.w600,
                color: isLightTheme
                    ? theme.primaryColorLight
                    : theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
        actions: [
          const ThemeButton(),
          SizedBox(
            width: appbarSizes.title * 0.8,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: _buildHomeScreen(),
        ),
      ),
    );
  }
}

const _kDifficulties = <DifficultyEnum>[
  DifficultyEnum.easy,
  DifficultyEnum.medium,
  DifficultyEnum.hard,
];

const _kGameTypes = <GameTypeEnum>[
  GameTypeEnum.classic,
  GameTypeEnum.hexagon,
];
