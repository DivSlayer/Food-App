import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/blocs/category_list_bloc.dart';
import 'package:food_app/models/category.dart';
import 'package:food_app/models/token_model.dart';
import 'package:food_app/screens/Home/components/shimmer_categories_list.dart';
import 'package:food_app/services/db.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:get/get.dart';

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({
    super.key,
    required this.bloc,
  });

  final CategoryListBloc? bloc;

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  late CategoryListBloc _categoryListBloc;

  @override
  void initState() {
    super.initState();
    if (widget.bloc != null) {
      setState(() {
        _categoryListBloc = widget.bloc!;
      });
    } else {
      setState(() {
        _categoryListBloc = CategoryListBloc();
      });
    }
    _categoryListBloc.getCategories().then((response) {
      // print(response.categories);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _categoryListBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: ()async{
            DatabaseService _db = DatabaseService();
            TokenModel? token = await _db.getToken();
            print(token);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: dimmension(20, context),
            ),
            child: Text(
              "دسته بندی ها",
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
        ),
        SizedBox(height: dimmension(20, context)),
        SizedBox(
          height: dimmension(100, context),
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder(
            stream: _categoryListBloc.subject.stream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error != null) {
                  if ((snapshot.data.categories as List).isEmpty) {
                    return _buildNoItem(context);
                  } else {
                    return _buildListView(snapshot.data.categories);
                  }
                }
                if ((snapshot.data.categories as List).isEmpty) {
                  return _buildNoItem(context);
                } else {
                  return _buildListView(snapshot.data.categories);
                }
              } else if (snapshot.hasError) {
                return _buildNoItem(context);
              } else {
                return _buildShimmerList();
              }
            },
          ),
        ),
      ],
    );
  }

  ListView _buildListView(List<CategoryModel> cats) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      reverse: true,
      itemCount: cats.length,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(
          left: dimmension(20, context),
          right: index == 0 ? dimmension(20, context) : 0,
        ),
        child: GestureDetector(
          onTap: () => Get.toNamed('category', arguments: {
            'category': cats[index],
          }),
          child: Column(
            children: [
              Container(
                width: dimmension(70, context),
                height: dimmension(70, context),
                padding: EdgeInsets.all(dimmension(10, context)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(dimmension(10, context)),
                  color: lightBgColor,
                  border: Border.all(
                    color: yellowColor,
                    width: 0.8,
                  ),
                ),
                child: SvgPicture.asset(defaultCategories[index].icon),
              ),
              SizedBox(height: dimmension(10, context)),
              Text(
                defaultCategories[index].title,
                style: Theme.of(context).textTheme.displayMedium,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoItem(context) {
    return Center(
      child: Text(
        'دسته بندی وجود ندارد!',
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
              color: lightTextColor,
            ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return const ShimmerCategoriesList();
  }
}
