class Planta {
    Planta({
        this.id,
        this.idPlaga,
        this.estacion,
        this.monilia,
        this.mazorcaNegra,
        this.malDeMachete,
        this.ardillaRata,
        this.barrenador,
        this.chupadores,
        this.zompopos,
        this.bejuco,
        this.tanda,
        this.deficiencia,
        this.produccion,
    });

    String id;
    String idPlaga;
    int estacion;
    int monilia;
    int mazorcaNegra;
    int malDeMachete;
    int ardillaRata;
    int barrenador;
    int chupadores;
    int zompopos;
    int bejuco;
    int tanda;
    int deficiencia;
    int produccion;

    factory Planta.fromJson(Map<String, dynamic> json) => Planta(
        id: json["id"],
        idPlaga: json["idPlaga"],
        estacion: json["estacion"],
        monilia: json["monilia"],
        mazorcaNegra: json["mazorcaNegra"],
        malDeMachete: json["malDeMachete"],
        ardillaRata: json["ardillaRata"],
        barrenador: json["barrenador"],
        chupadores: json["chupadores"],
        zompopos: json["zompopos"],
        bejuco: json["bejuco"],
        tanda: json["tanda"],
        deficiencia: json["deficiencia"],
        produccion: json["produccion"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idPlaga": idPlaga,
        "estacion": estacion,
        "monilia": monilia,
        "mazorcaNegra": mazorcaNegra,
        "malDeMachete": malDeMachete,
        "ardillaRata": ardillaRata,
        "barrenador": barrenador,
        "chupadores": chupadores,
        "zompopos": zompopos,
        "bejuco": bejuco,
        "tanda": tanda,
        "deficiencia": deficiencia,
        "produccion": produccion,
    };
}
