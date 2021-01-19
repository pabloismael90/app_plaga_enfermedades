import 'dart:convert';

Parcela parcelaFromJson(String str) => Parcela.fromJson(json.decode(str));

String parcelaToJson(Parcela data) => json.encode(data.toJson());

class Parcela {
    Parcela({
        this.id,
        this.idFinca,
        this.nombreLote = '',
        this.areaLote = 0.0,
        this.tipoMedida = 1,
    });

    String id;
    String idFinca;
    String nombreLote;
    double areaLote;
    int tipoMedida;

    factory Parcela.fromJson(Map<String, dynamic> json) => Parcela(
        id: json["id"],
        idFinca: json["idFinca"],
        nombreLote: json["nombreLote"],
        areaLote: json["areaLote"].toDouble(),
        tipoMedida: json["tipoMedida"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idFinca": idFinca,
        "nombreLote": nombreLote,
        "areaLote": areaLote,
        "tipoMedida": tipoMedida,
    };
} 