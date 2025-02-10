class CommentModel {
  int id;
  int productId;
  int customerId;
  String? comment;
  int? parentId;
  bool? isLiked;
  int? likeCount;
  String? userName;
  bool? isOwner; // تأكد من إضافة هذا السطر
  DateTime? createdAt;
  DateTime? updatedAt;
  List<ReplyModel>? replies;

  CommentModel({
    required this.id,
    required this.productId,
    required this.customerId,
    this.comment,
    this.parentId,
    this.isLiked,
    this.likeCount,
    this.userName,
    this.isOwner, // تأكد من إضافة هذا السطر

    this.createdAt,
    this.updatedAt,
    this.replies,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      productId: json['product_id'],
      customerId: json['customer_id'],
      comment: json['comment'],
      parentId: json['parent_id'],
      isLiked: json['is_liked'],
      likeCount: json['like_count'],
      userName: json['user_name'],
      isOwner: json['is_owner'], // تأكد من إضافة هذا السطر

      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      replies: json['replies'] != null
          ? (json['replies'] as List)
              .map((reply) => ReplyModel.fromJson(reply))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'customer_id': customerId,
      'comment': comment,
      'parent_id': parentId,
      'is_liked': isLiked,
      'like_count': likeCount,
      'user_name': userName,
      'is_owner': isOwner, // تأكد من إضافة هذا السطر

      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'replies': replies?.map((reply) => reply.toJson()).toList(),
    };
  }
}

class ReplyModel {
  int id;
  int productId;
  int customerId;
  String? comment;
  int? parentId;
  bool? isLiked;
  int? likeCount;
  String? userName;
  bool? isOwner; // أضف هذه الخاصية
  DateTime? createdAt;
  DateTime? updatedAt;

  ReplyModel({
    required this.id,
    required this.productId,
    required this.customerId,
    this.comment,
    this.parentId,
    this.isLiked,
    this.likeCount,
    this.userName,
    this.isOwner, // أضف هذه الخاصية هنا

    this.createdAt,
    this.updatedAt,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    return ReplyModel(
      id: json['id'],
      productId: json['product_id'],
      customerId: json['customer_id'],
      comment: json['comment'],
      parentId: json['parent_id'],
      isLiked: json['is_liked'],
      likeCount: json['like_count'],
      userName: json['user_name'],
      isOwner: json['is_owner'], // تأكد من قراءة هذه الخاصية من JSON

      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'customer_id': customerId,
      'comment': comment,
      'parent_id': parentId,
      'is_liked': isLiked,
      'like_count': likeCount,
      'user_name': userName,
      'is_owner': isOwner, // تأكد من تضمين هذه الخاصية عند التحويل إلى JSON

      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
