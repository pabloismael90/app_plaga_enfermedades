import 'package:app_plaga_enfermedades/src/models/acciones_model.dart';
import 'package:app_plaga_enfermedades/src/models/testplaga_model.dart';
import 'package:app_plaga_enfermedades/src/providers/db_provider.dart';
import 'package:app_plaga_enfermedades/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';

class DesicionesList extends StatelessWidget {
    const DesicionesList({Key? key}) : super(key: key);

    
    Future getRegistros() async{
        
        List<Acciones> listAcciones= await DBProvider.db.getTodasAcciones();

        return listAcciones;
    }

    Future getDatos(String? id) async{
        
        Testplaga? testplaga= await (DBProvider.db.getTestId(id));

        Finca? finca = await DBProvider.db.getFincaId(testplaga!.idFinca);
        Parcela? parcela = await DBProvider.db.getParcelaId(testplaga.idLote);

        return [testplaga, finca, parcela];
    }

    @override
    Widget build(BuildContext context) {
        
        return Scaffold(
            appBar: AppBar(title: Text('Reportes'),),
            body: FutureBuilder(
                future: getRegistros(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }

                    return Column(
                        children: [
                            Expanded(
                                child:
                                snapshot.data.length == 0
                                ?
                                textoListaVacio('Complete toma de Decisiones')
                                :
                                SingleChildScrollView(child: _listaDePlagas(snapshot.data, context))
                            ),
                        ],
                    );

                },
            ),
        );
    }

    Widget  _listaDePlagas(List acciones, BuildContext context){
        return ListView.builder(
            itemBuilder: (context, index) {
                return FutureBuilder(
                    future: getDatos(acciones[index].idTest),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                        }
                        Testplaga testplagadata = snapshot.data[0];
                        Finca fincadata = snapshot.data[1];
                        Parcela parceladata = snapshot.data[2];

                        return GestureDetector(
                            child: _cardDesiciones(testplagadata,fincadata,parceladata, context),
                            onTap: () => Navigator.pushNamed(context, 'reporte', arguments: testplagadata),
                        );
                    },
                );
               
            },
            shrinkWrap: true,
            itemCount: acciones.length,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }

   Widget _cardDesiciones(Testplaga testplaga, Finca finca, Parcela parcela, BuildContext context){
        return cardDefault(
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    encabezadoCard('${finca.nombreFinca}','${parcela.nombreLote}', 'assets/icons/report.svg'),
                    textoCardBody('Fecha: ${testplaga.fechaTest}'),
                    iconTap(' Toca para ver reporte')
                ],
            )  
                  
        );
    }
   
}