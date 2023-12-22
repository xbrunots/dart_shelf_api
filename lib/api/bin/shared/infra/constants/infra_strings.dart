
class InfraStrings {
  static String selectCols(table) =>
      "SELECT column_name, data_type FROM information_schema.columns  where table_name ilike '$table'";
  static const  String separator = ":";
}
