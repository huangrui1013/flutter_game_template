import 'dart:math';

import 'package:flutter/material.dart';


void main(){

  runApp(
    const LinkGameApp(),
  );

}



class LinkGameApp extends StatelessWidget{

  const LinkGameApp({
    super.key,
  });


  @override
  Widget build(BuildContext context){

    return MaterialApp(

      debugShowCheckedModeBanner:false,

      theme:ThemeData(

        useMaterial3:true,

      ),

      home:
      const LinkGamePage(),

    );

  }

}





class LinkGamePage extends StatefulWidget{


  const LinkGamePage({
    super.key,
  });


  @override
  State<LinkGamePage> createState()
  =>
      _LinkGamePageState();


}

void shufflePool(
    List<String> list
    ){



  Random random =
      Random();



  for(int i=0;i<50;i++){


    list.shuffle(random);



    bool bad=false;



    for(
    int i=0;
    i<list.length-1;
    i++
    ){



      if(list[i]==list[i+1]){


        bad=true;

        break;


      }


    }



    if(!bad){

      return;

    }


  }


}





class _LinkGamePageState extends State<LinkGamePage>{



  late int rows;


  late int cols;



  late List<Tile> board;



  Tile? selected;



  int score=0;



 final List<String> fruits=[

  "🍎",
  "🍌",
  "🍇",
  "🍉",
  "🍒",
  "🍊",
  "🥝",
  "🍓",
  "🍑",
  "🍍",

];





  @override
  void initState(){

    super.initState();

    initSize();

    createGame();

  }






  void initSize(){



    // 默认手机布局

    rows=10;

    cols=8;



  }







  void updateSize(double width){



    if(width<500){


      rows=10;

      cols=8;


    }

    else if(width<900){


      rows=10;

      cols=10;


    }

    else{


      rows=10;

      cols=12;


    }


  }








  void createGame(){


  List<String> pool=[];



  int total =
      rows * cols;



  int pairCount =
      total ~/ 2;



  Random random =
      Random();




  /*
    每种水果最多出现4次

    也就是最多2对

    避免大量重复
  */





  // 如果不足，补齐

  while(pool.length < total){


    String fruit =
    fruits[
    random.nextInt(
      fruits.length
    )
    ];



    pool.add(fruit);

    pool.add(fruit);


  }





  shufflePool(pool);







  List<Tile> temp=[];



  int rCount =
      rows+2;


  int cCount =
      cols+2;






  for(
  int r=0;
  r<rCount;
  r++
  ){



    for(
    int c=0;
    c<cCount;
    c++
    ){



      if(

      r==0 ||

          c==0 ||

          r==rCount-1 ||

          c==cCount-1

      ){


        temp.add(
          Tile.empty(),
        );


      }

      else{



        temp.add(

          Tile(

            fruit:
            pool.removeLast(),

          ),

        );



      }


    }


  }






  setState((){


    board=temp;


    selected=null;


    score=0;



  });



}







  int index(
      int r,
      int c,
      ){

    return r*(cols+2)+c;

  }







  Tile tileAt(
      int r,
      int c,
      ){

    return board[
    index(r,c)
    ];

  }








  Point locate(Tile tile){


    int i =
    board.indexOf(tile);



    return Point(

      i ~/ (cols+2),

      i % (cols+2),

    );


  }






  void tapTile(Tile tile){


    if(
    tile.empty ||
        tile.removed
    ){

      return;

    }





    setState((){



      if(selected==null){


        tile.selected=true;


        selected=tile;


      }

      else if(selected==tile){


        tile.selected=false;


        selected=null;


      }

      else{



        if(
        canConnect(
          selected!,
          tile,
        )
        ){



          selected!.removed=true;

          tile.removed=true;


          score+=10;


        }



        selected!.selected=false;


        tile.selected=false;


        selected=null;



      }



    });


  }







  bool canConnect(
      Tile a,
      Tile b,
      ){



    if(
    a.fruit!=b.fruit
    ){

      return false;

    }



    return bfs(

      locate(a),

      locate(b),

    );



  }

  bool bfs(
      Point start,
      Point end,
      ){



    final queue=<Node>[];



    queue.add(

      Node(

        start.r,

        start.c,

        -1,

        0,

      ),

    );



    final visited=<String>{};





    final directions=[

      [1,0],

      [-1,0],

      [0,1],

      [0,-1],

    ];






    while(queue.isNotEmpty){



      Node current =
      queue.removeAt(0);




      if(
      current.r==end.r &&
          current.c==end.c
      ){

        return true;

      }






      String key=

          "${current.r}_${current.c}_${current.dir}_${current.turn}";



      if(
      visited.contains(key)
      ){

        continue;

      }



      visited.add(key);






      for(
      int d=0;
      d<4;
      d++
      ){



        int nr =
        current.r+
            directions[d][0];



        int nc =
        current.c+
            directions[d][1];





        if(
        nr<0 ||
            nc<0 ||
            nr>rows+1 ||
            nc>cols+1
        ){

          continue;

        }





        Tile next =
        tileAt(
          nr,
          nc,
        );





        bool pass =

            next.empty ||

                next.removed ||

                (
                    nr==end.r &&
                        nc==end.c
                );




        if(!pass){

          continue;

        }





        int newTurn =

        current.dir==-1 ||

            current.dir==d

            ?

        current.turn

            :

        current.turn+1;







        if(newTurn<=2){



          queue.add(

            Node(

              nr,

              nc,

              d,

              newTurn,

            ),

          );


        }



      }


    }





    return false;


  }













  @override
  Widget build(BuildContext context){



    final width =
    MediaQuery.of(context).size.width;




    updateSize(width);




    double gameWidth =
    min(
      width-20,
      520,
    );




    double tileSize =
    gameWidth/(cols+2);







    return Scaffold(



      backgroundColor:
      const Color(0xfff5f6fa),




      body:

      SafeArea(



        child:
        Column(



          children:[




            const SizedBox(
              height:20,
            ),




            const Text(

              "连连看",

              style:

              TextStyle(

                fontSize:34,

                fontWeight:
                FontWeight.bold,

              ),

            ),






            const SizedBox(
              height:12,
            ),





            Row(

              mainAxisAlignment:
              MainAxisAlignment.center,


              children:[



                Container(

                  padding:
                  const EdgeInsets.symmetric(

                    horizontal:18,

                    vertical:8,

                  ),



                  decoration:
                  BoxDecoration(

                    color:Colors.white,

                    borderRadius:
                    BorderRadius.circular(25),

                  ),


                  child:
                  Text(

                    "⭐ $score",

                    style:
                    const TextStyle(

                      fontSize:20,

                    ),

                  ),


                ),





                const SizedBox(
                  width:20,
                ),






                ElevatedButton(

                  onPressed:
                  createGame,


                  child:
                  const Text(
                    "重新开始",
                  ),

                ),



              ],

            ),





            const SizedBox(
              height:15,
            ),







            Expanded(




              child:
              Center(



                child:
                SizedBox(



                  width:
                  gameWidth,



                  child:
                  GridView.builder(



                    physics:
                    const NeverScrollableScrollPhysics(),




                    gridDelegate:

                    SliverGridDelegateWithFixedCrossAxisCount(



                      crossAxisCount:
                      cols+2,



                      crossAxisSpacing:
                      3,



                      mainAxisSpacing:
                      3,



                    ),





                    itemCount:
                    board.length,





                    itemBuilder:
                        (context,index){



                      final tile =
                      board[index];





                      return GestureDetector(



                        onTap:
                            (){

                          tapTile(tile);

                        },





                        child:

                        AnimatedContainer(



                          duration:
                          const Duration(

                            milliseconds:150,

                          ),



                          decoration:
                          BoxDecoration(



                            color:

                            tile.empty ||
                                tile.removed

                                ?

                            Colors.transparent

                                :

                            tile.selected

                                ?

                            Colors.orange

                                :

                            Colors.white,




                            borderRadius:

                            BorderRadius.circular(10),




                            boxShadow:

                            tile.empty ||
                                tile.removed

                                ?

                            []

                                :

                            const [

                              BoxShadow(

                                color:
                                Colors.black12,

                                blurRadius:5,

                                offset:
                                Offset(0,2),

                              )

                            ],




                          ),






                          child:

                          Center(



                            child:

                            tile.empty ||
                                tile.removed

                                ?

                            const SizedBox()

                                :


                            Text(



                              tile.fruit,



                              style:
                              TextStyle(



                                fontSize:
                                tileSize*0.55,



                              ),



                            ),



                          ),




                        ),




                      );



                    },



                  ),



                ),



              ),



            ),








            Padding(



              padding:
              const EdgeInsets.only(

                bottom:20,

              ),



              child:
              Row(



                mainAxisAlignment:
                MainAxisAlignment.center,



                children:[



                  OutlinedButton(

                    onPressed:(){},


                    child:
                    const Text(
                      "提示",
                    ),

                  ),





                  const SizedBox(
                    width:20,
                  ),





                  OutlinedButton(

                    onPressed:
                    createGame,


                    child:
                    const Text(
                      "洗牌",
                    ),

                  ),



                ],



              ),



            ),




          ],



        ),



      ),



    );



  }



}









class Tile{



  String fruit;



  bool removed;



  bool selected;



  bool empty;




  Tile({

    required this.fruit,

    this.removed=false,

    this.selected=false,

    this.empty=false,

  });




  Tile.empty()

      :

        fruit="",

        removed=true,

        selected=false,

        empty=true;



}








class Point{



  int r;


  int c;



  Point(
      this.r,
      this.c,
      );



}









class Node{



  int r;


  int c;


  int dir;


  int turn;




  Node(

      this.r,

      this.c,

      this.dir,

      this.turn,

      );


}