import 'package:app_plaga_enfermedades/src/bloc/fincas_bloc.dart';
import 'package:app_plaga_enfermedades/src/models/planta_model.dart';
import 'package:app_plaga_enfermedades/src/models/testplaga_model.dart';
import 'package:app_plaga_enfermedades/src/providers/db_provider.dart';
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
        
        return Scaffold(
            appBar: AppBar(
                title: Text('Lista de Estaciones'),
            ),
            body: Column(
                children: [
                    escabezadoEstacion( context, plaga ),
                    SingleChildScrollView(
                        child: _listaDeEstaciones( context, plaga ),
                    ),
                    _prueba()
                ],
            ),
            bottomNavigationBar: BottomAppBar(
                child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Expanded(
                            child: _tomarDecisiones(),
                        ),
                        Expanded(
                            child: _tomarDecisiones(),
                        ),
                    ],
                ),
            ),
        );
    }

    Widget _prueba(){
        return StreamBuilder(
          stream: fincasBloc.countPlanta,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            List<Planta> plantas= snapshot.data;
            print(plantas.length);
            return Container(
              
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

    Widget  _listaDeEstaciones( BuildContext context, Testplaga plaga){
        return ListView.builder(
            itemBuilder: (context, index) {
                
                return FutureBuilder(
                    future: DBProvider.db.countPlanta(plaga.id,index+1),
                  
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                        }
                        
                        int value = snapshot.data;
                        //print(value);
                        return GestureDetector(
                            child: ListTile(
                                title: Column(
                                    children: [
                                        Text('Estacion ${index+1}'),
                                        Text('$value / 10')
                                    ],
                                ),
                                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.deepPurple,),
                            ),
                            onTap: () => Navigator.pushNamed(context, 'plantas', arguments: [plaga, index]),
                        );
                    },
                );
                
               
            },
            shrinkWrap: true,
            itemCount:  plaga.estaciones,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }

    Widget  _tomarDecisiones(){
        return RaisedButton.icon(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
            ),
            color: Colors.deepPurple,
            
            icon:Icon(Icons.save),
            textColor: Colors.white,
            label: Text('Editar finca'),
            onPressed: ()=> print('boton'),
            //onPressed: () => Navigator.pushNamed(context, 'addFinca', arguments: finca),
        );
    }
}