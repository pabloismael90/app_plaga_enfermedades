import 'package:app_plaga_enfermedades/src/bloc/fincas_bloc.dart';
import 'package:app_plaga_enfermedades/src/models/planta_model.dart';
import 'package:app_plaga_enfermedades/src/models/testplaga_model.dart';
import 'package:flutter/material.dart';

class EstacionesPage extends StatefulWidget {
    const EstacionesPage({Key key}) : super(key: key);

  @override
  _EstacionesPageState createState() => _EstacionesPageState();
}

class _EstacionesPageState extends State<EstacionesPage> {

    final fincasBloc = new FincasBloc();

    @override
    Widget build(BuildContext context) {
        
        Testplaga plaga = ModalRoute.of(context).settings.arguments;
        fincasBloc.obtenerPlantas(plaga.id);

       return StreamBuilder<List<Planta>>(
            stream: fincasBloc.countPlanta,
            builder: (BuildContext context, AsyncSnapshot snapshot){
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }
                List<Planta> plantas= snapshot.data;
                //print(plantas.length);
                
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
                    appBar: AppBar(
                        title: Text('Lista de Estaciones3'),
                    ),
                    body: Column(
                        children: [
                            escabezadoEstacion( context, plaga ),
                            SingleChildScrollView(
                                child: _listaDeEstaciones( context, plaga, countEstaciones ),
                            ),
                        ],
                    ),
                    bottomNavigationBar: BottomAppBar(
                        child: _tomarDecisiones(countEstaciones, plaga),
                    ),
                );
            },
        );
    }



    Widget escabezadoEstacion( BuildContext context, Testplaga plaga ){
        return Container(
            decoration: BoxDecoration(
                color: Colors.deepPurple
            ),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20.0),
            child: Column(
                children: [
                    Text(
                        'Finca id: ${plaga.idFinca}', 
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0
                        ),
                    ),
                    Text(
                        'Fecha: ${plaga.fechaTest}', 
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0
                        ),
                    ),
                ],
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
                    child: ListTile(
                        title: Column(
                            children: [
                                Text('Estacion ${index+1}'),
                                
                                Text(' ${countEstaciones[index]}/ 10'),
                                Text(' $estadoConteo'),
                                
                                
                            ],
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right, color: Colors.deepPurple,),
                    ),
                    onTap: () => Navigator.pushNamed(context, 'plantas', arguments: [plaga, index]),
                );
                
               
            },
            shrinkWrap: true,
            itemCount:  plaga.estaciones,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }

    Widget  _tomarDecisiones(List countEstaciones, Testplaga plaga){

        if(countEstaciones[0] >= 10 && countEstaciones[1] >= 10 && countEstaciones[2] >= 10){
            
            return RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                ),
                color: Colors.deepPurple,
                
                icon:Icon(Icons.save),
                textColor: Colors.white,
                label: Text('Tomar de decisiones'),
                onPressed: () => Navigator.pushNamed(context, 'decisiones', arguments: plaga),
            );
        }

        return Text('Complete la toma de datos');
        


        
    }
}