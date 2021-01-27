//import 'package:app_plaga_enfermedades/src/models/planta_model.dart';
import 'package:app_plaga_enfermedades/src/bloc/fincas_bloc.dart';
import 'package:app_plaga_enfermedades/src/models/planta_model.dart';
import 'package:app_plaga_enfermedades/src/models/testplaga_model.dart';
import 'package:app_plaga_enfermedades/src/providers/db_provider.dart';
//import 'package:app_plaga_enfermedades/src/providers/db_provider.dart';
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
            appBar: AppBar(
                title: Text('Lista de Estaciones'),
            ),
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
                    
                    return SingleChildScrollView(
                        child: Column(
                            children: [
                                _datosTest(context, indiceEstacion),
                                _listaDePlantas(planta, context, indiceEstacion),
                                _countPlanta(plaga.id, indiceEstacion, plaga),
                                //_addPlanta(context, indiceEstacion, plaga)
                            ],
                        ),
                    );
                },
            ),
           
        );
    }

    Widget _datosTest(BuildContext context, int indiceEstacion){
        return Container(
            decoration: BoxDecoration(
                color: Colors.deepPurple
            ),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20.0),
            child: Text(
                'Estacion $indiceEstacion', 
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                ),
            ),
        );
    }


    Widget  _listaDePlantas(List planta, BuildContext context, int numeroEstacion){

        return ListView.builder(
            itemBuilder: (context, index) {
                if (planta[index].estacion == numeroEstacion) {

                    return GestureDetector(
                        child: ListTile(
                            title: Text('Planta ${index+1}'),
                            //trailing: Icon(Icons.keyboard_arrow_right, color: Colors.deepPurple,),
                            subtitle: Text('id ${planta[index].id}'),
                            
                        ),
                        //onTap: () => Navigator.pushNamed(context, 'addParcela', arguments: planta[index]),
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
                  return Column(
                      children: [
                        Text('$value / 10',
                            style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 20.0
                            ),
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
            ),
            color: Colors.deepPurple,
            
            icon:Icon(Icons.save),
            textColor: Colors.white,
            label: Text('Agregar Planta'),
            onPressed:() => Navigator.pushNamed(context, 'addPlanta', arguments: [estacion,plaga.id]),
        );
    }

}