import 'package:app_plaga_enfermedades/src/models/testplaga_model.dart';
import 'package:flutter/material.dart';

class EstacionesPage extends StatelessWidget {
    const EstacionesPage({Key key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        
        Testplaga plaga = ModalRoute.of(context).settings.arguments; 
        
        return Scaffold(
            appBar: AppBar(
                title: Text('Lista de Estaciones'),
            ),
            body: Column(
                children: [
                    escabezadoEstacion( context, plaga ),
                    SingleChildScrollView(
                        child: _listaDeEstaciones( context, plaga ),
                    )
                ],
            ),
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
                return GestureDetector(
                    child: ListTile(
                        title: Text('Estacion ${index+1}'),
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


}