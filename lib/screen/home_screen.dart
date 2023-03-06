import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<List> data = [];
  int? newNo;
  AnimationController? _controller;
  Animation<double>? _animation;

  bool isOver = false;
  var h, w;

  @override
  void initState() {
    super.initState();

    setUpData();
  }

  void setUpData() {
    data = [
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
    ];
    isOver = false;

    Function deepEq = const ListEquality().equals;

    int ran1 = Random().nextInt(4);
    int ran2 = Random().nextInt(4);
    data[ran1][ran2] = getNewData();

    int ran3 = 0;
    int ran4 = 0;

    do {
      ran3 = Random().nextInt(4);
      ran4 = Random().nextInt(4);
    } while (deepEq([ran1, ran2], [ran3, ran4]));
    data[ran3][ran4] = getNewData();

    setState(() {});
  }

  int getNewData() {
    int no = Random().nextInt(10);
    return no == 0 ? 4 : 2;
  }

  void addNewData() {
    int ran3 = 0;
    int ran4 = 0;

    do {
      ran3 = Random().nextInt(4);
      ran4 = Random().nextInt(4);
    } while (data[ran3][ran4] != 0);
    newNo = (ran3 * 4) + ran4;
    data[ran3][ran4] = getNewData();
    setAnimation();
  }

  void setAnimation() {
    _controller = AnimationController(
      duration: const Duration(
        milliseconds: 300,
      ),
      vsync: this,
      value: 0.1,
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height * 0.55;
    w = MediaQuery.of(context).size.height * 0.55;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("2048"),
          backgroundColor: Colors.brown,
        ),
        body: Column(
          children: [
            Container(
              height: h,
              width: h,
              child: GestureDetector(
                // onHorizontalDragEnd: (details) {
                //   if (details.primaryVelocity! > 0) {
                //     onLeftSwipe();
                //   } else if (details.primaryVelocity! < 0) {
                //     onRightSwipe();
                //   }
                // },
                // onVerticalDragEnd: (details) {
                //   if (details.primaryVelocity! > 0) {
                //     onDownSwipe();
                //   } else if (details.primaryVelocity! < 0) {
                //     onTopSwipe();
                //   }
                // },
                child: GridView.builder(
                  itemCount: 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                  ),
                  itemBuilder: (context, index) => Container(
                    color: Color(0xffBBADA0),
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                      ),
                      itemBuilder: (context, index) {
                        return newNo == index
                            ? ScaleTransition(
                                scale: _animation!,
                                child: box(index: index),
                              )
                            : box(index: index);
                      },
                      itemCount: 16,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                button(onLeftSwipe, Icons.arrow_back_ios),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    button(onTopSwipe, Icons.keyboard_arrow_up),
                    button(onDownSwipe, Icons.keyboard_arrow_down_rounded),
                  ],
                ),
                button(onRightSwipe, Icons.arrow_forward_ios_rounded),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                setUpData();
              },
              child: Text("refresh"),
            ),
          ],
        ),
      ),
    );
  }

  Widget button(void Function() applyDirection, str) => InkWell(
        onTap: () {
          applyDirection();
        },
        child: Container(
            height: h * 0.20,
            width: w * 0.20,
            margin: EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color(0xff9be9ff),
                borderRadius: BorderRadius.circular(20)),
            child: Icon(str)),
      );

  Widget box({required int index}) {
    var total = data[index ~/ 4][index % 4];
    return Container(
      height: 30,
      width: 30,
      margin: EdgeInsets.all(5),
      alignment: Alignment.center,
      // color: changeColor(total),
      decoration: BoxDecoration(
          color: changeColor(total), borderRadius: BorderRadius.circular(10)),
      child: Text(
        total == 0 ? "" : "$total",
        style: TextStyle(
            fontSize: 30, color: Colors.brown, fontWeight: FontWeight.bold),
      ),
    );
  }

  void applyTop() {
    int temp = 0;
    bool isSwap = false;
    for (int i = 3; i > 0; i--) {
      for (int j = 0; j < 4; j++) {
        if (data[i][j] != 0 && data[i - 1][j] == 0) {
          temp = data[i][j];
          data[i][j] = 0;
          data[i - 1][j] = temp;
          isSwap = true;
        }
      }
    }
    print("#");

    if (isSwap) {
      applyTop();
    }
  }

  void applyDown() {
    int temp = 0;
    bool isSwap = false;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 4; j++) {
        if (data[i][j] != 0 && data[i + 1][j] == 0) {
          temp = data[i][j];
          data[i][j] = 0;
          data[i + 1][j] = temp;
          isSwap = true;
        }
      }
    }

    if (isSwap) {
      applyDown();
    }
  }

  void applyLeft() {
    int temp = 0;
    bool isSwap = false;
    for (int i = 0; i < 4; i++) {
      for (int j = 3; j >= 1; j--) {
        if (data[i][j] != 0 && data[i][j - 1] == 0) {
          temp = data[i][j];
          data[i][j] = 0;
          data[i][j - 1] = temp;
          isSwap = true;
        }
      }
    }

    if (isSwap) {
      applyLeft();
    }
  }

  void applyRight() {
    int temp = 0;
    bool isSwap = false;
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 3; j++) {
        if (data[i][j] != 0 && data[i][j + 1] == 0) {
          temp = data[i][j];
          data[i][j] = 0;
          data[i][j + 1] = temp;
          isSwap = true;
        }
      }
    }

    if (isSwap) {
      applyRight();
    }
  }

  void onGeneralSwipe(void Function() applyGravity, bool isVertical) {
    if (isOver) {
      return;
    }

    List tempList = data.map((e) => List.from(e)).toList();
    applyGravity();
    if (isVertical) {
      mergeVertical();
    } else {
      mergeHorizontal();
    }
    applyGravity();

    Function deepEq = const ListEquality().equals;

    var checks = tempList
        .asMap()
        .entries
        .map((e) => deepEq(e.value, data[e.key]))
        .toList();

    if (checks.contains(false)) {
      addNewData();
      checkWin();
      setState(() {});
    }
  }

  void onDownSwipe() {
    onGeneralSwipe(applyDown, true);
  }

  void onTopSwipe() {
    onGeneralSwipe(applyTop, true);
  }

  void onLeftSwipe() {
    onGeneralSwipe(applyLeft, false);
  }

  void onRightSwipe() {
    onGeneralSwipe(applyRight, false);
  }

  void mergeVertical() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 4; j++) {
        if (data[i][j] == data[i + 1][j]) {
          data[i][j] *= 2;
          data[i + 1][j] = 0;
        }
      }
    }
  }

  void mergeHorizontal() {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 3; j++) {
        if (data[i][j] == data[i][j + 1]) {
          data[i][j] *= 2;
          data[i][j + 1] = 0;
        }
      }
    }
  }

  Color changeColor(
    int total,
  ) {
    Map colorList = {
      0: Colors.brown.shade50,
      2: Colors.brown.shade100,
      4: Colors.purple.shade100,
      8: Colors.indigo.shade100,
      16: Colors.blue.shade100,
      32: Colors.green.shade100,
      64: Colors.amber,
      128: Colors.orange,
      256: Colors.red.shade400,
    };
    List noList = [0, 2, 4, 8, 16, 32, 64, 128, 256];

    // print("============== >>>>> ${noList.indexOf(total)}");

    return colorList[total] != null ? colorList[total] : Colors.brown.shade50;
  }

  void checkWin() {
    if (!shouldCountinues()) {
      isOver = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Game is Over"),
          behavior: SnackBarBehavior.fixed,
        ),
      );
    }
  }

  bool shouldCountinues() {
    if (data.map((e) => e.contains(0)).toList().contains(true)) {
      return true;
    }
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if ((i != data.length - 1 && data[i][j] == data[i + 1][j]) ||
            (j != data.length - 1 && data[i][j] == data[i][j + 1])) {
          return true;
        }
      }
    }
    return false;
  }
}

/*
* for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if ((i != data.length-1 ) && ( j != data.length-1 )) {
          if ( (data[i][j] == data[i + 1][j]) || (data[i][j] == data[i][j + 1])) {

        //    print("Vertical = ${data[i][j]} ${data[i + 1][j]}");
         //   print("Horizontal = ${data[i][j]} ${data[i][j+1]}");
            ShouldContinues = true;
            break;
          }
        }
      }
    }
*
* */
