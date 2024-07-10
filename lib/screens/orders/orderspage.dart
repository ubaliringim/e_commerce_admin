import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:e_commerce_admin/model/order.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<List<Order>> _futureOrders;

  @override
  void initState() {
    super.initState();
    _futureOrders = getAllOrders();
  }

  Future<List<Order>> getAllOrders() async {
    List<Order> allOrders = [];

    // Get all users
    QuerySnapshot usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    for (var userDoc in usersSnapshot.docs) {
      // Check if the orders collection exists for the user
      CollectionReference ordersCollection =
          userDoc.reference.collection('orders');
      QuerySnapshot ordersSnapshot = await ordersCollection.get();
      // Add each order to the list
      for (var orderDoc in ordersSnapshot.docs) {
        Order order = Order.fromFirestore(orderDoc);
        allOrders.add(order);
      }
    }
    return allOrders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      body: FutureBuilder<List<Order>>(
        future: _futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              
              child: Text('Error: ${snapshot.error}'),

            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found.'));
          } else {
            List<Order> orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                Order order = orders[index];
                return ListTile(
                  title: Text('Order ID: ${order.userId}'),
                  subtitle: Text(
                      'Status: ${order.orderStatus}\nDate: ${order.orderDate.toDate()}\nTotal Amount: ${order.totalAmount}'),
                  isThreeLine: true,
                );
              },
            );
          }
        },
      ),
    );
  }
}
