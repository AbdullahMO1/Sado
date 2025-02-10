import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sado_ecommerce/provider/product_details_provider.dart';
import 'package:flutter_sado_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentSection extends StatelessWidget {
  final ProductDetailsProvider details;
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();

  CommentSection({Key? key, required this.details}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input field for adding a comment
        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: Icon(Icons.person, color: Colors.grey),
              ),
              SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: getTranslated('add_comment', context),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(Dimensions.paddingSizeDefault),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                onPressed: () {
                  String commentText = _commentController.text.trim();
                  if (commentText.isNotEmpty) {
                    try {
                      details.addComment(details.productId, commentText);
                      _commentController.clear();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add comment: $e')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Comment cannot be empty')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        // Displaying comments
        ListView.builder(
          itemCount: details.commentList?.length ?? 0,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final comment = details.commentList![index];
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault,
                  vertical: Dimensions.paddingSizeSmall),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          child: Icon(Icons.person, color: Colors.grey),
                        ),
                        SizedBox(width: Dimensions.paddingSizeSmall),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    comment.userName ?? 'Guest',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  Text(
                                    timeago.format(
                                        comment.createdAt ?? DateTime.now()),
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                              Text(
                                comment.comment ?? '',
                                style: TextStyle(color: Colors.black),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      comment.isLiked == true
                                          ? Icons.thumb_up
                                          : Icons.thumb_up_off_alt,
                                      color: comment.isLiked == true
                                          ? Colors.blue
                                          : Colors.grey,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      details.likeComment(comment.id);
                                      comment.isLiked =
                                          !(comment.isLiked ?? false);
                                      if (comment.isLiked == true) {
                                        comment.likeCount =
                                            (comment.likeCount ?? 0) + 1;
                                      } else {
                                        comment.likeCount =
                                            (comment.likeCount ?? 0) - 1;
                                      }
                                      details.notifyListeners();
                                    },
                                  ),
                                  Text(comment.likeCount.toString()),
                                  TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              '${getTranslated('Add_Reply', context)}',
                                            ),
                                            content: TextField(
                                              controller: _replyController,
                                              decoration: InputDecoration(
                                                hintText: getTranslated(
                                                    'enter_your_reply',
                                                    context),
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  '${getTranslated('CANCEL', context)}',
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  String replyText =
                                                      _replyController.text
                                                          .trim();
                                                  if (replyText.isNotEmpty) {
                                                    details.addReply(
                                                        comment.id, replyText);
                                                    _replyController.clear();
                                                    Navigator.of(context).pop();
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'Reply cannot be empty')),
                                                    );
                                                  }
                                                },
                                                child: Text(
                                                  '${getTranslated('Reply', context)}',
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      '${getTranslated('Reply', context)}',
                                    ),
                                  ),
                                  if (comment.isOwner ?? false)
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        details.deleteComment(comment.id);
                                      },
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // عرض الردود على التعليقات
                    if (comment.replies != null && comment.replies!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: ListView.builder(
                          itemCount: comment.replies!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, replyIndex) {
                            final reply = comment.replies![replyIndex];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.paddingSizeSmall),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey[200],
                                    child:
                                        Icon(Icons.person, color: Colors.grey),
                                  ),
                                  SizedBox(width: Dimensions.paddingSizeSmall),
                                  Expanded(
                                    // استخدام Expanded لحل مشكلة overflow
                                    child: Container(
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeSmall),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200], // خلفية للردود
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                // استخدام Flexible لتجنب overflow
                                                child: Text(
                                                  reply.userName ?? 'Guest',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                  overflow: TextOverflow
                                                      .ellipsis, // لمنع overflow النص الطويل
                                                ),
                                              ),
                                              Text(
                                                timeago.format(
                                                    reply.createdAt ??
                                                        DateTime.now()),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            reply.comment ?? '',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
