class Planta {
    Planta({
        this.id,
        this.idTest,
        this.estacion,
        this.produccion = 0,
        this.sanas,
        this.enfermas,
        this.danadas,
    });

    String? id;
    String? idTest;
    int? estacion;
    int? produccion;
    int? sanas;
    int? enfermas;
    int? danadas;

    factory Planta.fromJson(Map<String, dynamic> json) => Planta(
        id: json["id"],
        idTest: json["idTest"],
        estacion: json["estacion"],
        produccion: json["produccion"],
        sanas: json["sanas"],
        enfermas: json["enfermas"],
        danadas: json["danadas"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idTest": idTest,
        "estacion": estacion,
        "produccion": produccion,
        "sanas": sanas,
        "enfermas": enfermas,
        "danadas": danadas,
    };
}
