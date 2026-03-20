enum AppFlavor { development, production }

extension AppFlavorX on AppFlavor {
  bool get isDevelopment => this == AppFlavor.development;

  String get appTitle {
    switch (this) {
      case AppFlavor.development:
        return 'Future Solutions (Dev)';
      case AppFlavor.production:
        return 'Future Solutions';
    }
  }
}
