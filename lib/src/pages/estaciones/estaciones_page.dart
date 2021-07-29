import 'package:app_plaga_enfermedades/src/bloc/fincas_bloc.dart';
import 'package:app_plaga_enfermedades/src/models/decisiones_model.dart';
import 'package:app_plaga_enfermedades/src/models/finca_model.dart';
import 'package:app_plaga_enfermedades/src/models/parcela_model.dart';
import 'package:app_plaga_enfermedades/src/models/planta_model.dart';
import 'package:app_plaga_enfermedades/src/models/testplaga_model.dart';
import 'package:app_plaga_enfermedades/src/providers/db_provider.dart';
import 'package:app_plaga_enfermedades/src/utils/constants.dart';
import 'package:app_plaga_enfermedades/src/utils/widget/button.dart';
import 'package:app_plaga_enfermedades/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class EstacionesPage extends StatefulWidget {
    const EstacionesPage({Key? key}) : super(key: key);

  @override
  _EstacionesPageState createState() => _EstacionesPageState();
}

class _EstacionesPageState extends State<EstacionesPage> {

    final fincasBloc = new FincasBloc();

    Future _getdataFinca(Testplaga textPlaga) async{
        Finca? finca = await DBProvider.db.getFincaId(textPlaga.idFinca);
        Parcela? parcela = await DBProvider.db.getParcelaId(textPlaga.idLote);
        List<Decisiones> desiciones = await DBProvider.db.getDecisionesIdTest(textPlaga.id);
        
        return [finca, parcela, desiciones];
    }

    @override
    Widget build(BuildContext context) {
        
        Testplaga plaga = ModalRoute.of(context)!.settings.arguments as Testplaga;
        fincasBloc.obtenerPlantas(plaga.id);
        

       return StreamBuilder<List<Planta>>(
            stream: fincasBloc.countPlanta,
            builder: (BuildContext context, AsyncSnapshot snapshot){
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }
                List<Planta> plantas= snapshot.data;
                //print(plantas.length);
                fincasBloc.obtenerDecisiones(plaga.id);
                int estacion1 = 0;
                int estacion2 = 0;
                int estacion3 = 0;
                List countEstaciones = [];

                for (var item in plantas) {
                    if (item.estacion == 1) {
                        estacion1 ++;
                    } else if (item.estacion == 2){
                        estacion2 ++;
                    }else{
                        estacion3 ++;
                    }
                }
                countEstaciones = [estacion1,estacion2,estacion3];
                
                return Scaffold(
                    appBar: AppBar(),
                    body: Column(
                        children: [
                            escabezadoSitio( context, plaga ),
                            _textoExplicacion('Lista de sitios'),
                            Expanded(
                                child: SingleChildScrollView(
                                    child: _listaDeEstaciones( context, plaga, countEstaciones ),
                                ),
                            ),
                        ],
                    ),
                    bottomNavigationBar: BottomAppBar(
                        child: _tomarDecisiones(countEstaciones, plaga)
                    ),
                );
            },
        );
    }



    Widget escabezadoSitio( BuildContext context, Testplaga plaga ){


        return FutureBuilder(
            future: _getdataFinca(plaga),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                }
                Finca finca = snapshot.data[0];
                Parcela parcela = snapshot.data[1];

                return Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            encabezadoCard('Área finca: ${finca.nombreFinca}','Productor: ${finca.nombreProductor}', 'assets/icons/finca.svg'),
                            Wrap(
                                spacing: 20,
                                children: [
                                    textoCardBody('Área finca: ${finca.areaFinca}'),
                                    textoCardBody('Área parcela: ${parcela.areaLote} ${finca.tipoMedida == 1 ? 'Mz': 'Ha'}'), 
                                ],
                            )
                        ],
                    ),
                );
            },
        );        
    }

    Widget _textoExplicacion(String? titulo){
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: InkWell(
                child: Column(
                    children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                Container(                                                                    
                                    child: Text(
                                        titulo!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)
                                    ),
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Icon(
                                        Icons.info_outline_rounded,
                                        color: Colors.green,
                                        size: 20,
                                    ),
                                ),
                            ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                            children: List.generate(
                                150~/2, (index) => Expanded(
                                    child: Container(
                                        color: index%2==0?Colors.transparent
                                        :kShadowColor2,
                                        height: 2,
                                    ),
                                )
                            ),
                        ),
                    ],
                ),
                onTap: () => _explicacion(context),
            ),
        );
    }


    Widget  _listaDeEstaciones( BuildContext context, Testplaga plaga, List countEstaciones){
        return ListView.builder(
            itemBuilder: (context, index) {
                String estadoConteo;
                if (countEstaciones[index] >= 10){
                    estadoConteo =  'Completo';
                }else{
                   estadoConteo =  'Incompleto'; 
                }
                return GestureDetector(
                    
                    child: _cardTest(index+1,countEstaciones[index], estadoConteo),
                    onTap: () => Navigator.pushNamed(context, 'plantas', arguments: [plaga, index]),
                );
                
               
            },
            shrinkWrap: true,
            itemCount:  plaga.estaciones,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }

    Widget _cardTest(int sitio, int numeroPlantas, String estado){
        return cardDefault(
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                    
                    Flexible(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                tituloCard('Sitio $sitio'),
                                subtituloCardBody('$estado')
                            ],  
                        ),
                    ),
                    Container(
                        child: CircularPercentIndicator(
                            radius: 65,
                            lineWidth: 5.0,
                            animation: true,
                            percent: numeroPlantas/10,
                            center: new Text("${(numeroPlantas/10)*100}%"),
                            progressColor: Color(0xFF498C37),
                        ),
                    )
                    
                ],
            ), 
                
        );
    }

    Widget  _tomarDecisiones(List countEstaciones, Testplaga plaga){
        
        if(countEstaciones[0] >= 10 && countEstaciones[1] >= 10 && countEstaciones[2] >= 10){
            
            return StreamBuilder(
            stream: fincasBloc.decisionesStream ,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                    }
                    List<Decisiones> desiciones = snapshot.data;

                    if (desiciones.length == 0){
                        return Container(
                            color: kBackgroundColor,
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                                child: ButtonMainStyle(
                                    title: 'Toma de decisiones',
                                    icon: Icons.post_add,
                                    press: () => Navigator.pushNamed(context, 'decisiones', arguments: plaga),
                                )
                            ),
                        );
                        
                    }

                    return Container(
                        color: kBackgroundColor,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                            child: ButtonMainStyle(
                                    title: 'Consultar decisiones',
                                    icon: Icons.receipt_rounded,
                                    press: () => Navigator.pushNamed(context, 'reporte', arguments: plaga.id),
                                
                            
                            ),
                        )
                    );
                                       
                },  
            );
        }
        
        return Container(
            color: kBackgroundColor,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                    "Complete los sitios",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w900, color: kRedColor, fontSize: 18)
                ),
            ),
        );
    }

    Future<void> _explicacion(BuildContext context){

        return dialogText(
            context,
            Column(
                children: [
                    textoCardBody('•	Realizar un recorrido de la parcela SAF cacao junto con la productora o productor para identificar los 3 puntos o estaciones para las observaciones.'),
                    textoCardBody('•	En los tres sitios identificar la primera planta para observar. Luego continuar las observaciones en el primer punto en 9 plantas más. De esta manera en cada uno de los sitios se realizan las observaciones sobre las plagas y enfermedades, número de mazorcas sanas, mazorcas enfermas y mazorcas dañadas en 10 plantas, 5 plantas seguidas sin escoger en un surco y 5 plantas seguidas en el surco vecino. '),
                    textoCardBody('•	Para tomar y registrar los datos seguimos los pasos de la aplicación para completar los tres sitios. Una vez completado este paso, la aplicación le dirigirá a la pantalla de toma de decisiones. Seguir los pasos revelados por la aplicación, grabando los datos e información como solicita la aplicación.'),
                    textoCardBody('•    Utilizar las observaciones sobre la prevalencia (% de plantas afectadas) y pérdida de cosecha por enfermedades y daño por animales para tomar decisiones sobre las acciones a realizar para mejorar las plagas y enfermedades.'),
                ],
            ),
            'Pasos para aplicación de piso'
        );
    }
}

