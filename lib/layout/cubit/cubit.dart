import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/layout/cubit/states.dart';
import 'package:shopping_app/models/categories_model.dart';
import 'package:shopping_app/models/change_favorites_model.dart';
import 'package:shopping_app/models/favorites_model.dart';
import 'package:shopping_app/models/home_model.dart';
import 'package:shopping_app/models/login_model.dart';
import 'package:shopping_app/modules/categories/categories_screen.dart';
import 'package:shopping_app/modules/favorites/favorites_screen.dart';
import 'package:shopping_app/modules/products/products_screen.dart';
import 'package:shopping_app/modules/settings/settings_screen.dart';
import 'package:shopping_app/shared/components/components.dart';
import 'package:shopping_app/shared/components/constants.dart';
import 'package:shopping_app/shared/network/end_points.dart';
import 'package:shopping_app/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottom(value) {
    currentIndex = value;
    emit(ShopChangeButtonNavState());
  }

  HomeModel homeModel;

  Map<int, bool> favorites = {};
  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(url: HOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      print(homeModel.data.banners);

      homeModel.data.products.forEach((element) {
        favorites.addAll({
          element.id: element.inFavorites,
        });
      });

      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print('error is${error.toString()}');
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel categoriesModel;

  void getCategories() {
    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      print(categoriesModel.data.data.toString());
      emit(ShopSuccessCategoriesDataState());
    }).catchError((onError) {
      print('error iaaass   ${onError.toString()}');
      emit(ShopErrorCategoriesDataState());
    });
  }

  ChangeFavoritesModel changeFavoritesModel;
  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId];
    emit(ShopSuccessChangeDataState());

    DioHelper.postData(
      url: FAVORITES,
      data: {'product_id': productId},
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      // print(value.data);

      if (!changeFavoritesModel.status) {
        favorites[productId] = !favorites[productId];
      } else {
        getFavorites();
      }

      emit(ShopSuccessChangeFavoritesDataState(changeFavoritesModel));
    }).catchError((onError) {
      favorites[productId] = !favorites[productId];

      emit(ShopErrorChangeFavoritesDataState());
    });
  }

  FavoritesModel favoritesModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());

    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      printFullText(value.data.toString());

      emit(ShopSuccessGetFavoritesState());
    }).catchError((onError) {
      print('error iaaass   ${onError.toString()}');
      emit(ShopErrorGetFavoritesState());
    });
  }

  ShopLoginModel userModel;
  void getUserData() {
    emit(ShopLoadingUserDataState());

    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      // printFullText(value.data.toString());
      // print(userModel.data.name);

      emit(ShopSuccessUserDataState(userModel));
    }).catchError((onError) {
      print('error iaaass   ${onError.toString()}');
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
    String name,
    String email,
    String phone,
  }) {
    emit(ShopLoadingUpdateUserState());

    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      // printFullText(value.data.toString());
      print(userModel.data.name);

      emit(ShopSuccessUpdateUserState(userModel));
    }).catchError((onError) {
      print('error iaaass   ${onError.toString()}');
      emit(ShopErrorUpdateUserState());
    });
  }
}
