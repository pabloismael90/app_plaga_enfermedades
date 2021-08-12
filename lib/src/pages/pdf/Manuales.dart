import 'package:app_plaga_enfermedades/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';


class Manuales extends StatelessWidget {
  const Manuales({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: Text('Lista de instructivos'),),
            body: ListView(
                children: [
                    _card( context, 'Instructivo Plaga cacao', 'assets/documentos/Instructivo Plaga.pdf'),
                    _card( context, 'Manual de usuario Cacao Plaga', 'assets/documentos/Manual de usuario Cacao Plaga.pdf')
                ],
            )
        );
    }

    Widget _card( BuildContext context, String titulo, String url){
        return GestureDetector(
            child: cardDefault(
                tituloCard('$titulo'),
            ),
            onTap: () => Navigator.pushNamed(context, 'PDFview', arguments: [titulo, url]),
        );
    }


}