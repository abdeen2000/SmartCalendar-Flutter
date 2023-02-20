import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _preferences;
  static const String Eventkey = "Event";
  static const String Eventdaykey = "Eventday";
  List<String> reminders = [];
  List<DateTime> _markedDate = [];
  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setEvent(String event) async =>
      await _preferences?.setString(Eventkey, event);

  static String? getEvent() => _preferences?.getString(Eventkey);

  static Future SetDate(dateOfEvent) async {
    final date = await dateOfEvent.toString();
    return await _preferences?.setString(Eventkey, date);
  }

  static DateTime getEventDay() {
    final date = _preferences?.getString(Eventkey);
    return date != null ? DateTime.parse(date) : DateTime.now();
  }

  static List getReminders() {
    return _preferences?.getStringList(Eventkey) ?? [];
  }

  static setReminders(List reminders) async {
    return await _preferences?.setStringList(
        Eventkey, reminders as List<String>);
  }

  static setMarkedDate(List<DateTime> markedDate) async {
    return await _preferences?.setStringList(
        Eventdaykey, markedDate as List<String>);
  }

  static getMarkedDate() {
    return _preferences?.getStringList(Eventdaykey) ?? [];
  }
}
