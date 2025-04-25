import 'package:flutter/material.dart';
import 'package:food_app/blocs/search_bloc.dart';
import 'package:food_app/components/buttons/iconed_button.dart';
import 'package:food_app/components/custom_input.dart';
import 'package:food_app/components/forms/form_group.dart';
import 'package:food_app/models/search_model.dart';
import 'package:food_app/screens/Search/components/food_item.dart';
import 'package:food_app/screens/Search/components/restaurant_item.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/loading_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? inputError;
  final SearchBloc _bloc = SearchBloc();

  search(String query) {
    setState(() {
      firstInteract = false;
    });
    _bloc.search(query);
  }

  bool firstInteract = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: bgColor,
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: dimmension(20, context)),
            child: Column(
              children: [
                // SizedBox(height: dimmension(25, context)),
                Hero(
                  tag: 'search_input',
                  child: FormGroup(
                    error: inputError,
                    input: CustomInput(
                      placeholder: 'جستجو غذاها و رستوران ها',
                      suffixIcon: Icon(
                        Icons.search,
                        size: dimmension(30, context),
                        color: yellowColor,
                      ),
                      prefixIcon: Icon(
                        Icons.filter_list,
                        size: dimmension(25, context),
                        color: lightTextColor,
                      ),
                      onSubmitted: (String value) {
                        search(value);
                      },
                    ),
                    label: '',
                  ),
                ),
                SizedBox(height: dimmension(20, context)),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: lightBgColor,
                      borderRadius: BorderRadius.circular(dimmension(15, context)),
                    ),
                    child: firstInteract == false
                        ? StreamBuilder(
                            stream: _bloc.subject.stream,
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data.error != null) {
                                  if ((snapshot.data.objects as List).isEmpty) {
                                    return _buildNoItem(context);
                                  } else {
                                    return _buildListView(snapshot.data.objects);
                                  }
                                }
                                if ((snapshot.data.objects as List).isEmpty) {
                                  return _buildNoItem(context);
                                } else {
                                  return _buildListView(snapshot.data.objects);
                                }
                              } else if (snapshot.hasError) {
                                return _buildNoItem(context);
                              } else {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    LoadingWidget(
                                      size: dimmension(30, context),
                                      loadColor: yellowColor,
                                    ),
                                  ],
                                );
                              }
                            })
                        : Container(),
                  ),
                ),
                SizedBox(height: dimmension(20, context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoItem(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            'آیتمی یافت نشد!',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: lightTextColor,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildListView(List<SearchModel> objects) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dimmension(15, context)),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: dimmension(15, context)),
        itemCount: objects.length,
        itemBuilder: (context, index) => objects[index].food != null
            ? FoodSearchItem(food: objects[index].food!,)
            : RestaurantSearchItem(
                restaurant: objects[index].restaurant!,
              ),
      ),
    );
  }
}
