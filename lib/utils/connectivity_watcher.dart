// // utils/connectivity_watcher.dart
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import '../theme/app_theme.dart';
//
// /// Global connectivity watcher
// class ConnectivityWatcher extends StatefulWidget {
//   final Widget child;
//   const ConnectivityWatcher({super.key, required this.child});
//
//   @override
//   State<ConnectivityWatcher> createState() => _ConnectivityWatcherState();
// }
//
// class _ConnectivityWatcherState extends State<ConnectivityWatcher>
//     with SingleTickerProviderStateMixin {
//   late final StreamSubscription _connSub;
//   late final StreamSubscription _internetSub;
//
//   bool _isOffline = false;
//
//   late final AnimationController _anim;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Simple, quick entrance/exit
//     _anim = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 200),
//       reverseDuration: const Duration(milliseconds: 150),
//     );
//     _slide = Tween<Offset>(begin: const Offset(0, -0.25), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
//     _fade = CurvedAnimation(parent: _anim, curve: Curves.easeInOut);
//
//     // 1) Interface changes (wifi/mobile/off)
//     _connSub = Connectivity().onConnectivityChanged.listen((_) async {
//       final hasNet = await InternetConnectionChecker().hasConnection;
//       _handleStatus(hasNet);
//     });
//
//     // 2) True internet availability (DNS/ping)
//     _internetSub =
//         InternetConnectionChecker().onStatusChange.listen((status) {
//           final hasNet = status == InternetConnectionStatus.connected;
//           _handleStatus(hasNet);
//         });
//
//     // 3) Initial probe after first frame
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final has = await InternetConnectionChecker().hasConnection;
//       _handleStatus(has);
//     });
//   }
//
//   void _handleStatus(bool hasNet) {
//     if (!mounted) return;
//     final shouldBeOffline = !hasNet;
//     if (_isOffline == shouldBeOffline) return;
//
//     setState(() {
//       _isOffline = shouldBeOffline;
//     });
//
//     if (_isOffline) {
//       _anim.forward();
//     } else {
//       _anim.reverse();
//       // (Optional) show a short “Back online” toast using your alert_utils here.
//     }
//   }
//
//   @override
//   void dispose() {
//     _connSub.cancel();
//     _internetSub.cancel();
//     _anim.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         widget.child,
//
//         // Top banner
//         // Renders it always, but animate visibility—avoids layout jumps.
//         Positioned(
//           top: 0,
//           left: 0,
//           right: 0,
//           child: IgnorePointer(
//             ignoring: !_isOffline, // clicks pass through when hidden
//             child: SafeArea(
//               bottom: false,
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: SlideTransition(
//                   position: _slide,
//                   child: FadeTransition(
//                     opacity: _fade,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 10,
//                       ),
//                       decoration: BoxDecoration(
//                         color: AppTheme.alertError, // Ecobank error red
//                         borderRadius: BorderRadius.circular(10),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.12),
//                             blurRadius: 10,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: const Row(
//                         children: [
//                           Icon(Icons.wifi_off, color: Colors.white, size: 18),
//                           SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               'You are offline. Some actions may not work.',
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontFamily: 'Gilroy',
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w700,
//                                 height: 1.22,
//                                 decoration: TextDecoration.none,// compact, elegant
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
