import 'package:flutter/material.dart';
import 'package:food_app/blocs/comment_bloc.dart';
import 'package:food_app/components/buttons/iconed_button.dart';
import 'package:food_app/components/forms/form_group.dart';
import 'package:food_app/components/forms/input.dart';
import 'package:food_app/components/separator.dart';
import 'package:food_app/main.dart';
import 'package:food_app/models/account.dart';
import 'package:food_app/models/comment.dart';
import 'package:food_app/models/token_model.dart';
import 'package:food_app/refresh_indicators/checkmark_indicator.dart';
import 'package:food_app/resource/server_resource.dart';
import 'package:food_app/screens/Comment/components/rating_widget.dart';
import 'package:food_app/services/account_service.dart';
import 'package:food_app/services/db.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/funcs.dart';
import 'package:food_app/utils/loading_widget.dart';
import 'package:food_app/utils/snack.dart';
import 'package:get/get.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => CommentScreenState();
}

class CommentScreenState extends State<CommentScreen> {
  String commentFor = Get.arguments['comment_for'];
  final CommentBloc _bloc = CommentBloc();

  void _showModalBottomSheet(BuildContext context) {
    TextEditingController commentMsgController = TextEditingController();
    String? titleError, contentError;
    bool sending = false;
    bool sent = false;
    double rating = 0.0;
    showModalBottomSheet(
      context: context,
      elevation: 0,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState2) {
            void clearForm() {
              setState2(() {
                commentMsgController.text = "";
              });
            }

            Future<void> addComment() async {
              print('adding comment');
              AccountService accountService = getAccountService();
              ServerResource serverResource = ServerResource();
              CommentModel comment = CommentModel(
                commentFrom: AccountShortInfo.fromJson(accountService.account!.toJson()),
                content: commentMsgController.text,
                publishedAt: DateTime.now(),
                rating: rating,
                replies: [],
                isVerified: false,
                uuid: '',
              );
              print(comment);
              setState2(() {
                sending = true;
              });
              serverResource.addComment(commentFor: commentFor, comment: comment).then((res) {
                setState2(() {
                  sending = false;
                });
                if (res.error == null && res.comments.isNotEmpty) {
                  showSnack('با موفقیت آپلود شد!', context, color: greenColor);
                  clearForm();
                  Future.delayed(const Duration(milliseconds: 1000), () {
                    Navigator.pop(context);
                    onRefresh();
                    setState2(() {
                      sent = true;
                    });
                  });
                } else {
                  showSnack('خطایی رخ داده است!', context, color: redColor);
                }
              });
            }

            void validate() {
              setState2(() {
                titleError = null;
                contentError = null;
              });
              if (commentMsgController.text.isNotEmpty) {
                addComment();
              }
              if (commentMsgController.text == "") {
                setState2(() {
                  contentError = "این فیلد اجباری است";
                });
              }
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.70,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(dimmension(20, context)),
                  topRight: Radius.circular(dimmension(20, context)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: dimmension(20, context),
                    ).copyWith(top: dimmension(20, context)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            size: dimmension(30, context),
                            color: textColor,
                          ),
                        ),
                        Text(
                          'ایجاد کامنت',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Container(width: dimmension(40, context)),
                      ],
                    ),
                  ),
                  Separator(marginSize: dimmension(20, context)),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            FormGroup(
                              label: 'پیام',
                              error: contentError,
                              input: CustomInput(
                                textAlign: TextAlign.right,
                                bgColor: bgColor,
                                collapsed: true,
                                controller: commentMsgController,
                                placeholder: 'عنوان آدرس را وارد کنید',
                                deactiveBorderColor: borderColor.withOpacity(0.7),
                                onChange: () {},
                              ),
                            ),
                            SizedBox(height: dimmension(20, context)),
                            RatingWidget(
                              rating: rating,
                              onRatingChanged: (count) {
                                setState2(() {
                                  rating = count;
                                });
                              },
                            ),
                            SizedBox(height: dimmension(30, context)),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: dimmension(20, context)),
                              child: IconedButton(
                                isLoading: sending,
                                loadingColor: yellowColor,
                                func: () async{
                                  DatabaseService _db = DatabaseService();
                                  TokenModel? token =await _db.getToken();
                                  print(token?.access);
                                  if (sent == false) {
                                    validate();
                                  }

                                },
                                bgColor: lightBgColor,
                                title: 'ثبت نظر',
                                fontColor: yellowColor,
                                fontSize: dimmension(16, context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _bloc.getComments(commentFor: commentFor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CheckMarkIndicator(
          onRefresh: () async{
            await onRefresh();
          },
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(right: dimmension(20, context)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.chevron_left_rounded, size: dimmension(25, context)),
                    ),
                    Text(
                      'نظرات',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(color: yellowColor),
                    ),
                  ],
                ),
              ),
              SizedBox(height: dimmension(20, context)),
              Expanded(
                child: StreamBuilder(
                  stream: _bloc.subject.stream,
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.error != null) {
                        if ((snapshot.data.comments as List).isEmpty) {
                          return _buildNoItem(context);
                        } else {
                          return _buildContent(context, snapshot.data.comments);
                        }
                      }
                      if ((snapshot.data.comments as List).isEmpty) {
                        return _buildNoItem(context);
                      } else {
                        return _buildContent(context, snapshot.data.comments);
                      }
                    } else if (snapshot.hasError) {
                      return _buildNoItem(context);
                    } else {
                      return _buildLoadingPage();
                    }
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: dimmension(20, context),
                  vertical: dimmension(20, context),
                ),
                child: IconedButton(
                  func: () {
                    _showModalBottomSheet(context);
                  },
                  bgColor: lightBgColor,
                  title: 'کامنت جدید',
                  icon: Icons.add_rounded,
                  fontColor: yellowColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<CommentModel> comments) {
    return ListView.builder(
      itemCount: comments.length,
      padding: EdgeInsets.symmetric(vertical: dimmension(10, context)),
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: dimmension(20, context),
          ).copyWith(bottom: dimmension(20, context)),
          padding: EdgeInsets.all(dimmension(15, context)),
          decoration: BoxDecoration(
            color: bgColor,
            boxShadow: [
              BoxShadow(
                color: borderColor.withOpacity(0.5),
                offset: const Offset(5, 5),
                blurRadius: dimmension(10, context),
              ),
            ],
            borderRadius: BorderRadius.circular(dimmension(10, context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.star_rounded, color: yellowColor, size: dimmension(20, context)),
                      SizedBox(width: dimmension(3, context)),
                      Text(
                        "${comments[index].rating}",
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          // color: textColor,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      Text(
                        "${comments[index].commentFrom.firstname} ${comments[index].commentFrom.lastname}",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      SizedBox(width: dimmension(5, context)),
                      Container(
                        padding: EdgeInsets.all(dimmension(5, context)),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: lightBgColor,
                        ),
                        child: Icon(Icons.person_outline_rounded, size: dimmension(16, context)),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: dimmension(10, context)),
              Text(
                comments[index].content,
                maxLines: 5,
                textDirection: TextDirection.rtl,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(height: dimmension(15, context)),
              SizedBox(
                width: double.infinity,
                child: Text(
                  convertToJalali(comments[index].publishedAt),
                  maxLines: 5,
                  textDirection: TextDirection.rtl,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: Theme.of(
                    context,
                  ).textTheme.displaySmall!.copyWith(fontSize: dimmension(12, context)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingPage() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: LoadingWidget(loadColor: yellowColor, size: dimmension(40, context))),
        ],
      ),
    );
  }

  Widget _buildNoItem(context) {
    return Center(
      child: Text(
        'کامنتی وجود ندارد است!',
        textDirection: TextDirection.rtl,
        style: Theme.of(
          context,
        ).textTheme.displayMedium!.copyWith(color: lightTextColor, fontWeight: FontWeight.w500),
      ),
    );
  }

  Future<void> onRefresh() {
    _bloc.getComments(commentFor: commentFor);
    return Future.delayed(const Duration(milliseconds: 1500));
  }
}
