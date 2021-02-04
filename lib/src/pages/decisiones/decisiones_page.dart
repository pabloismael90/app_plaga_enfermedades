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

    final List<Map<String, dynamic>>  itemPlagas = selectMap.plagasCacao();

    Future<double> _countPercentPlaga(String idTest, int estacion, int idPlaga) async{
        double countPalga = await DBProvider.db.countPlagaEstacion(idTest, estacion, idPlaga);         
        return countPalga*100;
    }
    Future<double> _countPercentTotal(String idTest,int idPlaga) async{
        double countPalga = await DBProvider.db.countPlagaTotal(idTest, idPlaga);         
        return countPalga*100;
    }

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
                    //List<Planta> plantas= snapshot.data[2];

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
                                        child: Container(
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
                                                    _encabezadoTabla(),
                                                    _countPlagas(plagaTest.id, 1),
                                                    
                                                ],
                                            ),
                                        ),
                                    ),
                                )
                                
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
            width: MediaQuery.of(context).size.width*0.5,
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
            width: MediaQuery.of(context).size.width*0.5,
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

    Widget _encabezadoTabla(){
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                Expanded(child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text('Plaga', textAlign: TextAlign.left, style:TextStyle(fontWeight: FontWeight.bold) ,),
                ),),
                Container(
                    width: 68.0,
                    child: Text('1', textAlign: TextAlign.center, style:TextStyle(fontWeight: FontWeight.bold) ,),
                ),
                Container(
                    width: 68.0,
                    child: Text('2', textAlign: TextAlign.center, style:TextStyle(fontWeight: FontWeight.bold)),
                ),
                Container(
                    width: 68.0,
                    child: Text('3', textAlign: TextAlign.center, style:TextStyle(fontWeight: FontWeight.bold)),
                ),
                Container(
                    width: 68.0,
                    child: Text('Total', textAlign: TextAlign.center, style:TextStyle(fontWeight: FontWeight.bold)),
                    //color: Colors.deepPurple,
                ),
            ],
        );
    }

    Widget _countPlagas(String idTest, int estacion){
        List<Widget> lisItem = List<Widget>();

        for (var i = 0; i < itemPlagas.length; i++) {
            String labelPlaga = itemPlagas.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            int idplga = int.parse(itemPlagas.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "100","label": "No data"})['value']);
            lisItem.add(
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text('$labelPlaga', textAlign: TextAlign.left, style:TextStyle(fontWeight: FontWeight.bold) ,),
                        ),),
                        Container(
                            width: 68.0,
                            child: FutureBuilder(
                                future: _countPercentPlaga(idTest, 1, idplga),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return CircularProgressIndicator();
                                    }
                                    
                                    return Text('${snapshot.data.toStringAsFixed(2)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 68.0,
                            child: FutureBuilder(
                                future: _countPercentPlaga(idTest, 2, idplga),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return CircularProgressIndicator();
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(2)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 68.0,
                            child: FutureBuilder(
                                future: _countPercentPlaga(idTest, 3, idplga),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return CircularProgressIndicator();
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(2)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 68.0,
                            child: FutureBuilder(
                                future: _countPercentTotal(idTest, idplga),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return CircularProgressIndicator();
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(2)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        
                    ],
                )
            );
        }
        return Column(children:lisItem,);
    }



}