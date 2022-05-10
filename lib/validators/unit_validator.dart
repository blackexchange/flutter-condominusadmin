class UnitValidator {
  String? validateTitle(String? text) {
    if (text!.isEmpty) return "Campo obrigatório";
    return null;
  }
}
