import 'package:flutter/material.dart';
import 'package:flutter/src/material/colors.dart';

void main() => runApp(
  new MaterialApp(
    title:"Card Demo",
    home:new CardDemoPage(),
    // routes: <String, WidgetBuilder>{
    //     '/AnotherPage': (BuildContext context) => new AnotherPage(),
    // },
  ),
);

class CardDemoPage extends StatefulWidget{
  _CardDemoState createState()=> new _CardDemoState();
}

class _CardDemoState extends State<CardDemoPage> with SingleTickerProviderStateMixin{
  var index=0;
  var cards=[["Ketchup","Catsup"],["Front1","Back2"]];
  bool isBack=false;
  Animation<double> animation;
  AnimationController controller;
  Animation<double> flipBack;
  Animation<double> flipFront;

  initState(){
    super.initState();
    controller=new AnimationController(
      duration: const Duration(milliseconds: 1000),vsync: this);
    animation=new Tween(begin: 1.0, end: 0.0).animate(controller)..addListener((){
      setState((){
      });
    });
    flipBack=new Tween(begin:1.0, end:0.0).animate(new CurvedAnimation(
      parent: controller,
      curve: new Interval(0.0, 0.5, curve: Curves.easeIn,)));
    flipFront=new CurvedAnimation(parent:controller, curve: new Interval(0.5,1.0,curve: Curves.easeOut));
    //controller.forward();
    //controller.reverse();
  }

  dispose(){
    controller.dispose();
    super.dispose();
  }

  void reverseCard(){
    isBack? controller.reverse():controller.forward();
    isBack=!isBack;
  }


  @override
  Widget build(BuildContext context) {   
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Card Demo"),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.flip_to_back),
        onPressed: reverseCard,
      ),
      body:new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[ 
          new Stack(
            alignment: const Alignment(0.6, 0.6),
            children: <Widget>[
              new Container(
                child: new Center(
                  child:new Transform(
                    transform:new Matrix4.identity()..scale(1.0,flipBack.value,1.0),
                    child:new CardTemplate(colors:Colors.black,textColor: Colors.white,text: cards[index][1]),
                    alignment: FractionalOffset.center,
                  )
                ),
              ),
              new Container(
                child: new Center(
                  child:new Transform(
                    transform:new Matrix4.identity()..scale(1.0,flipFront.value,1.0),
                    child:new CardTemplate(colors:Colors.white,textColor:Colors.black,text:cards[index][0]),
                    alignment: FractionalOffset.center,
                  )
                ),
              ),           
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Builder(
                builder: (BuildContext context){
                  return new FloatingActionButton(
                    backgroundColor: Colors.green,
                    child: new Icon(Icons.check,),
                    onPressed: (){
                      Scaffold.of(context).showSnackBar(
                        new SnackBar(
                          content: new Text("That's cool!"),
                          action: new SnackBarAction(
                            label: "UNDO",
                            onPressed: () => Scaffold.of(context).hideCurrentSnackBar(),
                          ),
                        ),
                      );
                    },
                  );
                }
              ),
              new FloatingActionButton(
                backgroundColor: Colors.red,
                child: new Icon(Icons.navigate_next,),
                onPressed: (){
                  setState((){
                    //Set state tell flutter to re-run build method!
                    if((cards.length-1)>index){
                      ++index;//update my card
                    }
                  });
                },
              ),
            ]
          ),  
        ],

      ),
    );
  }
}


class CardTemplate extends StatelessWidget{
  CardTemplate({this.colors,this.textColor,this.text});
  final Color colors;
  final String text;
  final Color textColor;
  @override
  Widget build(BuildContext context){
    return new Card(
      color: colors,
      elevation: 50.0,//shadow casted by card
      child: new Container(
        decoration: const BoxDecoration(
          border: const Border(
          top: const BorderSide(width: 1.0, color:Colors.black),
          left: const BorderSide(width: 1.0, color: Colors.black),
          right: const BorderSide(width: 1.0, color: Colors.black),
          bottom: const BorderSide(width: 1.0, color: Colors.black),
          ),
        ),        
        width: 300.0,
        height: 150.0,
        child:new Center(child:new Text(text,style:new TextStyle(color:textColor,fontFamily: 'Rammetto'),),)),

    );
  }

}

// class AnotherPage extends StatelessWidget{
//   Widget build(BuildContext context){
//     return new MaterialApp(
//       home: new Scaffold(
//         appBar: new AppBar(title:new Text("AnotherPage")),
//         body: new CardTemplate(),
//       ),
//     ); 
//   }
// }
