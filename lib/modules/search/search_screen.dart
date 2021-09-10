import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/layout/cubit/cubit.dart';
import 'package:shopping_app/modules/search/cubit/cubit.dart';
import 'package:shopping_app/modules/search/cubit/states.dart';
import 'package:shopping_app/shared/components/BuildListProduct.dart';
import 'package:shopping_app/shared/components/DefaultTextForm.dart';
import 'package:shopping_app/shared/components/components.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var searchController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    DefaultFormField(
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      validate: (String value) {
                        if (value.isEmpty) {
                          return 'enter search text';
                        }
                        return null;
                      },
                      label: 'Search',
                      prefix: Icons.search,
                      onSubmit: (String text) {
                        SearchCubit.get(context).search(text);
                      },
                      searchFocus: true,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    if (state is SearchLoadingState) LinearProgressIndicator(),
                    SizedBox(
                      height: 10.0,
                    ),
                    if (state is SearchSuccessState)
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) => buildListProduct(
                            SearchCubit.get(context).model.data.data[index],
                            context,
                            isOldPrice: false,
                            textSent: searchController.text,
                          ),
                          separatorBuilder: (context, index) => myDivider(),
                          itemCount:
                              SearchCubit.get(context).model.data.data.length,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
