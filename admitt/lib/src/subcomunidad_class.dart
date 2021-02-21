class SubComunidad {
  String idSubComunidad;
  String nombreSubComunidad;
  String descripcionSubComunidad;
  String idComunidad;
  List<SubComunidad> subcomunidades = [];
  SubComunidad(this.idSubComunidad, this.nombreSubComunidad,
      this.descripcionSubComunidad, this.idComunidad,
      {this.subcomunidades});
}
