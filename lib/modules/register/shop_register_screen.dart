import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/layout/shop_layout.dart';
import 'package:shopping_app/modules/register/cubit/cubit.dart';
import 'package:shopping_app/modules/register/cubit/states.dart';
import 'package:shopping_app/shared/components/Button.dart';
import 'package:shopping_app/shared/components/DefaultTextForm.dart';
import 'package:shopping_app/shared/components/components.dart';
import 'package:shopping_app/shared/components/constants.dart';
import 'package:shopping_app/shared/components/navigate_and_replace.dart';
import 'package:shopping_app/shared/network/local/chache_helper.dart';

class ShopRegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state) {
          if (state is ShopRegisterSuccessState) {
            if (state.loginModel.status) {
              // print('yalaaaa${state.loginModel}');
              // print(state.loginModel.data.token);

              CacheHelper.saveData(
                key: 'token',
                value: state.loginModel.data.token,
              ).then((value) {
                token = state.loginModel.data.token;
                navigateAndFinish(
                  context,
                  ShopLayout(),
                );
              });

              showToast(
                  text: state.loginModel.message, state: ToastStates.SUCCESS);
            } else {
              print(state.loginModel.message);
              showToast(
                  text: state.loginModel.message, state: ToastStates.ERROR);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          'Register now to browse our hot offers',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        DefaultFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'please enter your name ';
                            }
                          },
                          label: 'Name',
                          prefix: Icons.person,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        DefaultFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'please enter your email ';
                            }
                          },
                          label: 'email',
                          prefix: Icons.person,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        DefaultFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          isPassword: ShopRegisterCubit.get(context).isPassword,
                          suffixIcon: ShopRegisterCubit.get(context).suffix,
                          suffixPressed: () {
                            ShopRegisterCubit.get(context)
                                .changePasswordVisibility();
                          },
                          onSubmit: (value) {
                            // if (formKey.currentState.validate()) {
                            //   ShopRegisterCubit.get(context).userLogin(
                            //     email: emailController.text,
                            //     password: passwordController.text,
                            //   );
                            // }
                          },
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'password is too short';
                            }
                          },
                          label: 'Password',
                          prefix: Icons.password,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        DefaultFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'phone is too short';
                            }
                          },
                          label: 'phone',
                          prefix: Icons.phone,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopRegisterLoadingState,
                          builder: (context) => Button(
                            function: () {
                              if (formKey.currentState.validate()) {
                                ShopRegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            text: 'register',
                            isUpper: true,
                          ),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text('Dont\'t have an account'),
                        //     DefaultTextButton(
                        //       function: () {
                        //         navigateTo(
                        //           context,
                        //           ShopRegisterScreen(),
                        //         );
                        //       },
                        //       text: Text('Register'),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
