import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/models/login_model.dart';
import 'package:shopping_app/modules/register/cubit/states.dart';
import 'package:shopping_app/shared/network/end_points.dart';
import 'package:shopping_app/shared/network/remote/dio_helper.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  ShopLoginModel loginModel;

  void userRegister({
    String email,
    String password,
    String name,
    String phone,
  }) {
    emit(ShopRegisterLoadingState());
    DioHelper.postData(
      lang: 'en',
      url: REGISTER,
      data: {
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
      },
    ).then((value) {
      loginModel = ShopLoginModel.fromJson(value.data);

      // print(value.data);
      // print('hobaaaaa           ${loginModel.data}');
      // print(loginModel.message);

      emit(ShopRegisterSuccessState(loginModel));
    }).catchError((error) {
      emit(ShopRegisterErrorState(error.toString()));
      print(error.toString());
    });
  }

  IconData suffix = Icons.visibility;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off_outlined : Icons.visibility;
    emit(ShopRegisterChangePasswordVisibilityState());
  }
}
