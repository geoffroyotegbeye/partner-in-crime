import 'package:shared_preferences/shared_preferences.dart';

/// Service pour gérer les préférences utilisateur persistantes
class UserPreferencesService {
  static const String _keyFirstLaunch = 'first_launch';
  static const String _keyLastAppVersion = 'last_app_version';
  static const String _keyIsProfileComplete = 'is_profile_complete';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyMotiCoins = 'moti_coins';
  static const String _keyLastVisitedScreen = 'last_visited_screen';
  static const String _keyLastVisitDate = 'last_visit_date';
  static const String _keyWeeklyTaskRecord = 'weekly_task_record';
  static const String _keyRemainingTasks = 'remaining_tasks';

  /// Vérifie si c'est la première ouverture de l'application
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyFirstLaunch) ?? true;
  }

  /// Marque l'application comme déjà ouverte (plus de première ouverture)
  static Future<void> setAppOpened() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFirstLaunch, false);
  }

  /// Vérifie si l'application a été mise à jour depuis la dernière ouverture
  static Future<bool> hasAppBeenUpdated(String currentVersion) async {
    final prefs = await SharedPreferences.getInstance();
    final lastVersion = prefs.getString(_keyLastAppVersion) ?? '';
    
    if (lastVersion.isEmpty) {
      await prefs.setString(_keyLastAppVersion, currentVersion);
      return false;
    }
    
    if (lastVersion != currentVersion) {
      await prefs.setString(_keyLastAppVersion, currentVersion);
      return true;
    }
    
    return false;
  }

  /// Vérifie si le profil utilisateur est complet
  static Future<bool> isProfileComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsProfileComplete) ?? false;
  }

  /// Définit l'état de complétion du profil utilisateur
  static Future<void> setProfileComplete(bool isComplete) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsProfileComplete, isComplete);
  }

  /// Enregistre le nom de l'utilisateur
  static Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
  }

  /// Récupère le nom de l'utilisateur
  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName) ?? '';
  }

  /// Enregistre l'email de l'utilisateur
  static Future<void> setUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserEmail, email);
  }

  /// Récupère l'email de l'utilisateur
  static Future<String> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail) ?? '';
  }

  /// Enregistre le solde de MotiCoins de l'utilisateur
  static Future<void> setMotiCoins(int coins) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyMotiCoins, coins);
  }

  /// Récupère le solde de MotiCoins de l'utilisateur
  static Future<int> getMotiCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyMotiCoins) ?? 0;
  }

  /// Enregistre le dernier écran visité
  static Future<void> setLastVisitedScreen(String routeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastVisitedScreen, routeName);
  }

  /// Récupère le dernier écran visité
  static Future<String> getLastVisitedScreen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastVisitedScreen) ?? '';
  }

  /// Enregistre la date de la dernière visite
  static Future<void> setLastVisitDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastVisitDate, DateTime.now().toIso8601String());
  }

  /// Récupère la date de la dernière visite
  static Future<DateTime?> getLastVisitDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString(_keyLastVisitDate);
    if (dateStr == null) return null;
    
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  /// Enregistre le record hebdomadaire de tâches
  static Future<void> setWeeklyTaskRecord(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyWeeklyTaskRecord, count);
  }

  /// Récupère le record hebdomadaire de tâches
  static Future<int> getWeeklyTaskRecord() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyWeeklyTaskRecord) ?? 0;
  }

  /// Enregistre le nombre de tâches restantes
  static Future<void> setRemainingTasks(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyRemainingTasks, count);
  }

  /// Récupère le nombre de tâches restantes
  static Future<int> getRemainingTasks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyRemainingTasks) ?? 0;
  }

  /// Réinitialise toutes les préférences (utile pour la déconnexion)
  static Future<void> clearAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
