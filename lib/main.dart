import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/layout/cubit/cubit.dart';
import 'package:shopping_app/layout/shop_layout.dart';
import 'package:shopping_app/modules/login/shop_login_screen.dart';
import 'package:shopping_app/modules/on_boarding/on_boarding_screen.dart';
import 'package:shopping_app/shared/bloc_observer.dart';
import 'package:shopping_app/shared/components/constants.dart';
import 'package:shopping_app/shared/network/local/chache_helper.dart';
import 'package:shopping_app/shared/network/remote/dio_helper.dart';
import 'package:shopping_app/shared/styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  await CacheHelper.init();
  DioHelper.init();

  Widget widget;

  // CacheHelper.removeData(
  //   key: 'token',
  // );

  bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  print(token);

  // starts at on boarding at the first start because there ain't no 'onBoarding' key saved in the SharedP
  //starts at login if there's a key and there's no token
  //starts at the layout right away if there's both
  //starting up in either (onBoarding login layout) feature disabled for testing

  if (onBoarding != null) {
    if (token != null)
      widget = ShopLayout();
    else
      widget = ShopLoginScreen();
  } else {
    widget = OnBoardingScreen();
  }

  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({
    this.startWidget,
  });
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShopCubit()
            ..getHomeData()
            ..getCategories()
            ..getFavorites()
            ..getUserData(),
        ),
      ],
      child: MaterialApp(
        theme: lightTheme,
        debugShowCheckedModeBanner: false,
        home: OnBoardingScreen(),
        // startWidget,
        //starting up in either (onBoarding login layout) feature disabled for testing
      ),
    );
  }
}
