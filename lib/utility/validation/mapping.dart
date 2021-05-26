class Mapping {
  static Map<String, double> getMap(Map map) {
    if (null != map) {
      Map<String, double> unitMap = new Map<String, double>();
      for (MapEntry entry in map.entries) {
        unitMap.putIfAbsent(entry.key.toString(), () => double.parse(entry.value.toString()));
      }
      return unitMap;
    } else {
      return null;
    }
  }
}