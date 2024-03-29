import 'package:app_plaga_enfermedades/src/bloc/fincas_bloc.dart';
import 'package:app_plaga_enfermedades/src/models/planta_model.dart';
import 'package:app_plaga_enfermedades/src/models/testplaga_model.dart';
import 'package:app_plaga_enfermedades/src/utils/constants.dart';
import 'package:app_plaga_enfermedades/src/utils/widget/button.dart';
import 'package:app_plaga_enfermedades/src/utils/widget/dialogDelete.dart';
import 'package:app_plaga_enfermedades/src/utils/widget/varios_widget.dart';
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
        List dataEstaciones = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
        Testplaga plaga = dataEstaciones[0];
        int? indiceEstacion = dataEstaciones[1]+1;
        fincasBloc.obtenerPlantaIdTest(plaga.id, indiceEstacion);

        return Scaffold(
            appBar: AppBar(title: Text('Lista plantas sitio $indiceEstacion'),),
            body: StreamBuilder<List<Planta>>(
                stream: fincasBloc.plantaStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }
                    final planta = snapshot.data;

                    return Column(
                        
                        children: [ 
                            Expanded(
                                child: planta.length == 0
                                ?
                                textoListaVacio('Ingrese datos de plantas')
                                :
                                SingleChildScrollView(child: _listaDePlantas(planta, context, indiceEstacion)),
                            ),
                        ],
                    );
                },
            ),
            bottomNavigationBar: botonesBottom(_countPlanta(plaga.id, indiceEstacion, plaga) ),
        );
    }

    


    Widget  _listaDePlantas(List planta, BuildContext context, int? numeroEstacion){

        return ListView.builder(
            itemBuilder: (context, index) {
                if (planta[index].estacion == numeroEstacion) {

                    return Dismissible(
                        key: UniqueKey(),
                        child: GestureDetector(
                            child:cardDefault(
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        tituloCard('Planta ${index+1}'),
                                        Wrap(
                                            spacing: 15,
                                            children: [
                                                textoCardBody('Mazorcas sanas: ${planta[index].sanas}'),
                                                textoCardBody('Mazorcas enfermas: ${planta[index].enfermas}'),
                                                textoCardBody('Mazorcas dañadas: ${planta[index].danadas}'),
                                            ],
                                        )
                                    ],
                                ),
                            )
                        ),
                        confirmDismiss: (direction) => confirmacionUser(direction, context),
                        direction: DismissDirection.endToStart,
                        background: backgroundTrash(context),
                        movementDuration: Duration(milliseconds: 500),
                        onDismissed: (direction) => fincasBloc.borrarPlanta(planta[index]),
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

    

    Widget  _countPlanta(String? idPlaga,  int? estacion, Testplaga plaga){
        return StreamBuilder<List<Planta>>(
            stream: fincasBloc.plantaStream,
            
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }
                List<Planta> plantas = snapshot.data;
                
                int value = plantas.length;
                
                if (value < 10) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                            textoBottom('Plantas: $value / 10', kTextColor),
                            _addPlanta(context, estacion, plaga, value),
                        ],
                    );
                }else{
                    if (estacion! <= 2){
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                                textoBottom('Plantas: $value / 10',  kTextColor),
                                ButtonMainStyle(
                                    title: 'Siguiente sitio',
                                    icon: Icons.navigate_next_rounded,
                                    press: () => Navigator.popAndPushNamed(context, 'plantas', arguments: [plaga, estacion]),
                                )
                            ],
                        );
                    }else{
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                                textoBottom('Plantas: $value / 10',  kTextColor),
                                ButtonMainStyle(
                                    title: 'Lista de sitios',
                                    icon: Icons.chevron_left,
                                    press:() => Navigator.pop(context),
                                )
                            ],
                        );
                    }

                    
                }                
            },
        );
    }


    Widget  _addPlanta(BuildContext context,  int? estacion, Testplaga plaga, int value){
        return ButtonMainStyle(
            title: 'Agregar Planta',
            icon: Icons.post_add,
            press: () => Navigator.pushNamed(context, 'addPlanta', arguments: [estacion,plaga.id,value]),
        );
    }

}