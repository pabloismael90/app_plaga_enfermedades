import 'package:app_plaga_enfermedades/src/models/finca_model.dart';
import 'package:app_plaga_enfermedades/src/models/planta_model.dart';
//import 'package:app_plaga_enfermedades/src/models/planta_model.dart';
import 'package:app_plaga_enfermedades/src/models/selectValue.dart' as selectMap;
import 'package:app_plaga_enfermedades/src/models/testplaga_model.dart';
import 'package:app_plaga_enfermedades/src/providers/db_provider.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_swiper/flutter_swiper.dart';

class DesicionesPage extends StatefulWidget {
    DesicionesPage({Key key}) : super(key: key);

    @override
    _DesicionesPageState createState() => _DesicionesPageState();
}

class _DesicionesPageState extends State<DesicionesPage> {
    @override
    Widget build(BuildContext context) {
        Testplaga plagaTest = ModalRoute.of(context).settings.arguments;

        Future _getdataFinca() async{
            Finca finca = await DBProvider.db.getFincaId(plagaTest.idFinca);
            Parcela parcela = await DBProvider.db.getParcelaId(plagaTest.idLote);
            List<Planta> plantas = await DBProvider.db.getTodasPlantaIdTest(plagaTest.id);
            

            return [finca, parcela, plantas];
        }

        

        return Scaffold(
            appBar: AppBar(
                title: Text('Toma de Decisiones'),
            ),
            body: FutureBuilder(
                future: _getdataFinca(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }
                    Finca finca = snapshot.data[0];
                    Parcela parcela = snapshot.data[1];
                    List<Planta> plantas= snapshot.data[2];

                    return Container(
                        decoration: BoxDecoration(
                            color: Colors.deepPurple
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                            children: [
                                Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        _dataFincas( context, finca ),
                                        _dataParcela( context, parcela ),
                                    ],
                                ),

                                Expanded(
                                    child: SingleChildScrollView(
                                        child: _analisisData(plantas)
                                    ),
                                ),
                                
                                
                            ],
                        ),
                    );

                },
            ),
        );
    }

    Widget _dataFincas( BuildContext context, Finca finca ){
        String labelMedida;
        final item = selectMap.dimenciones().firstWhere((e) => e['value'] == '${finca.tipoMedida}');
        labelMedida  = item['label'];

        return Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                        'Finca: ${finca.nombreFinca}', 
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0
                        ),
                    ),
                    Text(
                        'Area: ${finca.areaFinca} ($labelMedida)', 
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0
                        ),
                    ),
                    Text(
                        'Productor: ${finca.nombreProductor}', 
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0
                        ),
                    ),
                ],
            ),
        );
    }
    
    Widget _dataParcela( BuildContext context, Parcela parcela ){
        String labelMedida;
        String labelvariedad;
        

        final item = selectMap.dimenciones().firstWhere((e) => e['value'] == '${parcela.tipoMedida}');
        labelMedida  = item['label'];

        final itemvariedad = selectMap.variedadCacao().firstWhere((e) => e['value'] == '${parcela.tipoMedida}');
        labelvariedad  = itemvariedad['label'];
        
        return Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                        'Finca: ${parcela.nombreLote}', 
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0
                        ),
                    ),
                    Text(
                        'Area: ${parcela.areaLote} ($labelMedida)', 
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0
                        ),
                    ),

                    Text(
                        'Plantas: ${parcela.numeroPlanta} - $labelvariedad', 
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0
                        ),
                    ),
                    
                ],
            ),
        );
    }


    Widget _analisisData(List<Planta> plantas){
        return Container(
            color: Colors.white,
            child: Column(
                children: [
                    Text(
                        '% de plantas afectadas', 
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0
                        ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                            Expanded(child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Text('Plaga', textAlign: TextAlign.left, style:TextStyle(fontWeight: FontWeight.bold) ,),
                            ),),
                            Container(
                                width: 50.0,
                                child: Text('1', textAlign: TextAlign.center, style:TextStyle(fontWeight: FontWeight.bold) ,),
                            ),
                            Container(
                                width: 50.0,
                                child: Text('2', textAlign: TextAlign.center, style:TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Container(
                                width: 50.0,
                                child: Text('3', textAlign: TextAlign.center, style:TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Container(
                                width: 50.0,
                                child: Text('Total', textAlign: TextAlign.center, style:TextStyle(fontWeight: FontWeight.bold)),
                                //color: Colors.deepPurple,
                            ),
                        ],
                    ),

                   

                ],
            ),
            
        );
    }

   

}