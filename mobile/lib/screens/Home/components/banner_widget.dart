import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:food_app/blocs/banner_bloc.dart';
import 'package:food_app/models/banner_model.dart';
import 'package:food_app/screens/Home/components/shimmer_banner.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:shimmer/shimmer.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({
    super.key,
  });

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final BannerBloc _bloc = BannerBloc();

  @override
  void initState() {
    _bloc.getBanner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.subject.stream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null) {
            if ((snapshot.data.banners as List).isEmpty) {
              return Container();
            } else {
              return _buildBanner(context, snapshot.data.banners);
            }
          }
          if ((snapshot.data.banners as List).isEmpty) {
            return Container();
          } else {
            return _buildBanner(context, snapshot.data.banners);
          }
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return _buildShimmerBanner();
        }
      },
    );
  }

  Stack _buildBanner(BuildContext context, List<BannerModel> banners) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(dimmension(20, context)),
          margin: EdgeInsets.symmetric(horizontal: dimmension(20, context)),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(dimmension(10, context)),
            gradient: LinearGradient(
              colors: [
                orangeColor.withOpacity(0.6),
                orangeColor.withOpacity(0.9),
                orangeColor.withOpacity(0.6),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          // child: Text(
          //   banners[0].content.replaceAll('\\n', '\n'),
          //   textAlign: TextAlign.right,
          //   style: Theme.of(context).textTheme.displayMedium,
          // ),
          child: Html(
            data: banners[0].content,
            style: {
              "p": Style(
                fontFamily: 'Dana',
                fontSize: FontSize(dimmension(15, context)),
                color: textColor,
                direction: TextDirection.rtl,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.right,
              ),
            },
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(left: dimmension(20, context)),
            child: Image.asset(
              "assets/images/pizza.png",
              height: dimmension(170, context),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildShimmerBanner() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: EdgeInsets.all(dimmension(20, context)),
        margin: EdgeInsets.symmetric(horizontal: dimmension(20, context)),
        width: MediaQuery.of(context).size.width,
        height: dimmension(120, context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(dimmension(10, context)),
          gradient: LinearGradient(
            colors: [
              orangeColor.withOpacity(0.6),
              orangeColor.withOpacity(0.9),
              orangeColor.withOpacity(0.6),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
      ),
    );
  }
}
