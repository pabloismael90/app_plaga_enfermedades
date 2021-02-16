import 'package:app_plaga_enfermedades/src/bloc/fincas_bloc.dart';
import 'package:app_plaga_enfermedades/src/models/finca_model.dart';
import 'package:app_plaga_enfermedades/src/utils/constants.dart';
import 'package:app_plaga_enfermedades/src/utils/widget/card_list.dart';
import 'package:flutter/material.dart';



class FincasPage extends StatefulWidget {
    @override
    _FincasPageState createState() => _FincasPageState();
}

final fincasBloc = new FincasBloc();

class _FincasPageState extends State<FincasPage> {



    @override
    Widget build(BuildContext context) {
        var size = MediaQuery.of(context).size;
        fincasBloc.obtenerFincas();
        return Scaffold(
            appBar: AppBar(
                
            ),
            body: StreamBuilder<List<Finca>>(
                stream: fincasBloc.fincaStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());

                    }

                    final fincas = snapshot.data;
                    if (fincas.length == 0) {
                        Center(child: Text('No hay datos'),);
                    }
                    
                    return Column(
                        children: [
                            Container(
                                child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Column(
                                        children: [
                                        
                                            Text(
                                                "Listas de Fincas",
                                                style: Theme.of(context).textTheme
                                                    .headline5
                                                    .copyWith(fontWeight: FontWeight.w900, color: kRedColor)
                                            ),
                                        ],
                                    ),
                                )
                            ),
                            Expanded(child: SingleChildScrollView(
                                child: _listaDeFincas(snapshot.data, context, size),
                            ))
                            

                        ],
                    );
                },
            ),

            bottomNavigationBar: BottomAppBar(
                child: Container(
                    color: kBackgroundColor,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                        child: _addFinca(context)
                    ),
                ),
            ),
            
        );
        
       
    }

    Widget _addFinca(BuildContext context){
    
        return RaisedButton.icon(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.0),
            ),
            color: Colors.deepPurple,
            icon:Icon(Icons.add_circle_outline_outlined),
            textColor: Colors.white,
            label: Text('Nueva finca'),
            padding:EdgeInsets.all(10),
            onPressed:() => Navigator.pushNamed(context, 'addFinca'),
        );
    }

    Widget  _listaDeFincas(List fincas, BuildContext context, Size size){


        // return GridView.builder(
        //     itemCount: fincas.length,
        //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //         crossAxisCount: 2,
        //         childAspectRatio: 1.5,
        //         crossAxisSpacing: 20,
        //         mainAxisSpacing: 20,
        //     ),
        //     itemBuilder: (context, index){
        //         return Container(
        //             decoration: BoxDecoration(
        //             color: Colors.white,
        //             borderRadius: BorderRadius.circular(13),
        //                 boxShadow: [
        //                 BoxShadow(
        //                         color: Color(0xFF3A5160)
        //                             .withOpacity(0.05),
        //                         offset: const Offset(1.1, 1.1),
        //                         blurRadius: 17.0),
        //                 ],
        //             ),
        //             child: GestureDetector(
        //                 onTap: (){},
        //                 child: Padding(
        //                 padding: const EdgeInsets.all(10.0),
        //                     child: Column(
        //                         crossAxisAlignment: CrossAxisAlignment.start,
        //                         children: <Widget>[
                                    
        //                             SvgPicture.asset('assets/icons/finca.svg',
        //                                 height: 50.0,
        //                             ),
                                    
        //                             Text(
        //                                 fincas[index].nombreFinca,
        //                                 textAlign: TextAlign.center,
        //                                 style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.w500)
        //                             )
        //                         ],
        //                     ),
        //                 ),
        //             ),
        //         );
        //     },
        // );
        return ListView.builder(
            itemBuilder: (context, index) {
                return GestureDetector(
                    child: CardList(
                        size: size, 
                        finca: fincas[index],
                        icon:'assets/icons/finca.svg'
                    ),
                    onTap: () => Navigator.pushNamed(context, 'parcelas', arguments: fincas[index]),
                );
               
            },
            shrinkWrap: true,
            itemCount: fincas.length,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }
}

