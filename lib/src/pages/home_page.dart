import 'package:app_plaga_enfermedades/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:app_plaga_enfermedades/src/utils/widget/category_cart.dart';

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
                            SizedBox(height: size.height * 0.35,),
                            Expanded(
                                child:GridView.count(
                                        crossAxisCount: 2,
                                        childAspectRatio: .85,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20,
                                        children: <Widget>[
                                            CategoryCard(
                                                title: "Mis Fincas",
                                                svgSrc: "assets/icons/finca.svg",
                                                press:() => Navigator.pushNamed(context, 'fincas' ),
                                            ),
                                            CategoryCard(
                                                title: "Tomar datos y decisiones",
                                                svgSrc: "assets/icons/test.svg",
                                                press: () => Navigator.pushNamed(context, 'tests' ),
                                            ),
                                            CategoryCard(
                                                title: "Consultar registro",
                                                svgSrc: "assets/icons/report.svg",
                                                press: () => Navigator.pushNamed(context, 'registros' ),
                                            ),
                                            CategoryCard(
                                                title: "Instructivo",
                                                svgSrc: "assets/icons/manual.svg",
                                                press: () {},
                                            ),
                                            CategoryCard(
                                                title: "Imágenes",
                                                svgSrc: "assets/icons/galeria.svg",
                                                press: () {},
                                            ),
                                            
                                        ],
                                ),
                                
                            
                            ),
                      
                        ],
                    ),
                    Container(
                              height: size.height * 0.35,
                              decoration: BoxDecoration(
                                  color: kBackgroundColor,
                                  image: DecorationImage(
                                      image: AssetImage("assets/images/cacao_bg.png"),
                                      fit: BoxFit.fitWidth
                                  )
                              ),
                          
                    ),
                    SafeArea(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                                children: [
                                    SizedBox(height: size.height * 0.10,),
                                    Text(
                                        "Plaga y\nenfermedades\nde Cacao",
                                        style: Theme.of(context).textTheme
                                            .headline4
                                            .copyWith(fontWeight: FontWeight.w900, color: kTextColor, fontSize: 35)
                                    ),
                                ],
                            ),
                        )
                    ),
                              
                ],
            ),

        );
    }
   
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