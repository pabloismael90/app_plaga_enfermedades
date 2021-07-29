import 'package:app_plaga_enfermedades/src/bloc/fincas_bloc.dart';
import 'package:app_plaga_enfermedades/src/models/testplaga_model.dart';
import 'package:app_plaga_enfermedades/src/providers/db_provider.dart';
import 'package:app_plaga_enfermedades/src/utils/widget/button.dart';
import 'package:app_plaga_enfermedades/src/utils/widget/dialogDelete.dart';
import 'package:app_plaga_enfermedades/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';


final fincasBloc = new FincasBloc();

class TestPage extends StatefulWidget {

    

  @override
  _TestPageState createState() => _TestPageState();
}


class _TestPageState extends State<TestPage> {

    
    Future _getdataFinca(Testplaga textPlaga) async{
        Finca? finca = await DBProvider.db.getFincaId(textPlaga.idFinca);
        Parcela? parcela = await DBProvider.db.getParcelaId(textPlaga.idLote);
        return [finca, parcela];
    }

    @override
    Widget build(BuildContext context) {
        var size = MediaQuery.of(context).size;
        fincasBloc.obtenerPlagas();

        return Scaffold(
                appBar: AppBar(title: Text('Selecciona Parcelas'),),
                body: StreamBuilder<List<Testplaga>>(
                    stream: fincasBloc.plagaStream,   
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());

                        }
                        List<Testplaga> textPlagas= snapshot.data;
                        return Column(
                            children: [
                                Expanded(
                                    child:
                                    textPlagas.length == 0
                                    ?
                                    textoListaVacio('Ingrese una toma de datos')
                                    :
                                    SingleChildScrollView(child: _listaDePlagas(textPlagas, size, context))
                                ),
                            ],
                        );
                    },
                ),
                bottomNavigationBar: botonesBottom(_addtest(context)),
        );
        
    }

    Widget _addtest(BuildContext context){
        return Row(
            children: [
                Spacer(),
                ButtonMainStyle(
                    title: 'Escoger parcelas',
                    icon: Icons.post_add,
                    press: () => Navigator.pushNamed(context, 'addTest'),
                ),
                Spacer()
            ],
        );
    }

    Widget  _listaDePlagas(List textPlagas, Size size, BuildContext context){
        return ListView.builder(
            itemBuilder: (context, index) {
                return Dismissible(
                    key: UniqueKey(),
                    child: GestureDetector(
                        child: FutureBuilder(
                            future: _getdataFinca(textPlagas[index]),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                    return Center(child: CircularProgressIndicator());
                                }
                                Finca finca = snapshot.data[0];
                                Parcela parcela = snapshot.data[1];

                                return _cardDesing(size, textPlagas[index], finca, parcela);
                            },
                        ),
                        onTap: () => Navigator.pushNamed(context, 'estaciones', arguments: textPlagas[index]),
                    ),
                    confirmDismiss: (direction) => confirmacionUser(direction, context),
                    direction: DismissDirection.endToStart,
                    background: backgroundTrash(context),
                    movementDuration: Duration(milliseconds: 500),
                    onDismissed: (direction) => fincasBloc.borrarTestPlaga(textPlagas[index].id),
                );
               
            },
            shrinkWrap: true,
            itemCount: textPlagas.length,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }

    Widget _cardDesing(Size size, Testplaga textPiso, Finca finca, Parcela parcela){
        
        return cardDefault(
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    encabezadoCard('${finca.nombreFinca}','${parcela.nombreLote}', 'assets/icons/test.svg'),
                    textoCardBody('Fecha: ${textPiso.fechaTest}'),
                    iconTap(' Tocar para completar datos')
                ],
            )
        );
    }




}