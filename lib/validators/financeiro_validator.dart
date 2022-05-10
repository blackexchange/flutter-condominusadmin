class FinanceiroValidator {
  String? validateTitle(String? text) {
    if (text!.isEmpty) return "Campo obrigatório";
    return null;
  }

  String? validateValue(String? text) {
    if (text!.isEmpty) return "Campo obrigatório";
    return null;
  }
}
