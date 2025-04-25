void main() {
  List<String> keys = ['uuid', 'name'];

  String keyQuery = keys.map((item) => "$item = ?").toList().join(" AND ");
  keyQuery += " AND ";
  print(keyQuery);
}
