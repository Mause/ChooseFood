class EnvironmentConfig {
  static const sentryDsn =
      String.fromEnvironment('SENTRY_DSN', defaultValue: 'https://...');
  static const googleApiKey = String.fromEnvironment("GOOGLE_API_KEY");
}
