// This design prototype targets browsers only.
import 'dart:html' as html;

String? read(String key) => html.window.localStorage['savemargin.demo.$key'];
void write(String key, String value) =>
    html.window.localStorage['savemargin.demo.$key'] = value;
void remove(String key) =>
    html.window.localStorage.remove('savemargin.demo.$key');
