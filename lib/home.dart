import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:minesweeper/minesweeper.dart' as minesweeper;

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //global
  int _seconds = 0;
  int _tseconds = 0;
  int _minutes = 0;
  int _tminutes = 0;
  Timer? _timer;
  var board;
  var flag;
  var click;
  int row = 5;
  int col = 5;
  int mineNum = 10;
  bool first = false;

  //function
  void printBoard(){
    print("the border is : $row * $col");
    for (int i = 0; i < row; i++) {
      List tmp = [];
      for (int j = 0; j < col; j++) {
        tmp.add(board[i * col + j]);
      }
      print(tmp);
    }
  }
  void refreshTime(){
    _seconds = 0;
    _tseconds = 0;
    _minutes = 0;
    _tminutes = 0;
  }
  void genBoard(){
    board = minesweeper.boarderGenerate(row, col, mineNum);
  }
  void refreshBoard(int x,int y){
    var result = minesweeper.minePosition(board, row, col, x, y);
    var minePos = result['minePos'];
    var newBoard = result['board'];
    print("mine position: $minePos");
    printBoard();
  }
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        if(_seconds >= 10){
          _tseconds++;
          _seconds = 0;
        }
        if(_tseconds >= 6){
          _seconds = 0;
          _tseconds = 0;
          _minutes++;
        }
        if(_minutes >= 10){
          _minutes = 0;
          _tminutes++;
        }
        if(_tminutes >= 6){
          refreshTime();
        }
      });
    });
  }
  void stopTimer() {
    _timer?.cancel();
    refreshTime();
  }
  void openAll(){
    for(int i = 0;i < click.length;i++){
      click[i] = 1;
    }
    setState(() {});
  }
  openSquare(int index){
    int x = index ~/ col;
    int y = index % col;
    print("x:$x,y:$y");
    if(!first){
      first = true;
      print("init round");
      refreshBoard(x, y);
      click[index] = 1;
      setState(() {});
    }

    if(board[index] == -1){ //has mine
      print("you failed!");
      Fluttertoast.showToast(msg: "you failed! Try again");
      stopTimer();
      //open the board
      openAll();
    }
    else if(board[index] == 0){//open all adjacent square
      checkAdjacent(index);
    }
    else{
      click[index] = 1;
    }

    //check if the user finish the game
    if(checkWin()){
      print("congradulations!");
      Fluttertoast.showToast(msg: "congradulations!");
      stopTimer();
      //open the board
      openAll();
    }
  }
  bool checkWin(){
    for(int i = 0;i < board.length;i++){
      //not all the non-mine square is chicked
      if(board[i] != -1 && click[i] == 0){
        return false;
      }
    }
    return true;
  }
  void openAdjacent(int new_index,int i,int j){
    //if adjacent square = 0
    if(i==0 || j==0) {
      if(board[new_index] == 0 && click[new_index] == 0){
        checkAdjacent(new_index);
      }
    }
    //if square isn't mine
    if(board[new_index] != -1){
      if(board[new_index] != 0){
        click[new_index] = 1;
      }
      setState(() {});
    }
  }
  void checkAdjacent(int index){
    int left_min = (index < col) ? (-1*col) : ((index ~/ col) - 1)*col;
    int right_min = left_min + col - 1;
    int left_max = left_min + (col*2);
    int right_max = right_min + (col*2);
    int mid_min = left_min + col;
    int mid_max = right_min + col;

    click[index] = 1;
    for(int i = -1;i < 2;i++){
      for(int j = -1;j < 2;j++){
        int new_index = index + (col*j) + i;
        //check if the index isn't overflow
        if(new_index >=0 && new_index < row*col){
          //check top
          if(j == -1){
            if(new_index >= left_min && new_index <= right_min){
              openAdjacent(new_index, i, j);
            }
          }
          //check mid
          else if(j == 0){
            if(new_index >= mid_min && new_index <= mid_max){
              openAdjacent(new_index, i, j);
            }
          }
          //check bottom
          else if(j == 1){
            if(new_index >= left_max && new_index <= right_max){
              openAdjacent(new_index, i, j);
            }
          }
        }
      }
    }
  }
  void putFlag(int index){
    if(click[index] == 1) return;
    if(flag[index] == 0){
      flag[index] = 1;
      mineNum--;
    }
    else{
      flag[index] = 0;
      mineNum++;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    genBoard();
    flag = List.generate(row * col, (i) => 0);
    click = List.generate(row * col, (i) => 0);
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Minesweeper"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Text(
                'Timer:$_tminutes$_minutes:$_tseconds$_seconds',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(width: 20.0,),
              Text(
                "Mine Left : $mineNum",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(width: 20.0,),
              FloatingActionButton(
                  child: Text("restart"),
                  onPressed: (){
                    stopTimer();
                    genBoard();
                    flag = List.generate(row * col, (i) => 0);
                    click = List.generate(row * col, (i) => 0);
                    first = false;
                    startTimer();
                  }
              ),
            ],
          ),
          GridView.builder(
            padding: EdgeInsets.all(20),
            shrinkWrap: true, //only take needed spaces
            physics: NeverScrollableScrollPhysics(),
            itemCount: row*col,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: col,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
            itemBuilder: (context,index){
              final square = board[index];
              final isFlag = flag[index];
              final isClick = click[index];
              return GestureDetector(
                onTap: (){
                  openSquare(index);
                },
                onSecondaryTap: (){
                  putFlag(index);
                },
                onLongPress: (){
                  print("put flag");
                  putFlag(index);
                },
                child: Container(
                  color: (isClick == 1)
                      ? Colors.white
                      : (isFlag == 1)
                        ? Colors.purple[100]
                        : Colors.purple[50],
                  child: Center(
                    child: Text(
                        (isClick == 1)
                            ? (square == -1)
                              ? "💣"
                              : "$square"
                            : (isFlag == 1)
                              ? "🚩"
                              : ""
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}