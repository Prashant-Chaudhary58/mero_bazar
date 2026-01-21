// class AppConfig {
//   static const String env = String.fromEnvironment('ENV', defaultValue: 'dev');

//   static String get baseUrl {
//     switch (env) {
//       case 'dev':
//         // For physical device + hotspot (change IP when needed)
//         return 'http://172.18.118.197:5001/api/v1';

//       case 'emulator':
//         // Android emulator → host machine localhost
//         return 'http://10.0.2.2:5001/api/v1';

//       case 'ios-sim':
//         // iOS simulator
//         return 'http://localhost:5001/api/v1';

//       // case 'prod':
//       //   return 'https://api.merobaazar.com/api/v1';

//       default:
//         return 'http://localhost:5001/api/v1';
//     }
//   }
// }
