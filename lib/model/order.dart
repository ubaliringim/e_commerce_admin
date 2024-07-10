import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_admin/model/product.dart';

class Order {
  final String userId;
  final String orderStatus;
  final Timestamp orderDate;
  final List<Product> products;
  final double totalAmount;

  Order({
    required this.userId,
    required this.orderStatus,
    required this.orderDate,
    required this.products,
    required this.totalAmount,
  });

  factory Order.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Order(
      userId: data['userid'],
      orderStatus: data['orderstatus'],
      orderDate: data['orderdate'],
      products: data['products'],
      totalAmount: data['totalamount'],
    );
  }
}
