/* Developed by Eng Mouaz M AlShahmeh */
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'لعبة السلالم والأفاعي',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [Locale('ar', 'SA'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: const LaddersAndSnacks(),
    );
  }
}

class LaddersAndSnacks extends StatefulWidget {
  const LaddersAndSnacks({Key? key}) : super(key: key);

  @override
  State<LaddersAndSnacks> createState() => _LaddersAndSnacksState();
}

class _LaddersAndSnacksState extends State<LaddersAndSnacks> {
  int currentDiceNumber = 0;
  int turns = 0;
  int rows = 0;
  int columns = 0;
  int currentBoardNumber = 0;
  bool win = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('لعبة السلالم والأفاعي'),
      ),
      body: win
          ? InkWell(
              onTap: () {
                setState(() {
                  win = false;
                  currentBoardNumber = 0;
                  rows = 0;
                  columns = 0;
                  currentDiceNumber = 0;
                  turns = 0;
                });
              },
              child: const SizedBox(
                  child: Center(
                      child: Text(
                'ابدأ لعبة جديدة',
                style: TextStyle(fontSize: 50, color: Colors.green),
              ))),
            )
          : Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: const DecoratedBox(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: ExactAssetImage('assets/images/board.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width / 10.0 * columns,
                          0.0,
                          0.0,
                          MediaQuery.of(context).size.height *
                              0.5 /
                              10.0 *
                              rows,
                        ),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 10.0,
                              height: MediaQuery.of(context).size.height *
                                  0.5 /
                                  10.0,
                              child: const AnimatedSlide(
                                offset: Offset(0.0, 0.0),
                                duration: Duration(seconds: 2),
                                child: Icon(
                                  Icons.circle,
                                  color: Colors.blue,
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                InkWell(
                  onTap: () {
                    if (win == false) {
                      setState(() {
                        Future.delayed(const Duration(seconds: 1), () {
                          turns += 1;
                          currentDiceNumber = rollDice();
                          if (currentBoardNumber + currentDiceNumber == 100) {
                            win = true;
                            currentBoardNumber = 0;
                            rows = 0;
                            columns = 0;
                            currentDiceNumber = 0;
                            turns = 0;
                            Fluttertoast.showToast(
                              msg: 'تهانينا، لقد فزت باللعبة!',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 15.0,
                            );
                            setState(() {});
                          } else if (currentBoardNumber + currentDiceNumber >
                              100) {
                            Fluttertoast.showToast(
                              msg: 'حاول مجدداً، لقد تجاوزت حد ال 100!',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 15.0,
                            );
                          } else {
                            currentBoardNumber += currentDiceNumber;
                            setRowAndColumn();
                            if (isLadder() != 0) {
                              currentBoardNumber = isLadder();
                              setRowAndColumn();
                              Fluttertoast.showToast(
                                msg: 'لقد صعدت عبر السلم!',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 15.0,
                              );
                            } else if (isSnack() != 0) {
                              currentBoardNumber = isSnack();
                              setRowAndColumn();
                              Fluttertoast.showToast(
                                msg: 'لقد وقعت في شرك الأفعى!',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 15.0,
                              );
                            } else {}
                          }
                        });
                      });
                    } else {}
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: currentDiceNumber == 0
                        ? const SizedBox(
                            child: Center(
                                child: Text(
                            'ابدأ اللعبة',
                            style: TextStyle(fontSize: 30, color: Colors.green),
                          )))
                        : AnimatedRotation(
                            curve: Curves.easeInOut,
                            turns: 3.14 * 2 * turns,
                            duration: const Duration(seconds: 1),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: ExactAssetImage(
                                      'assets/images/dice$currentDiceNumber.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: currentBoardNumber == 0
                        ? const SizedBox()
                        : SizedBox(
                            child: Center(
                                child: Text(
                            ' اللاعب في رقم $currentBoardNumber ',
                            style: const TextStyle(
                                fontSize: 30, color: Colors.blue),
                          )))),
              ],
            ),
    );
  }

  int isLadder() {
    if (currentBoardNumber == 1) {
      return 38;
    } else if (currentBoardNumber == 4) {
      return 14;
    } else if (currentBoardNumber == 8) {
      return 30;
    } else if (currentBoardNumber == 21) {
      return 42;
    } else if (currentBoardNumber == 28) {
      return 76;
    } else if (currentBoardNumber == 50) {
      return 67;
    } else if (currentBoardNumber == 71) {
      return 92;
    } else if (currentBoardNumber == 88) {
      return 99;
    } else {
      return 0;
    }
  }

  int isSnack() {
    if (currentBoardNumber == 32) {
      return 10;
    } else if (currentBoardNumber == 36) {
      return 6;
    } else if (currentBoardNumber == 48) {
      return 26;
    } else if (currentBoardNumber == 62) {
      return 18;
    } else if (currentBoardNumber == 88) {
      return 24;
    } else if (currentBoardNumber == 95) {
      return 56;
    } else if (currentBoardNumber == 97) {
      return 78;
    } else {
      return 0;
    }
  }

  void setRowAndColumn() {
    setState(() {
      if (currentBoardNumber == 1) {
        rows = 0;
        columns = 0;
      } else if (currentBoardNumber == 2 ||
          currentBoardNumber == 3 ||
          currentBoardNumber == 4 ||
          currentBoardNumber == 5 ||
          currentBoardNumber == 6 ||
          currentBoardNumber == 7 ||
          currentBoardNumber == 8 ||
          currentBoardNumber == 9 ||
          currentBoardNumber == 10) {
        rows = 0;
        columns = currentBoardNumber - 1;
      } else if (currentBoardNumber == 11) {
        rows = 1;
        columns = 9;
      } else if (currentBoardNumber == 12) {
        rows = 1;
        columns = 8;
      } else if (currentBoardNumber == 13) {
        rows = 1;
        columns = 7;
      } else if (currentBoardNumber == 14) {
        rows = 1;
        columns = 6;
      } else if (currentBoardNumber == 15) {
        rows = 1;
        columns = 5;
      } else if (currentBoardNumber == 16) {
        rows = 1;
        columns = 4;
      } else if (currentBoardNumber == 17) {
        rows = 1;
        columns = 3;
      } else if (currentBoardNumber == 18) {
        rows = 1;
        columns = 2;
      } else if (currentBoardNumber == 19) {
        rows = 1;
        columns = 1;
      } else if (currentBoardNumber == 20) {
        rows = 1;
        columns = 0;
      } else if (currentBoardNumber == 21) {
        rows = 2;
        columns = 0;
      } else if (currentBoardNumber == 22) {
        rows = 2;
        columns = 1;
      } else if (currentBoardNumber == 23) {
        rows = 2;
        columns = 2;
      } else if (currentBoardNumber == 24) {
        rows = 2;
        columns = 3;
      } else if (currentBoardNumber == 25) {
        rows = 2;
        columns = 4;
      } else if (currentBoardNumber == 26) {
        rows = 2;
        columns = 5;
      } else if (currentBoardNumber == 27) {
        rows = 2;
        columns = 6;
      } else if (currentBoardNumber == 28) {
        rows = 2;
        columns = 7;
      } else if (currentBoardNumber == 29) {
        rows = 2;
        columns = 8;
      } else if (currentBoardNumber == 30) {
        rows = 2;
        columns = 9;
      } else if (currentBoardNumber == 31) {
        rows = 3;
        columns = 9;
      } else if (currentBoardNumber == 32) {
        rows = 3;
        columns = 8;
      } else if (currentBoardNumber == 33) {
        rows = 3;
        columns = 7;
      } else if (currentBoardNumber == 34) {
        rows = 3;
        columns = 6;
      } else if (currentBoardNumber == 35) {
        rows = 3;
        columns = 5;
      } else if (currentBoardNumber == 36) {
        rows = 3;
        columns = 4;
      } else if (currentBoardNumber == 37) {
        rows = 3;
        columns = 3;
      } else if (currentBoardNumber == 38) {
        rows = 3;
        columns = 2;
      } else if (currentBoardNumber == 39) {
        rows = 3;
        columns = 1;
      } else if (currentBoardNumber == 40) {
        rows = 3;
        columns = 0;
      } else if (currentBoardNumber == 41) {
        rows = 4;
        columns = 0;
      } else if (currentBoardNumber == 42) {
        rows = 4;
        columns = 1;
      } else if (currentBoardNumber == 43) {
        rows = 4;
        columns = 2;
      } else if (currentBoardNumber == 44) {
        rows = 4;
        columns = 3;
      } else if (currentBoardNumber == 45) {
        rows = 4;
        columns = 4;
      } else if (currentBoardNumber == 46) {
        rows = 4;
        columns = 5;
      } else if (currentBoardNumber == 47) {
        rows = 4;
        columns = 6;
      } else if (currentBoardNumber == 48) {
        rows = 4;
        columns = 7;
      } else if (currentBoardNumber == 49) {
        rows = 4;
        columns = 8;
      } else if (currentBoardNumber == 50) {
        rows = 4;
        columns = 9;
      } else if (currentBoardNumber == 51) {
        rows = 5;
        columns = 9;
      } else if (currentBoardNumber == 52) {
        rows = 5;
        columns = 8;
      } else if (currentBoardNumber == 53) {
        rows = 5;
        columns = 7;
      } else if (currentBoardNumber == 54) {
        rows = 5;
        columns = 6;
      } else if (currentBoardNumber == 55) {
        rows = 5;
        columns = 5;
      } else if (currentBoardNumber == 56) {
        rows = 5;
        columns = 4;
      } else if (currentBoardNumber == 57) {
        rows = 5;
        columns = 3;
      } else if (currentBoardNumber == 58) {
        rows = 5;
        columns = 2;
      } else if (currentBoardNumber == 59) {
        rows = 5;
        columns = 1;
      } else if (currentBoardNumber == 60) {
        rows = 5;
        columns = 0;
      } else if (currentBoardNumber == 61) {
        rows = 6;
        columns = 0;
      } else if (currentBoardNumber == 62) {
        rows = 6;
        columns = 1;
      } else if (currentBoardNumber == 63) {
        rows = 6;
        columns = 2;
      } else if (currentBoardNumber == 64) {
        rows = 6;
        columns = 3;
      } else if (currentBoardNumber == 65) {
        rows = 6;
        columns = 4;
      } else if (currentBoardNumber == 66) {
        rows = 6;
        columns = 5;
      } else if (currentBoardNumber == 67) {
        rows = 6;
        columns = 6;
      } else if (currentBoardNumber == 68) {
        rows = 6;
        columns = 7;
      } else if (currentBoardNumber == 69) {
        rows = 6;
        columns = 8;
      } else if (currentBoardNumber == 70) {
        rows = 6;
        columns = 9;
      } else if (currentBoardNumber == 71) {
        rows = 7;
        columns = 9;
      } else if (currentBoardNumber == 72) {
        rows = 7;
        columns = 8;
      } else if (currentBoardNumber == 73) {
        rows = 7;
        columns = 7;
      } else if (currentBoardNumber == 74) {
        rows = 7;
        columns = 6;
      } else if (currentBoardNumber == 75) {
        rows = 7;
        columns = 5;
      } else if (currentBoardNumber == 76) {
        rows = 7;
        columns = 4;
      } else if (currentBoardNumber == 77) {
        rows = 7;
        columns = 3;
      } else if (currentBoardNumber == 78) {
        rows = 7;
        columns = 2;
      } else if (currentBoardNumber == 79) {
        rows = 7;
        columns = 1;
      } else if (currentBoardNumber == 80) {
        rows = 7;
        columns = 0;
      } else if (currentBoardNumber == 81) {
        rows = 8;
        columns = 0;
      } else if (currentBoardNumber == 82) {
        rows = 8;
        columns = 1;
      } else if (currentBoardNumber == 83) {
        rows = 8;
        columns = 2;
      } else if (currentBoardNumber == 84) {
        rows = 8;
        columns = 3;
      } else if (currentBoardNumber == 85) {
        rows = 8;
        columns = 4;
      } else if (currentBoardNumber == 86) {
        rows = 8;
        columns = 5;
      } else if (currentBoardNumber == 87) {
        rows = 8;
        columns = 6;
      } else if (currentBoardNumber == 88) {
        rows = 8;
        columns = 7;
      } else if (currentBoardNumber == 89) {
        rows = 8;
        columns = 8;
      } else if (currentBoardNumber == 90) {
        rows = 8;
        columns = 9;
      } else if (currentBoardNumber == 91) {
        rows = 9;
        columns = 9;
      } else if (currentBoardNumber == 92) {
        rows = 9;
        columns = 8;
      } else if (currentBoardNumber == 93) {
        rows = 9;
        columns = 7;
      } else if (currentBoardNumber == 94) {
        rows = 9;
        columns = 6;
      } else if (currentBoardNumber == 95) {
        rows = 9;
        columns = 5;
      } else if (currentBoardNumber == 96) {
        rows = 9;
        columns = 4;
      } else if (currentBoardNumber == 97) {
        rows = 9;
        columns = 3;
      } else if (currentBoardNumber == 98) {
        rows = 9;
        columns = 2;
      } else if (currentBoardNumber == 99) {
        rows = 9;
        columns = 1;
      } else if (currentBoardNumber == 100) {
        rows = 9;
        columns = 0;
      }
    });
  }
}

int rollDice() {
  Random random = Random();
  int randomNumber = 1 + random.nextInt(6);
  return randomNumber;
}
