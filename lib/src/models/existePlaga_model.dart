class ExistePlaga {
    ExistePlaga({
        this.id,
        this.idPlaga,
        this.idPlanta,
        this.existe,
    });

    int id;
    int idPlaga;
    String idPlanta;
    int existe;

    factory ExistePlaga.fromJson(Map<String, dynamic> json) => ExistePlaga(
        id: json["id"],
        idPlaga: json["idPlaga"],
        idPlanta: json["idPlanta"],
        existe: json["existe"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idPlanta": idPlanta,
        "existe": existe,
    };
}