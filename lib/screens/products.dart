import 'package:e_commerce_admin/model/product.dart';
import 'package:e_commerce_admin/screens/addproductpage.dart';
import 'package:e_commerce_admin/screens/editproduct.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  void deleteProduct(String id) {
    setState(() {
      db.collection("products").doc(id).delete().then(
            (doc) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Product deleted from database"),
              ),
            ),
            onError: (e) => print("Error updating document $e"),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No products found'));
          }
          final products = snapshot.data!.docs.map((doc) {
            return Product.fromFirestore(doc.data() as Map<String, dynamic>);
          }).toList();
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text(product.description),
                leading: Text('\$${product.price}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _navigateToEditProductPage(context, product);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        deleteProduct(product.id!);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddProductPage(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddProductPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProductPage()),
    );
  }

  void _navigateToEditProductPage(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProductPage(product: product)),
    );
  }
}
