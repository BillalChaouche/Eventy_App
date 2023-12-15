class SharedData {
  // Private constructor
  SharedData._privateConstructor();

  // Singleton instance
  static final SharedData _instance = SharedData._privateConstructor();

  // Getter to access the instance
  static SharedData get instance => _instance;

  // Your shared variable
  String sharedVariable = 'Organizer';
}
