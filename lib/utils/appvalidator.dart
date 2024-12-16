class Appvalidator {
  
  String? validateEmail(value){
    if (value!.isEmpty) {
      return 'Isi Email';
    }
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Isi email yang valid';
    }
    return null;
  }

  String? validatePhoneNumber(value){
    if (value!.isEmpty) {
      return 'Isi Nomor Telepon';
    }

    if (value.length !=10) {
      return 'Isi 10 digit nomor';
    }
    return null;
  }

  String? validatePassword(value){
    if (value!.isEmpty) {
      return 'Isi Password';
    }
    return null;
  }

  String? validateUsername(value){
    if (value!.isEmpty) {
      return 'Isi Username';
    }
    return null;
  }

}