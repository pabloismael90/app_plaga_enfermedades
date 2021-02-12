
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);




    @override
    Widget build(BuildContext context) {
        

        return SafeArea(
            child: Scaffold(
                body: CustomScrollView(
                    slivers: [
                        _headerHome()
                    ],
                )
            ),
        );
    }

    Widget _headerHome(){
        return SliverAppBar(
            elevation: 2.0,
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                title: Text('Plagas y Enfermedades de Cacao'),
                background:  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(                  
                            bottom: Radius.circular(50),
                    ),
                    )
                )
            ),
        );
    }

   
}


class MyHeaderClipper extends CustomClipper<Path> {
    
        @override
        Path getClip(Size size) {
          Path path = Path();
            path.lineTo(0, size.height - 100);
            path.quadraticBezierTo(
                size.width / 2, size.height, 
                size.width, size.height - 100
            );
            path.lineTo(size.width, 0);
            path.close();

            return path;
        }
    
      @override
      bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}



// ListView(
//                   children: [
//                       GestureDetector(
//                           child: ListTile(
//                               leading: Icon(Icons.add_circle),
//                               title: Text('Mis fincas'),
//                               trailing: Icon(Icons.keyboard_arrow_right),
//                           ),
//                           onTap:() => Navigator.pushNamed(context, 'fincas' ),
//                       ),
//                       GestureDetector(
//                           child: ListTile(
//                               leading: Icon(Icons.add_circle),
//                               title: Text('Tomar datos'),
//                               trailing: Icon(Icons.keyboard_arrow_right),
//                           ),
//                           onTap:() => Navigator.pushNamed(context, 'tests' ),
//                       ),
//                       GestureDetector(
//                           child: ListTile(
//                               leading: Icon(Icons.add_circle),
//                               title: Text('Consultar registros'),
//                               trailing: Icon(Icons.keyboard_arrow_right),
//                           ),
//                           onTap:() => Navigator.pushNamed(context, 'registros' ),
//                       )
//                   ],
//               ),