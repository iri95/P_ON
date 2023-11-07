import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/common/fcm/fcm_manager.dart';
import 'package:p_on/common/theme/custom_theme_app.dart';
import 'package:p_on/route/transition/fade_transition_page.dart';
import 'package:p_on/screen/main/s_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:p_on/screen/main/tab/chat_room/f_chat_room.dart';
import 'package:p_on/screen/main/tab/chat_room/f_create_vote_room.dart';
import 'package:p_on/screen/main/tab/chat_room/f_select_vote.dart';
import 'package:p_on/screen/main/tab/promise_room/f_create_promise.dart';
import 'package:p_on/screen/main/tab/tab_item.dart';

import 'auth.dart';
import 'common/widget/w_round_button.dart';
import 'screen/main/tab/chat_room/w_header_text_vote.dart';
import 'screen/main/user/f_login.dart';

class App extends ConsumerStatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();

  static bool isForeground = true;

  const App({super.key});

  @override
  ConsumerState<App> createState() => AppState();
}

class AppState extends ConsumerState<App> with Nav, WidgetsBindingObserver {
  final ValueKey<String> _scaffoldKey = const ValueKey<String>('App scaffold');

  final _auth = PonAuth();
  
  @override
  void initState() {
    super.initState();
    FcmManager.requestPermission();
    FcmManager.initialize(ref);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: PonAuthScope(
        notifier: _auth,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: App.scaffoldMessengerKey,
          routerConfig: _router,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'Image Finder',
          theme: context.themeType.themeData,
        ),
      ),
    );
  }

  late final GoRouter _router = GoRouter(
    navigatorKey: App.navigatorKey,
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        redirect: (_, __) => '/main',
      ),
      GoRoute(
        path: '/signin',
        pageBuilder: (BuildContext context, GoRouterState state) => FadeTransitionPage(
          key: state.pageKey,
          child: LoginPage()
          // child: Container(
          //   color: Colors.green,
          //   child: Center(
          //     child: RoundButton(
          //       text: '로그인',
          //       onTap: () {
          //         _auth.signIn('hong', '1234');
          //       },
          //     ),
          //   ),
          // ),
        ),
      ),
      GoRoute(
        path: '/main',
        redirect: (_, __) => '/main/home',
      ),
      // GoRoute(
      //   path: '/productPost/:postId',
      //   redirect: (BuildContext context, GoRouterState state) =>
      //   '/main/home/${state.pathParameters['postId']}',
      // ),
      GoRoute(
        path: '/main/:kind(home|history|blankFeild|plan|my)',
        pageBuilder: (BuildContext context, GoRouterState state) => FadeTransitionPage(
          key: _scaffoldKey,
          child: MainScreen(
            firstTab: TabItem.find(state.pathParameters['kind']),
          ),
        ),
        // routes: <GoRoute>[
        //   GoRoute(
        //     path: ':postId',
        //     builder: (BuildContext context, GoRouterState state) {
        //       final String postId = state.pathParameters['postId']!;
        //       if (state.extra != null) {
        //         final post = state.extra as SimpleProductPost;
        //         return PostDetailScreen(
        //           int.parse(postId),
        //           simpleProductPost: post,
        //         );
        //       } else {
        //         return PostDetailScreen(int.parse(postId));
        //       }
        //     },
        //   ),
        // ],
      ),
      GoRoute(path: '/createpromise',
          builder: (BuildContext context, GoRouterState state){
        // 'state.extra' 로 'extra' 로 넘겨준 데이터 사용 한다.
           return const CreatePromise();
          }
      ),
      GoRoute(
        path: '/chatroom/:id',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final id = state.pathParameters['id'] ?? 'unknown';
          return MaterialPage(
            // key: ValueKey(id),
            child: ChatRoom(id: id),
          );
        }
      ),
      GoRoute(
          path: '/create/vote/:id/:voteType/:isUpdate',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final id = state.pathParameters['id'] ?? 'unknown';
            final voteTypeString = state.pathParameters['voteType'] ?? 'Date';
            final isUpdate = (state.pathParameters['isUpdate'] ?? 'false').toLowerCase() == 'true';
            final voteType = VoteType.values.firstWhere((e) => e.toString() == 'VoteType.$voteTypeString', orElse: () => VoteType.Date);
            return MaterialPage(
              child: CreateVoteRoom(id: id, voteType: voteType, isUpdate: isUpdate,),
            );
          }
      ),
      GoRoute(
        path: '/selecte/vote/:id',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final id = state.pathParameters['id'] ?? 'unknown';
          return MaterialPage(
            child: SelectVote(id: id));
        }
      )


    ],
    redirect: _auth.guard,
    refreshListenable: _auth,
    debugLogDiagnostics: true,
  );

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        App.isForeground = true;
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        App.isForeground = false;
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }
  @override
  GlobalKey<NavigatorState> get navigatorKey => App.navigatorKey;
}
