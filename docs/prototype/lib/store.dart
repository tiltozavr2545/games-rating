// Widget tests use an in-memory store. Browser previews persist on this origin.
final _values = <String, String>{};
String? read(String key) => _values[key];
void write(String key, String value) => _values[key] = value;
void remove(String key) => _values.remove(key);
