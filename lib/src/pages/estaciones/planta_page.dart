//import 'package:app_plaga_enfermedades/src/models/planta_model.dart';
import 'package:app_plaga_enfermedades/src/bloc/fincas_bloc.dart';
import 'package:app_plaga_enfermedades/src/models/planta_model.dart';
import 'package:app_plaga_enfermedades/src/models/testplaga_model.dart';
import 'package:app_plaga_enfermedades/src/providers/db_provider.dart';
import 'package:app_plaga_enfermedades/src/utils/constants.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_swiper/flutter_swiper.dart';

// ignore: must_be_immutable
class PlantaPage extends StatefulWidget {
  @override
  _PlantaPageState createState() => _PlantaPageState();
}

class _PlantaPageState extends State<PlantaPage> {

    final fincasBloc = new FincasBloc();

    @override
    Widget build(BuildContext context) {
        List dataEstaciones = ModalRoute.of(context).settings.arguments;
        Testplaga plaga = dataEstaciones[0];
        int indiceEstacion = dataEstaciones[1]+1;
        fincasBloc.obtenerPlantaIdTest(plaga.id, indiceEstacion);

        return Scaffold(
            appBar: AppBar(),
            body: StreamBuilder<List<Planta>>(
                //future: DBProvider.db.getTodasPlantas(),
                stream: fincasBloc.plantaStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }
                    //print(snapshot.data);
                    final planta = snapshot.data;

                    //return _listaDePlantas(planta, context);
                    
                    return Column(
                        children: [
                            _datosTest(context, indiceEstacion),
                            Divider(),                            
                            Expanded(child: SingleChildScrollView(child: _listaDePlantas(planta, context, indiceEstacion))),
                            
                            
                            //_addPlanta(context, indiceEstacion, plaga)
                        ],
                    );
                },
            ),
            bottomNavigationBar: BottomAppBar(
                child: Container(
                    color: kBackgroundColor,
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: _countPlanta(plaga.id, indiceEstacion, plaga)
                    ),
                ),
            ),
        );
    }

    Widget _datosTest(BuildContext context, int indiceEstacion){
        return Container(
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                    children: [
                    
                        Text(
                            "Lista de plantas estacion $indiceEstacion",
                            style: Theme.of(context).textTheme
                                .headline5
                                .copyWith(fontWeight: FontWeight.w900, color: kRedColor)
                        ),
                    ],
                ),
            )
        );
        
    }


    Widget  _listaDePlantas(List planta, BuildContext context, int numeroEstacion){

        return ListView.builder(
            itemBuilder: (context, index) {
                if (planta[index].estacion == numeroEstacion) {

                    return GestureDetector(
                        child:Container(
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.5),
                                    boxShadow: [
                                        BoxShadow(
                                            color: Color(0xFF3A5160)
                                                .withOpacity(0.05),
                                            offset: const Offset(1.1, 1.1),
                                            blurRadius: 17.0),
                                        ],
                                ),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        
                                        Padding(
                                            padding: EdgeInsets.only(top: 10, bottom: 10.0),
                                            child: Text(
                                                "Planta ${index+1}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: Theme.of(context).textTheme.headline6,
                                            ),
                                        ),
                                    ],
                                ),
                        )
                    );
                }
                return Container();
            },
            shrinkWrap: true,
            itemCount: planta.length,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }

    

    Widget  _countPlanta(String idPlaga,  int estacion, Testplaga plaga){
        return FutureBuilder(
            future: DBProvider.db.countPlanta(idPlaga,estacion),
            
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }
                int value = snapshot.data;
                
                if (value < 10) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                            Text('Plantas: $value / 10',
                                style: Theme.of(context).textTheme
                                        .headline6
                                        .copyWith(fontWeight: FontWeight.w600)
                            ),
                            _addPlanta(context, estacion, plaga),
                        ],
                    );
                }else{
                    return Container(
                        child: Text('$value / 10',
                            style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700, 
                            ),
                        ),
                    );
                }                
            },
        );
    }


    Widget  _addPlanta(BuildContext context,  int estacion, Testplaga plaga){
        return RaisedButton.icon(
            
            icon:Icon(Icons.add_circle_outline_outlined),
            
            label: Text('Agregar Planta',
                style: Theme.of(context).textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.w600, color: Colors.white)
            ),
            padding:EdgeInsets.all(13),
            onPressed:() => Navigator.pushNamed(context, 'addPlanta', arguments: [estacion,plaga.id]),
        );
    }

}