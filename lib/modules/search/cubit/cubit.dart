import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/models/search_model.dart';
import 'package:shopping_app/modules/search/cubit/states.dart';
import 'package:shopping_app/shared/components/constants.dart';
import 'package:shopping_app/shared/network/end_points.dart';
import 'package:shopping_app/shared/network/remote/dio_helper.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel model;

  void search(String text) {
    emit(SearchLoadingState());
    DioHelper.postData(
      token: token,
      url: SEARCH,
      data: {
        'text': text,
      },
    ).then((value) {
      model = SearchModel.fromJson(value.data);
      emit(SearchSuccessState());
    }).catchError(
      (onError) {
        print(onError.toString());
        emit(SearchErrorState());
      },
    );
  }
}
