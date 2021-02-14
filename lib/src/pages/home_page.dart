import 'package:flutter/material.dart';
import 'package:app_plaga_enfermedades/src/utils/category_cart.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);




    @override
    Widget build(BuildContext context) {
        
        Size size = MediaQuery.of(context).size;

        return Scaffold(
            body: Stack(
                children:<Widget> [
                    
                    Column(
                        children: [
                            SizedBox(height: size.height * 0.31,),
                            Expanded(
                        child:GridView.count(
                                      crossAxisCount: 2,
                                      childAspectRatio: .85,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20,
                                      children: <Widget>[
                                          CategoryCard(
                                          title: "Diet Recommendation",
                                          svgSrc: "assets/icons/Hamburger.svg",
                                          press: () {},
                                          ),
                                          CategoryCard(
                                          title: "Kegel Exercises",
                                          press: () {},
                                          ),
                                          CategoryCard(
                                          title: "Meditation",
                                          svgSrc: "assets/icons/Meditation.svg",
                                          press: () {
                                             
                                          },
                                          ),
                                          CategoryCard(
                                          title: "Yoga",
                                          svgSrc: "assets/icons/yoga.svg",
                                          press: () {},
                                          ),
                                          CategoryCard(
                                          title: "Yoga",
                                          svgSrc: "assets/icons/yoga.svg",
                                          press: () {},
                                          ),
                                          CategoryCard(
                                          title: "Yoga",
                                          svgSrc: "assets/icons/yoga.svg",
                                          press: () {},
                                          ),
                                      ],
                            ),
                            
                        
                        ),
                      
                        ],
                    ),
                    ClipPath(
                        clipper: MyHeaderClipper(),
                        child: Container(
                              height: size.height * 0.35,
                              decoration: BoxDecoration(
                                  //color: Color.fromRGBO(115, 32, 2, 1),
                                  color: Color.fromRGBO(228, 218, 209, 1),
                                  image: DecorationImage(
                                      image: AssetImage("assets/images/cacao_bg.png"),
                                      fit: BoxFit.fitWidth
                                  )
                              ),
                          
                      ),
                    ),
                    SafeArea(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                                children: [
                                    SizedBox(height: size.height * 0.10,),
                                    Text(
                                        "Plaga y enfermedades de Cacao",
                                        style: TextStyle(
                                            fontSize: 35.0,
                                            fontWeight: FontWeight.w900,
                                            //color: Colors.white
                                            color: Colors.black87
                                        ),
                                    ),
                                ],
                            ),
                        )
                    ),
                              
                ],
            ),

        );
    }

    // Widget _appBar() {
    //     CustomScrollView(
    //             slivers: <Widget>[
    //                 SliverAppBar(
    //                 expandedHeight: 250,
    //                 floating: false,
    //                 pinned: true,
    //                 elevation: 0.0,
    //                 flexibleSpace: SafeArea(
    //                     child:FlexibleSpaceBar(
    //                     background: ClipPath(
    //                         clipper: MyHeaderClipper(),
    //                         child: Container(
    //                           decoration: BoxDecoration(
    //                                 //color: Color.fromRGBO(115, 32, 2, 1),
    //                                 color: Color.fromRGBO(228, 218, 209, 1),
    //                                 image: DecorationImage(
    //                                     image: AssetImage("assets/images/cacao_bg.png"),
    //                                     fit: BoxFit.fitWidth
    //                                 )
    //                             ),
    //                       ),
    //                     ),
    //                     collapseMode: CollapseMode.none,
    //                     titlePadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
    //                     title: Text('Plaga y Enfermedades de cacao',
    //                         style: TextStyle(
    //                             fontSize: 20.0,
    //                             color: Colors.black,
    //                             fontWeight: FontWeight.w900
    //                         ),
    //                     ),
    //                     )
    //                 )
    //                 ),
    //                 SliverList(
    //                     delegate: SliverChildListDelegate(
    //                         [
    //                             SizedBox(height: 1000,),
                                
                                
    //                         ]
    //                     ),
    //                 )
    //             ],
    //         ),
    // // }

    

   
}


class MyHeaderClipper extends CustomClipper<Path> {
    
        @override
        Path getClip(Size size) {
          Path path = Path();
            path.lineTo(0, size.height - 40);
            path.quadraticBezierTo(
                size.width / 2, size.height, 
                size.width, size.height - 40
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