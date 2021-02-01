class Planta {
    Planta({
        this.id,
        this.idTest,
        this.estacion,
        this.deficiencia = 0,
        this.produccion = 0,
    });

    String id;
    String idTest;
    int estacion;
    int deficiencia;
    int produccion;

    factory Planta.fromJson(Map<String, dynamic> json) => Planta(
        id: json["id"],
        idTest: json["idTest"],
        estacion: json["estacion"],
        deficiencia: json["deficiencia"],
        produccion: json["produccion"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idTest": idTest,
        "estacion": estacion,
        "deficiencia": deficiencia,
        "produccion": produccion,
    };
}
