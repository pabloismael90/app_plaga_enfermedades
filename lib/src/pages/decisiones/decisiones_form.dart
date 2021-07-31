import 'package:app_plaga_enfermedades/src/models/acciones_model.dart';
import 'package:app_plaga_enfermedades/src/models/decisiones_model.dart';
import 'package:app_plaga_enfermedades/src/models/finca_model.dart';
import 'package:app_plaga_enfermedades/src/models/planta_model.dart';
import 'package:app_plaga_enfermedades/src/models/selectValue.dart' as selectMap;
import 'package:app_plaga_enfermedades/src/models/testplaga_model.dart';
import 'package:app_plaga_enfermedades/src/pages/finca/finca_page.dart';
import 'package:app_plaga_enfermedades/src/providers/db_provider.dart';
import 'package:app_plaga_enfermedades/src/utils/widget/button.dart';
import 'package:app_plaga_enfermedades/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:uuid/uuid.dart';

class DesicionesPage extends StatefulWidget {
    DesicionesPage({Key? key}) : super(key: key);

    @override
    _DesicionesPageState createState() => _DesicionesPageState();
}

class _DesicionesPageState extends State<DesicionesPage> {


    Decisiones decisiones = Decisiones();
    Acciones acciones = Acciones();
    List<Decisiones> listaDecisiones = [];
    List<Acciones> listaAcciones = [];
    String? idPlagaMain = "";
    bool _guardando = false;
    var uuid = Uuid();
    
    final List<Map<String, dynamic>>  itemPlagas = selectMap.plagasCacao();
    final List<Map<String, dynamic>>  itemSituacion = selectMap.situacionPlaga();
    final List<Map<String, dynamic>>  itemProbSuelo = selectMap.problemasPlagaSuelo();
    final List<Map<String, dynamic>>  itemProbSombra = selectMap.problemasPlagaSombra();
    final List<Map<String, dynamic>>  itemProbManejo = selectMap.problemasPlagaManejo();
    final List<Map<String, dynamic>>  _meses = selectMap.listMeses();
    final List<Map<String, dynamic>>  listSoluciones = selectMap.solucionesXmes();

    Widget textFalse = Text('0.00%', textAlign: TextAlign.center);
    final Map checksPrincipales = {};
    final Map checksSituacion = {};
    final Map checksSuelo = {};
    final Map checksSombra = {};
    final Map checksManejo = {};
    final Map itemActividad = {};
    final Map itemResultado = {};

    void checkKeys(){
        for(int i = 0 ; i < itemPlagas.length ; i ++){
            checksPrincipales[itemPlagas[i]['value']] = false;
        }
        for(int i = 0 ; i < itemSituacion.length ; i ++){
            checksSituacion[itemSituacion[i]['value']] = false; 
        }
        for(int i = 0 ; i < itemProbSuelo.length ; i ++){
            checksSuelo[itemProbSuelo[i]['value']] = false;
        }
        for(int i = 0 ; i < itemProbSombra.length ; i ++){
            checksSombra[itemProbSombra[i]['value']] = false;
        }

        for(int i = 0 ; i < itemProbManejo.length ; i ++){
            checksManejo[itemProbManejo[i]['value']] = false;
        }
        for(int i = 0 ; i < listSoluciones.length ; i ++){
            itemActividad[i] = [];
            itemResultado[i] = '';
        }
    }
    


    final formKey = new GlobalKey<FormState>();

    Future<double> _countPercentPlaga(String? idTest, int estacion, int idPlaga) async{
        double countPalga = await DBProvider.db.countPlagaEstacion(idTest, estacion, idPlaga);         
        return countPalga*100;
    }
    
    Future<double> _countPercentTotal(String? idTest,int idPlaga) async{
        double countPalga = await DBProvider.db.countPlagaTotal(idTest, idPlaga);         
        return countPalga*100;
    }


    Future<double> _countPercentProduccion(String? idTest, int estacion, int estado) async{
        double countProduccion = await DBProvider.db.countProduccion(idTest, estacion, estado);
        return countProduccion*100;
    }

    Future<double> _countPercentTotalProduccion(String? idTest, int estado) async{
        double countProduccion = await DBProvider.db.countTotalProduccion(idTest, estado);
        return countProduccion*100;
    }

    Future<int?> _mazorcaSana(String? idTest, int estacion) async{
        int? countSanas = await DBProvider.db.countMazorcaSana(idTest!, estacion);
        return countSanas;
    }
    Future<int?> _mazorcaEnfermas(String? idTest, int estacion) async{
        int? countSanas = await DBProvider.db.countMazorcaEnfermas(idTest!, estacion);
        return countSanas;
    }
    Future<int?> _mazorcaDanadas(String? idTest, int estacion) async{
        int? countSanas = await DBProvider.db.countMazorcaDanadas(idTest!, estacion);
        return countSanas;
    }
    
    @override
    void initState() {
        super.initState();
        checkKeys();
    }


    @override
    Widget build(BuildContext context) {
        Testplaga? plagaTest = ModalRoute.of(context)!.settings.arguments as Testplaga?;
        
       
        Future _getdataFinca() async{
            List<List> totalEstacion = [];

            Finca? finca = await DBProvider.db.getFincaId(plagaTest!.idFinca);
            Parcela? parcela = await DBProvider.db.getParcelaId(plagaTest.idLote);
            List<Planta> plantas = await DBProvider.db.getTodasPlantaIdTest(plagaTest.id);
            for (var i = 0; i < 4; i++) {
                totalEstacion.add(
                    [
                        await _mazorcaSana(plagaTest.id, i),
                        await _mazorcaEnfermas(plagaTest.id, i),
                        await _mazorcaDanadas(plagaTest.id, i),
                    ]
                );
                
            }
            
            return [finca, parcela, plantas, totalEstacion];
        }

    

        return Scaffold(
            appBar: AppBar(title: Text('Toma de Decisiones'),),
            body: FutureBuilder(
                future: _getdataFinca(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }
                    List<Widget> pageItem = [];
                    Finca finca = snapshot.data[0];
                    Parcela parcela = snapshot.data[1];
                    List estacionTotal = snapshot.data[3];
                    
                    pageItem.add(_principalData(finca, parcela, plagaTest!.id));
                    pageItem.add(_datosCosecha(finca, parcela, plagaTest.id, estacionTotal));
                    pageItem.add(_plagasPrincipales());   
                    pageItem.add(_situacionPlaga());   
                    pageItem.add(_problemasSuelo());   
                    pageItem.add(_problemasSombra());   
                    pageItem.add(_problemasManejo());   
                    pageItem.add(_accionesMeses());   
                    pageItem.add(_botonsubmit(plagaTest.id));   

                    return Column(
                        children: [
                            mensajeSwipe('Deslice hacia la izquierda para continuar con el formulario'),
                            Expanded(
                                
                                child: Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.all(15),
                                    child: Swiper(
                                        itemBuilder: (BuildContext context, int index) {
                                            return pageItem[index];
                                        },
                                        itemCount: pageItem.length,
                                        viewportFraction: 1,
                                        loop: false,
                                        scale: 1,
                                    ),
                                ),
                            ),
                        ],
                    );

                        
                },
            ),
            
            
        );
    }

    Widget _principalData(Finca finca, Parcela parcela, String? plagaid){
        return Container(
            decoration: BoxDecoration(
                
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
                children: [
                    _dataFincas( context, finca, parcela),
                    Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                                children: [
                                    Container(
                                        padding: EdgeInsets.symmetric(vertical: 10),
                                        child: InkWell(
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                    Container(                                                                    
                                                        child: Text(
                                                            "Porcentaje de plantas afectadas",
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)
                                                        ),
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Icon(
                                                            Icons.info_outline_rounded,
                                                            color: Colors.green,
                                                            size: 20,
                                                        ),
                                                    ),
                                                ],
                                            ),
                                            onTap: () => _explicacion(context),
                                        ),
                                    ),
                                    Divider(),
                                    Column(
                                        children: [
                                            _encabezadoTabla(),
                                            Divider(),
                                            _countPlagas(plagaid, 1),
                                            _countProduccion(plagaid),
                                        ],
                                    ),
                                ],
                            ),
                        ),
                    )
                    
                ],
            ),
        ); 
    }

    Widget _dataFincas( BuildContext context, Finca finca, Parcela parcela ){
        String? labelMedidaFinca;
        String? labelvariedad;

        labelMedidaFinca = selectMap.dimenciones().firstWhere((e) => e['value'] == '${finca.tipoMedida}')['label'];
        labelvariedad = selectMap.variedadCacao().firstWhere((e) => e['value'] == '${parcela.variedadCacao}')['label'];

        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                encabezadoCard('${finca.nombreFinca}','Parcela: ${parcela.nombreLote}', ''),
                textoCardBody('Productor: ${finca.nombreProductor}'),
                tecnico('${finca.nombreTecnico}'),
                textoCardBody('Variedad: $labelvariedad'),
                Wrap(
                    spacing: 20,
                    children: [
                        textoCardBody('Área Finca: ${finca.areaFinca} ($labelMedidaFinca)'),
                        textoCardBody('Área Parcela: ${parcela.areaLote} ($labelMedidaFinca)'),
                        textoCardBody('N de plantas: ${parcela.numeroPlanta}'),
                    ],
                ),
            ],  
        );

    }
    
    Widget _encabezadoTabla(){
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                Expanded(child: textList('Estaciones'),),
                Container(
                    width: 50,
                    child: titleList('1'),
                ),
                Container(
                    width: 50,
                    child: titleList('2'),
                ),
                Container(
                    width: 50,
                    child: titleList('3')
                ),
                Container(
                    width: 50,
                    child: titleList('Total'),
                ),
            ],
        );
    }

    Widget _countPlagas(String? idTest, int estacion){
        List<Widget> lisItem = [];

        for (var i = 0; i < itemPlagas.length; i++) {
            String? labelPlaga = itemPlagas.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            int idplga = int.parse(itemPlagas.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "100","label": "No data"})['value']);
            lisItem.add(
                Row(
                    children: [
                        Expanded(child: textList('$labelPlaga'),),
                        Container(
                            width: 50,
                            child: FutureBuilder(
                                future: _countPercentPlaga(idTest, 1, idplga),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }
                                    return _labelColor(snapshot.data);
                                },
                            ),
                        ),
                        Container(
                            width: 50,
                            child: FutureBuilder(
                                future: _countPercentPlaga(idTest, 2, idplga),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }

                                    return _labelColor(snapshot.data);
                                },
                            ),
                        ),
                        Container(
                            width: 50,
                            child: FutureBuilder(
                                future: _countPercentPlaga(idTest, 3, idplga),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }

                                    return _labelColor(snapshot.data);
                                },
                            ),
                        ),
                        Container(
                            width: 50,
                            child: FutureBuilder(
                                future: _countPercentTotal(idTest, idplga),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }

                                    return _labelColor(snapshot.data);
                                },
                            ),
                        ),
                        
                    ],
                )
            );
            lisItem.add(Divider());
        }
        return Column(children:lisItem,);
    }

    Widget _countProduccion(String? idTest){
        List<Widget> lisProd= [];

        List<String> nameProd = ['Alta','Media','Baja'];
        lisProd.add(titleList('Producción'));
        lisProd.add(Divider());
        for (var i = 0; i < nameProd.length; i++) {
            lisProd.add(

                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(child: textList('%${nameProd[i]}'),),
                        Container(
                            width: 50,
                            child: FutureBuilder(
                                future: _countPercentProduccion(idTest, 1, i+1),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }
                                    return Text('${snapshot.data.toStringAsFixed(0)}%', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),);
                                },
                            ),
                        ),
                        Container(
                            width: 50,
                            child: FutureBuilder(
                                future: _countPercentProduccion(idTest, 2, i+1),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }
                                    return Text('${snapshot.data.toStringAsFixed(0)}%', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),);
                                },
                            ),
                        ),
                        Container(
                            width: 50,
                            child: FutureBuilder(
                                future: _countPercentProduccion(idTest, 3, i+1),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }
                                    return Text('${snapshot.data.toStringAsFixed(0)}%', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),);
                                },
                            ),
                        ),
                        Container(
                            width: 50,
                            child: FutureBuilder(
                                future: _countPercentTotalProduccion(idTest, i+1),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }
                                    return Text('${snapshot.data.toStringAsFixed(0)}%', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),);
                                },
                            ),
                        ),
                    ],
                )
            );
            lisProd.add(Divider());
        }
        return Column(children:lisProd,);
    }

    Widget _labelColor(double valor){
        if (valor >= 0 && valor <= 15) {
            return Text('${valor.toStringAsFixed(0)}%', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green[900]),);
        } else if (valor >= 16 && valor <= 50){
            return Text('${valor.toStringAsFixed(0)}%', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange[900]),);
        }else{
            return Text('${valor.toStringAsFixed(0)}%', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red[900]),);
        }

        
    }


    Widget _datosCosecha(Finca finca, Parcela parcela, String? plagaTest, List estacionTotal){
        String? labelMedidaFinca;

        labelMedidaFinca = selectMap.dimenciones().firstWhere((e) => e['value'] == '${finca.tipoMedida}')['label'];
        double? factorBaba = 5;
        double? factorSeco = 3;
        return SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    // encabezadoCard('${finca.nombreFinca}','Parcela: ${parcela.nombreLote}', ''),
                    textoCardBody('Área Parcela: ${parcela.areaLote} ($labelMedidaFinca)'),
                    textoCardBody('Numero de plantas productivas: ${parcela.numeroPlanta}'),
                    textoCardBody('Número de mazorcas para 1 lb cacao en baba: $factorBaba'),
                    textoCardBody('QQ de baba para producir QQ de granos seco: $factorSeco'),
                    Divider(),
                    _tablaEstimacion(parcela, labelMedidaFinca, factorBaba, factorSeco, estacionTotal)
                ],  
            ),
        );

    }

    Widget _tablaEstimacion(Parcela parcela, String? labelMedidaFinca, double? factorBaba, double? factorSeco, List estacionTotal){
        List<Widget> listPrincipales = [];

        listPrincipales.add(
            Row(
                children: [
                    Expanded(child: textList(''),),
                    Container(
                        width: 70,
                        child: titleList('Sanas'),
                    ),
                    Container(
                        width: 70,
                        child: titleList('Enfermas'),
                    ),
                    Container(
                        width: 70,
                        child: titleList('Dañadas'),
                    ),
                ],
            ),
        );
        listPrincipales.add(Divider());

        for (var i = 1; i < estacionTotal.length; i++) {
            listPrincipales.add(
                Row(
                    children: [
                        Expanded(child: textList('Número de mazorcas en Sitio $i'),),
                        Container(
                            width: 70,
                            child: numberFormar(estacionTotal[i][0], '')
                        ),
                        Container(
                            width: 70,
                            child: numberFormar(estacionTotal[i][1], '')
                        ),
                        Container(
                            width: 70,
                            child: numberFormar(estacionTotal[i][2], '')
                        ),
                    ],
                ),
            );
            listPrincipales.add(Divider());
        }
        listPrincipales.add(
            Row(
                children: [
                    Expanded(child: textList('Total # de mazorcas en 3 Sitios'),),
                    Container(
                        width: 70,
                        child: numberFormar(estacionTotal[0][0], '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar(estacionTotal[0][1],'')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar(estacionTotal[0][2], '')
                    ),
                ],
            ),
        );
        listPrincipales.add(Divider());

        listPrincipales.add(
            Row(
                children: [
                    Expanded(child: textList('Número de plantas muestreadas'),),
                    Container(
                        width: 70,
                        child: numberFormar(10, '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar(10, '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar(10, '')
                    ),
                ],
            ),
        );
        listPrincipales.add(Divider());
        
        listPrincipales.add(
            Row(
                children: [
                    Expanded(child: textList('Promedio # mazorcas por planta'),),
                    Container(
                        width: 70,
                        child: numberFormar(estacionTotal[0][0]/10, '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar(estacionTotal[0][1]/10, '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar(estacionTotal[0][2]/10, '')
                    ),
                ],
            ),
        );
        listPrincipales.add(Divider());

        listPrincipales.add(
            Row(
                children: [
                    Expanded(child: textList('Numero de mazorcas en la parcela'),),
                    Container(
                        width: 70,
                        child: numberFormar((estacionTotal[0][0]/10)*parcela.numeroPlanta, '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar((estacionTotal[0][1]/10)*parcela.numeroPlanta, '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar((estacionTotal[0][2]/10)*parcela.numeroPlanta, '')
                    ),
                ],
            ),
        );
        listPrincipales.add(Divider());
        
        listPrincipales.add(
            Row(
                children: [
                    Expanded(child: textList('Número de mazorcas por $labelMedidaFinca'),),
                    Container(
                        width: 70,
                        child: numberFormar(((estacionTotal[0][0]/10)*parcela.numeroPlanta)/parcela.areaLote, '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar(((estacionTotal[0][1]/10)*parcela.numeroPlanta)/parcela.areaLote, '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar(((estacionTotal[0][2]/10)*parcela.numeroPlanta)/parcela.areaLote, '')
                    ),
                ],
            ),
        );
        listPrincipales.add(Divider());

        listPrincipales.add(
            Row(
                children: [
                    Expanded(child: textList('Peso de baba en QQ por $labelMedidaFinca'),),
                    Container(
                        width: 70,
                        child: numberFormar(((estacionTotal[0][0]/10)*parcela.numeroPlanta)/(factorBaba!*100), '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar(((estacionTotal[0][1]/10)*parcela.numeroPlanta)/(factorBaba*100), '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar(((estacionTotal[0][2]/10)*parcela.numeroPlanta)/(factorBaba*100), '')
                    ),
                ],
            ),
        );
        listPrincipales.add(Divider());
        double pesoGramoEstacion1 = (((estacionTotal[0][0]/10)*parcela.numeroPlanta)/(factorBaba*100))/factorSeco;
        double pesoGramoEstacion2 = (((estacionTotal[0][1]/10)*parcela.numeroPlanta)/(factorBaba*100))/factorSeco;
        double pesoGramoEstacion3 = (((estacionTotal[0][2]/10)*parcela.numeroPlanta)/(factorBaba*100))/factorSeco;

        listPrincipales.add(
            Row(
                children: [
                    Expanded(child: textList('Peso de granos seco QQ por $labelMedidaFinca'),),
                    Container(
                        width: 70,
                        child: numberFormar(pesoGramoEstacion1, '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar(pesoGramoEstacion2, '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar(pesoGramoEstacion3, '')
                    ),
                ],
            ),
        );
        listPrincipales.add(Divider());
        
        double totalPesoGrano = pesoGramoEstacion1 + pesoGramoEstacion2 + pesoGramoEstacion3;

        listPrincipales.add(
            Row(
                children: [
                    Expanded(child: textList('Pérdida'),),
                    Container(
                        width: 70,
                        child: textList('')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar((pesoGramoEstacion2/totalPesoGrano)*100, '%')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar((pesoGramoEstacion3/totalPesoGrano)*100, '%')
                    ),
                ],
            ),
        );
        listPrincipales.add(Divider());

        return Column(children:listPrincipales,);
    }
    


    Widget _plagasPrincipales(){
        List<Widget> listPrincipales = [];

        listPrincipales.add(tituloDivider('Plagas principales del momento'));

        for (var i = 0; i < itemPlagas.length; i++) {
            String? labelPlaga = itemPlagas.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            
            listPrincipales.add(

                CheckboxListTile(
                    title: Text('$labelPlaga'),
                    value: checksPrincipales[itemPlagas[i]['value']], 
                    onChanged: (value) {
                        setState(() {
                            checksPrincipales[itemPlagas[i]['value']] = value;
                        });
                    },
                )                  
                    
            );
        }
        
        return SingleChildScrollView(
            child: Column(children:listPrincipales,),
        );
    }

    Widget _situacionPlaga(){
        List<Widget> listSituacionPlaga = [];

        listSituacionPlaga.add(tituloDivider('Situación de las plagas en la parcela'));
        
        for (var i = 0; i < itemSituacion.length; i++) {
            String? labelSituacion = itemSituacion.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            
            listSituacionPlaga.add(
                CheckboxListTile(
                    title: Text('$labelSituacion'),
                    value: checksSituacion[itemSituacion[i]['value']], 
                    onChanged: (value) {
                        setState(() {
                            checksSituacion[itemSituacion[i]['value']] = value;
                        });
                    },
                )
            );
        }
        
        return SingleChildScrollView(
            child: Column(children:listSituacionPlaga,),
        );
    }

    Widget _problemasSuelo(){
        List<Widget> listProblemasSuelo = [];

        listProblemasSuelo.add(tituloDivider("¿Porqué hay problemas de plagas?  Suelo"));
        
        for (var i = 0; i < itemProbSuelo.length; i++) {
            String? labelProblemaSuelo = itemProbSuelo.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            
            listProblemasSuelo.add(
                CheckboxListTile(
                    title: Text('$labelProblemaSuelo'),
                    value: checksSuelo[itemProbSuelo[i]['value']], 
                    onChanged: (value) {
                        setState(() {
                            checksSuelo[itemProbSuelo[i]['value']] = value;
                        });
                    },
                )
            );
        }

        return SingleChildScrollView(
            child: Column(children:listProblemasSuelo,),
        );
    }

    Widget _problemasSombra(){
        List<Widget> listProblemasSombra = [];

        listProblemasSombra.add(tituloDivider("¿Porqué hay problemas de plagas?  Sombra"));

        for (var i = 0; i < itemProbSombra.length; i++) {
            String? labelProblemaSombra = itemProbSombra.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            
            listProblemasSombra.add(
                CheckboxListTile(
                    title: Text('$labelProblemaSombra'),
                    value: checksSombra[itemProbSombra[i]['value']], 
                    onChanged: (value) {
                        setState(() {
                            checksSombra[itemProbSombra[i]['value']] = value;
                        });
                    },
                )                  
            );
        }
        
        return SingleChildScrollView(
            child: Column(children:listProblemasSombra,),
        );
    }

    Widget _problemasManejo(){
        List<Widget> listProblemasManejo = [];

        listProblemasManejo.add(tituloDivider("¿Porqué hay problemas de plagas?  Manejo"));

        for (var i = 0; i < itemProbManejo.length; i++) {
            String? labelProblemaManejo = itemProbManejo.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            
            listProblemasManejo.add(
                CheckboxListTile(
                    title: Text('$labelProblemaManejo'),
                    value: checksManejo[itemProbManejo[i]['value']], 
                    onChanged: (value) {
                        setState(() {
                            checksManejo[itemProbManejo[i]['value']] = value;
                        });
                    },
                )
            );
        }
        return SingleChildScrollView(
            child: Column(children:listProblemasManejo,),
        );
    }

    Widget _accionesMeses(){
        List<Widget> listaAcciones = [];
        listaAcciones.add(tituloDivider("¿Qué acciones vamos a realizar y cuando?"));
        for (var i = 0; i < listSoluciones.length; i++) {
            String? labelSoluciones = listSoluciones.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            
            listaAcciones.add(
                Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: MultiSelectFormField(
                        chipBackGroundColor: Colors.deepPurple,
                        chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                        dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                        checkBoxActiveColor: Colors.deepPurple,
                        checkBoxCheckColor: Colors.white,
                        dialogShapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12.0))
                        ),
                        title: Text(
                            "$labelSoluciones",
                            style: TextStyle(fontSize: 16),
                        ),
                        validator: (value) {
                            if (value == null || value.length == 0) {
                            return 'Seleccione una o mas opciones';
                            }
                            return null;
                        },
                        dataSource: _meses,
                        textField: 'label',
                        valueField: 'value',
                        okButtonLabel: 'Aceptar',
                        cancelButtonLabel: 'Cancelar',
                        hintWidget: Text('Seleccione una o mas meses'),
                        initialValue: itemActividad[i],
                        onSaved: (value) {
                            if (value == null) return;
                                setState(() {
                                itemActividad[i] = value;
                            });
                        },
                    ),
                )
            );
        }

        return SingleChildScrollView(
            child: Column(children:listaAcciones,),
        );
    }


    Widget  _botonsubmit(String? idplaga){
        idPlagaMain = idplaga;

        return SingleChildScrollView(
            child: Container(
                child: Column(
                    children: [
                        Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 30),
                            child: Text(
                                "¿Ha Terminado todos los formularios de toma de desición?",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)
                            ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 60),
                            child: ButtonMainStyle(
                                title: 'Guardar',
                                icon: Icons.save,
                                press: (_guardando) ? null : _submit,
                            )
                        ),
                    ],
                ),
            ),
        );
    }

    _listaDecisiones(Map checksPreguntas, int pregunta){
        checksPreguntas.forEach((key, value) {
            final Decisiones itemDesisiones = Decisiones();
            itemDesisiones.id = uuid.v1();
            itemDesisiones.idPregunta = pregunta;
            itemDesisiones.idItem = int.parse(key);
            itemDesisiones.repuesta = value ? 1 : 0;
            itemDesisiones.idTest = idPlagaMain;
            listaDecisiones.add(itemDesisiones);
        });
    }

    _listaAcciones(){
        itemActividad.forEach((key, value) {
            final Acciones itemAcciones = Acciones();
            itemAcciones.id = uuid.v1();
            itemAcciones.idItem = key;
            itemAcciones.repuesta = value.toString();
            itemAcciones.idTest = idPlagaMain;
            listaAcciones.add(itemAcciones);
        });
    }

    void _submit(){
        setState(() {_guardando = true;});
        _listaDecisiones(checksPrincipales, 1);
        _listaDecisiones(checksSituacion, 2);
        _listaDecisiones(checksSuelo, 3);
        _listaDecisiones(checksSombra, 4);
        _listaDecisiones(checksManejo, 5);
        _listaAcciones();

        listaDecisiones.forEach((decision) {
            DBProvider.db.nuevaDecision(decision);
        });

        
        
        listaAcciones.forEach((accion) {
            DBProvider.db.nuevaAccion(accion);
        });
        fincasBloc.obtenerDecisiones(idPlagaMain);
        setState(() {_guardando = false;});

        Navigator.pop(context, 'estaciones');
    }

    Future<void> _explicacion(BuildContext context){

        return dialogText(
            context,
            Column(
                children: [
                    textoCardBody('•	Las observaciones sobre sobre plagas, enfermedades, cosecha y pérdida se presentan en dos pantallas.'),
                    textoCardBody('•	En la primera pantalla se indican la prevalencia de plagas y enfermedades con los siguientes datos:'),
                    textoCardBody(' o	% plantas de cacao afectadas por enfermedades'),
                    textoCardBody(' o	% plantas de cacao afectadas por los insectos y otras plagas'),
                    textoCardBody(' o	% plantas con deficiencias nutricionales'),
                    textoCardBody(' o	% plantas con alto, medio y bajo rendimiento'),
                    textoCardBody('•	Estos datos nos ayudan a entender el grado de afectación de las parcelas por las diferentes plagas y enfermedades.'),
                    textoCardBody('•	En la segunda pantalla se presenta datos sobre Número de mazorcas sanas, enfermas y dañadas en los tres sitios. En base de esto se estima # de mazorcas sanas, enfermas y dañadas en las parcelas. Con estos datos se estima la cosecha y pérdida en cosecha causada por las enfermedades y plagas.'),
                ],
            ),
            'Explicación de la tabla de datos'
        );
    }

}