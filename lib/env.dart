class Env {
  static const APP_NAME = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Apate',
  );
  static const APP_SUFFIX = String.fromEnvironment('APP_SUFFIX');
}
