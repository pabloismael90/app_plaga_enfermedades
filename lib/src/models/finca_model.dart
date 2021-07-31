class Finca {
    Finca({
        this.id,
        this.nombreFinca,
        this.nombreProductor,
        this.areaFinca,
        this.tipoMedida = 1,
        this.factorBaba = 5.0,
        this.factorSeco = 3.0,
        this.nombreTecnico = '',
    });

    String? id;
    String? nombreFinca;
    String? nombreProductor;
    double? areaFinca;
    int? tipoMedida;
    double? factorBaba;
    double? factorSeco;
    String? nombreTecnico;

    factory Finca.fromJson(Map<String, dynamic> json) => Finca(
        id: json["id"],
        nombreFinca: json["nombreFinca"],
        nombreProductor: json["nombreProductor"],
        areaFinca: json["areaFinca"].toDouble(),
        tipoMedida: json["tipoMedida"],
        factorBaba: json["factorBaba"].toDouble(),
        factorSeco: json["factorSeco"].toDouble(),
        nombreTecnico: json["nombreTecnico"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombreFinca": nombreFinca,
        "nombreProductor": nombreProductor,
        "areaFinca": areaFinca,
        "tipoMedida": tipoMedida,
        "factorBaba": factorBaba,
        "factorSeco": factorSeco,
        "nombreTecnico": nombreTecnico,
    };
}