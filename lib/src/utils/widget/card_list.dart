import 'package:app_plaga_enfermedades/src/models/finca_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app_plaga_enfermedades/src/models/selectValue.dart' as selectMap;
import '../constants.dart';


class CardList extends StatelessWidget {
    final Size size;  
    final Finca finca;
    final String icon;
    
    const CardList({
        Key key,
        this.size,
        this.finca,
        this.icon

    }) : super(key: key);

    @override
    Widget build(BuildContext context) {

        
        String labelMedida;
        final item = selectMap.dimenciones().firstWhere((e) => e['value'] == '${finca.tipoMedida}');
        labelMedida  = item['label'];


        return Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            height: 150,
            child: Stack(
                children: <Widget>[
                    Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                            padding: EdgeInsets.only(
                                left: 24,
                                top: 24,
                                right: size.width * .35,
                            ),
                            
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(38.5),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                
                                Text(
                                    "${finca.nombreFinca}",
                                    style: Theme.of(context).textTheme.headline6,
                                ),
                                Text(
                                    "${finca.nombreProductor}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: kLightBlackColor),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(top: 10, bottom: 10.0),
                                    child: Row(
                                    children: <Widget>[
                                        Text(
                                            "${finca.areaFinca} $labelMedida",
                                            style: TextStyle(color: kLightBlackColor),
                                        ),
                                        
                                    ],
                                    ),
                                ),
                                ],
                            ),
                        ),
                    ),
                    Positioned(
                        right: 0,
                        top: 0,
                        child: SvgPicture.asset(icon, height: 100,),
                    ),
                ],
            ),
        );
    }
}

