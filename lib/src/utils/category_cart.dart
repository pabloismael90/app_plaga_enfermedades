import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
    final String svgSrc;
    final String title;
    final Function press;
    const CategoryCard({
        Key key,
        this.svgSrc,
        this.title,
        this.press,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return ClipRRect(
        borderRadius: BorderRadius.circular(13),
            child: Container(
                // padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                        BoxShadow(
                        offset: Offset(0, 17),
                        blurRadius: 17,
                        spreadRadius: -23,
                        //color: kShadowColor,
                        ),
                    ],
                ),
                child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: press,
                        child: Padding(
                        padding: const EdgeInsets.all(20.0),
                            child: Column(
                                children: <Widget>[
                                    Spacer(),
                                    Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage("assets/images/cacao_bg.png"),
                                                fit: BoxFit.fitWidth
                                            )
                                        ),
                                    ),
                                    Spacer(),
                                    Text(
                                        title,
                                        textAlign: TextAlign.center,
                                        // style: Theme.of(context)
                                        //     .textTheme
                                        //     .title
                                        //     .copyWith(fontSize: 15),
                                    )
                                ],
                            ),
                        ),
                    ),
                ),
            ),
        );
    }
}