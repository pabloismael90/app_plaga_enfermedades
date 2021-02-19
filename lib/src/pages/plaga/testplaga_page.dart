import 'package:app_plaga_enfermedades/src/bloc/fincas_bloc.dart';
import 'package:app_plaga_enfermedades/src/models/testplaga_model.dart';
import 'package:app_plaga_enfermedades/src/providers/db_provider.dart';
import 'package:app_plaga_enfermedades/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


final fincasBloc = new FincasBloc();

class TestPage extends StatefulWidget {

    
    

  @override
  _TestPageState createState() => _TestPageState();
}


class _TestPageState extends State<TestPage> {


    Future _getdataFinca(Testplaga textPlaga) async{
        Finca finca = await DBProvider.db.getFincaId(textPlaga.idFinca);
        Parcela parcela = await DBProvider.db.getParcelaId(textPlaga.idLote);
        return [finca, parcela];
    }

    @override
    Widget build(BuildContext context) {
        var size = MediaQuery.of(context).size;
        fincasBloc.obtenerPlagas();

        return Scaffold(
                appBar: AppBar(),
                body: StreamBuilder<List<Testplaga>>(
                    stream: fincasBloc.plagaStream,

                    
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());

                        }

                        List<Testplaga> textPlagas= snapshot.data;
                        
                        return Column(
                            children: [
                                Container(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 20),
                                        child: Text(
                                            "Lista de toma de datos",
                                            style: Theme.of(context).textTheme
                                                .headline5
                                                .copyWith(fontWeight: FontWeight.w900, color: kRedColor)
                                        ),
                                    )
                                ),
                                Expanded(child: _listaDePlagas(textPlagas, size, context))
                            ],
                        );
                        
                        
                    },
                ),
                bottomNavigationBar: BottomAppBar(
                    child: Container(
                        color: kBackgroundColor,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                            child: _addtest(context)
                        ),
                    ),
                ),
        );
        
    }

    Widget _addtest(BuildContext context){
        return RaisedButton.icon(
            icon:Icon(Icons.add_circle_outline_outlined),
            
            label: Text('Tomar Datos',
                style: Theme.of(context).textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.w600, color: Colors.white)
            ),
            padding:EdgeInsets.all(13),
            onPressed:() => Navigator.pushNamed(context, 'addTest'),
        );
    }

    Widget  _listaDePlagas(List textPlagas, Size size, BuildContext context){
        return ListView.builder(
            itemBuilder: (context, index) {
                return GestureDetector(
                    child: FutureBuilder(
                        future: _getdataFinca(textPlagas[index]),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                                return Center(child: CircularProgressIndicator());
                            }
                            Finca finca = snapshot.data[0];
                            Parcela parcela = snapshot.data[1];

                            return _cardTest(size, textPlagas[index], finca, parcela);
                        },
                    ),
                    onTap: () => Navigator.pushNamed(context, 'estaciones', arguments: textPlagas[index]),
                );
               
            },
            shrinkWrap: true,
            itemCount: textPlagas.length,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }

    Widget _cardTest(Size size, Testplaga textPlaga, Finca finca, Parcela parcela){
        return Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(38.5),
                    boxShadow: [
                        BoxShadow(
                                color: Color(0xFF3A5160)
                                    .withOpacity(0.05),
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 17.0),
                        ],
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                        Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: SvgPicture.asset('assets/icons/test.svg', height:80,),
                        ),
                        Flexible(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                
                                    Padding(
                                        padding: EdgeInsets.only(top: 10, bottom: 10.0),
                                        child: Text(
                                            "${finca.nombreFinca}",
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: Theme.of(context).textTheme.headline6,
                                        ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only( bottom: 10.0),
                                        child: Text(
                                            "${parcela.nombreLote}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color: kLightBlackColor),
                                        ),
                                    ),
                                    
                                    Padding(
                                        padding: EdgeInsets.only( bottom: 10.0),
                                        child: Text(
                                            'Toma de datos: ${textPlaga.fechaTest}',
                                            style: TextStyle(color: kLightBlackColor),
                                        ),
                                    ),
                                ],  
                            ),
                        ),
                        
                        
                        
                    ],
                ),
        );
    }
   



}