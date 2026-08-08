/// SRS FR-AUTH-08 password policy, shared so register/reset screens can't
/// drift out of sync with each other (they previously did — register only
/// checked length while reset checked the full rule set).
String? validatePassword(String? value) {
  if (value == null || value.length < 8) return 'Minimum 8 caractères';
  if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Au moins une majuscule';
  if (!RegExp(r'[0-9]').hasMatch(value)) return 'Au moins un chiffre';
  if (!RegExp(r'[!@#\$&*~%^()_\-+=]').hasMatch(value)) return 'Au moins un caractère spécial';
  return null;
}
