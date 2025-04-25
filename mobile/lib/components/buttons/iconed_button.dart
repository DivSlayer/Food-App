import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';

class IconedButton extends StatelessWidget {
  const IconedButton({
    super.key,
    this.icon,
    required this.func,
    this.svg,
    required this.bgColor,
    this.title,
    this.fontColor,
    this.width,
    this.fontSize,
    this.iconSize,
    this.isLoading = false,
    this.innerWidget,
    this.borderRadius,
    this.gradient,
    this.mainAxisAlignment,
    this.fontFamily,
    this.fontWeight,
    this.loadingColor,
  });

  final IconData? icon;
  final String? svg;
  final String? fontFamily;
  final VoidCallback func;
  final Color bgColor;
  final Color? fontColor;
  final String? title;
  final Widget? innerWidget;
  final double? width;
  final double? fontSize, iconSize;
  final bool isLoading;
  final LinearGradient? gradient;
  final BorderRadius? borderRadius;
  final MainAxisAlignment? mainAxisAlignment;
  final FontWeight? fontWeight;
  final Color? loadingColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? () {} : func,
      child: Container(
        width: width ?? MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(
          vertical: dimmension(15, context),
        ),
        decoration: BoxDecoration(
            gradient: gradient,
            color: bgColor,
            borderRadius: borderRadius ?? BorderRadius.circular(dimmension(15, context)),
            boxShadow: [
              BoxShadow(
                offset: const Offset(5, 5),
                color: borderColor.withOpacity(0.5),
                blurRadius: dimmension(10, context),
              ),
            ],
            border: Border.all(
              color: borderColor.withOpacity(0.3),
            )),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: dimmension(20, context)),
            child: !isLoading
                ? innerWidget == null
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          icon != null
                              ? Icon(
                                  icon,
                                  color: fontColor ?? textColor,
                                  size: iconSize ?? dimmension(30, context),
                                )
                              : Container(),
                          svg != null
                              ? SvgPicture.asset(
                                  svg ?? '',
                                  height: iconSize ?? dimmension(25, context),
                                  color: fontColor ?? textColor,
                                )
                              : Container(),
                          title != null
                              ? Container(
                                  margin: EdgeInsets.only(left: dimmension(15, context)),
                                  child: Text(
                                    title ?? '',
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: fontSize ?? dimmension(18, context),
                                      fontWeight: fontWeight ?? FontWeight.w600,
                                      color: fontColor ?? Colors.white,
                                      fontFamily: fontFamily ?? 'Vazir',
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      )
                    : Center(
                        child: Container(
                          child: innerWidget ??
                              Container(
                                width: dimmension(0, context),
                              ),
                        ),
                      )
                : SizedBox(
                    width: dimmension(20, context),
                    height: dimmension(20, context),
                    child: CircularProgressIndicator(
                      color: loadingColor ?? Colors.white,
                      strokeCap: StrokeCap.round,
                      strokeWidth: dimmension(4, context),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// !isLoading
// ? icon != null
// ? Icon(
// icon,
// color: fontColor ?? textColor,
// size: iconSize ?? dimmension(30, context),
// )
//     : SvgPicture.asset(
// svg ?? '',
// height: iconSize ?? dimmension(25, context),
// color: fontColor ?? textColor,
// )
//     : Container(),
// isLoading
// ? Center(
// child: SizedBox(
// width: dimmension(20, context),
// height: dimmension(20, context),
// child: CircularProgressIndicator(
// color: const Color(0xffffffff),
// strokeWidth: dimmension(4, context),
// ),
// ),
// ),
// ? title != null
// ? Container(
// margin: EdgeInsets.only(left: dimmension(15, context)),
// child: Text(
// title ?? '',
// maxLines: 1,
// style: TextStyle(
// fontSize: fontSize ?? dimmension(18, context),
// fontWeight: FontWeight.w600,
// color: fontColor ?? textColor,
// ),
// ),
// )
//     : Container(
// width: dimmension(0, context),
// )
