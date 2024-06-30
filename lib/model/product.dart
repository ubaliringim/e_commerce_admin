class Product {
  Product({
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
      this.id,
    this.qty = 0, // Default quantity is 0
  });

  final String name;
  final String category;
  final int price;
  final String description;
   String? id;
  final String imageUrl;
  int qty; // Add qty field

  factory Product.fromFirestore(Map<String, dynamic> firestoreData) {
    return Product(
      name: firestoreData['name'],
      category: firestoreData['category'],
      id: firestoreData['id'],
      price: firestoreData['price'],
      imageUrl: firestoreData['image_url'],
      description: firestoreData['description'],
      qty: firestoreData['qty'] ?? 0, // Initialize qty from Firestore, default is 0
    );
  }

    Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'id': id,
      'image_url': imageUrl,
      'qty': qty,
    };
  }
}