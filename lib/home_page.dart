import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
     // const HomePage({super.key, required this.title});
      
       @override
        State<HomePage> createState() => HomePageState();
     
}


class HomePageState extends State<HomePage>{
    int _counter = 0;

  void _incrementCounter(){
    // setState tells flutter framework that something chaged in state which
    // rerun build method below so that display reflect updated values.
    setState(() {
       _counter++;
    });

  }

  void _resetCounter(){
    setState(() {
       _counter = 0;
    });
  }

  void _decrementCounter(){
    // setState tells flutter framework that something chaged in state which
    // rerun build method below so that display reflect updated values.
    setState(() {
       _counter--;
    });

  }

    @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('Simple Counter App'),
      ),



      body: Center(

         child:  Column(
          // column takes list of childern and arragne it varticallty
             mainAxisAlignment: MainAxisAlignment.center,

          children: [

             Text(
              'Count Track',
                style: Theme.of(context).textTheme.titleLarge,
            ),
            
            SizedBox(height: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              
              ElevatedButton(onPressed: _incrementCounter
                , child: Icon(Icons.add),
              ),


            Text(
              '$_counter',
               style: Theme.of(context).textTheme.headlineMedium,
            ),


              ElevatedButton(onPressed: _decrementCounter
                , child: Icon(Icons.remove),
                 
              ),
              
              ],

  

          ),
           
          ],
      ),
     ),

      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',  //give additional info if user long pressed on button
        onPressed: _resetCounter,  //because return type of method is void we not call as incrementCounter()
        child: Icon(Icons.refresh),  //shows increment icon on floating action button
      ),
    );
  }
}