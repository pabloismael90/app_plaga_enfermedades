
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);




    @override
    Widget build(BuildContext context) {
        

        return Scaffold(
            appBar: AppBar(
                title: Text('Home'),
            ),

            body: ListView(
                children: [
                    GestureDetector(
                        child: ListTile(
                            leading: Icon(Icons.add_circle),
                            title: Text('Agregar Finca'),
                            trailing: Icon(Icons.keyboard_arrow_right),
                        ),
                        onTap:() => Navigator.pushNamed(context, 'fincas' ),
                    ),
                    GestureDetector(
                        child: ListTile(
                            leading: Icon(Icons.add_circle),
                            title: Text('Hacer test plagas'),
                            trailing: Icon(Icons.keyboard_arrow_right),
                        ),
                        onTap:() => Navigator.pushNamed(context, 'tests' ),
                    )
                ],
            ),
        );
    }
}