
import 'package:app_plaga_enfermedades/src/pages/decisiones/decisiones_form.dart';
import 'package:app_plaga_enfermedades/src/pages/decisiones/decisiones_page.dart';
import 'package:app_plaga_enfermedades/src/pages/decisiones/reporte_page.dart';
import 'package:app_plaga_enfermedades/src/pages/estaciones/estaciones_page.dart';
import 'package:app_plaga_enfermedades/src/pages/finca/finca_form.dart';
import 'package:app_plaga_enfermedades/src/pages/finca/finca_page.dart';
import 'package:app_plaga_enfermedades/src/pages/galeria/image.dart';
import 'package:app_plaga_enfermedades/src/pages/galeria/list_galeria.dart';
import 'package:app_plaga_enfermedades/src/pages/parcelas/parcela_form.dart';
import 'package:app_plaga_enfermedades/src/pages/parcelas/parcelas_page.dart';
import 'package:app_plaga_enfermedades/src/pages/pdf/Manuales.dart';
import 'package:app_plaga_enfermedades/src/pages/pdf/PDFView.dart';
import 'package:app_plaga_enfermedades/src/pages/plaga/testplaga_form.dart';
import 'package:app_plaga_enfermedades/src/pages/plaga/testplaga_page.dart';
import 'package:app_plaga_enfermedades/src/pages/estaciones/planta_form.dart';
import 'package:app_plaga_enfermedades/src/pages/estaciones/planta_page.dart';
import 'package:app_plaga_enfermedades/src/utils/constants.dart';
import 'package:flutter/material.dart';
 
import 'package:app_plaga_enfermedades/src/pages/home_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {

        SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
        ]);
        SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light, 
            )        
        );
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            
            localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
                const Locale('es', 'ES'),
                // const Locale('en', 'US'),
            ],
            title: 'Cacao Plaga y Cosecha',
            initialRoute:'home',
            routes: {
                'home' : ( BuildContext context ) => HomePage(),
                //Finca
                'fincas' : ( BuildContext context ) => FincasPage(),
                'addFinca' : ( BuildContext context ) => AgregarFinca(),
                //Parcelas
                'parcelas' : ( BuildContext context ) => ParcelaPage(),
                'addParcela' : ( BuildContext context ) => AgregarParcela(),
                //test
                'tests' :  ( BuildContext context ) => TestPage(),
                'addTest' : ( BuildContext context ) => AgregarTest(),
                //estaciones
                'estaciones' : ( BuildContext context ) => EstacionesPage(),
                'plantas' : ( BuildContext context ) => PlantaPage(),
                'addPlanta' : ( BuildContext context ) => AgregarPlanta(),
                //Decisiones
                'decisiones' : ( BuildContext context ) => DesicionesPage(),
                'registros' : ( BuildContext context ) => DesicionesList(),
                'reporte' : ( BuildContext context ) => ReportePage(),

                //PDFs
                'Manuales' : ( BuildContext context ) => Manuales(),
                'PDFview' : ( BuildContext context ) => PDFView(),
                
                //Galeria de imagenes
                'galeria' : ( BuildContext context ) => GaleriaImagenes(),
                'viewImg' : ( BuildContext context ) => ViewImage(),
                

            },
            theme: ThemeData(
                fontFamily: "Museo",
                scaffoldBackgroundColor: kBackgroundColor,
                primaryTextTheme: TextTheme(
                    headline6: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                    )
                ),
                textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor, fontFamily: 'Museo'),
                appBarTheme: AppBarTheme(color: kbase,brightness: Brightness.dark, centerTitle: false),
                primaryColor:kbase,
                primaryIconTheme: IconThemeData(color: Colors.white),
                inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: Color(0xFFF5F5F5),
                    counterStyle: TextStyle(fontSize: 10),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: kmorado)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: kTextColor),
                    ),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color:kTextColor),
                    ),

                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.redAccent),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.redAccent),
                    ),
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, 
                        color: kTextColor, 
                        fontSize: 14,
                    )
                ),
            
                elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        primary: kmorado,
                        textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                        ),
                        

                    )
                )
            ),
             
             
            
        );
    }
}