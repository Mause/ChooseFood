class EnvironmentConfig {
  static const sentryDsn =
      String.fromEnvironment('SENTRY_DSN', defaultValue: 'https://...');
  static const googleApiKey = String.fromEnvironment("GOOGLE_API_KEY");

  static const String supabaseUrl = String.fromEnvironment("SUPABASE_URL");
  static const String supabaseKey = String.fromEnvironment("SUPABASE_KEY");
}
