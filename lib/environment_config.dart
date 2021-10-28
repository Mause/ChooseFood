class EnvironmentConfig {
  static const sentryDsn =
      String.fromEnvironment('SENTRY_DSN', defaultValue: 'https://...');
}
