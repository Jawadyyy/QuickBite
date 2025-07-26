import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_item.dart';

class FirestoreService {
  final CollectionReference _menuCollection =
      FirebaseFirestore.instance.collection('menu');

  Stream<List<FoodItem>> streamMenuItems() {
    return _menuCollection.snapshots().handleError((error) {
      throw Exception('Failed to load menu: $error');
    }).map((snapshot) {
      return snapshot.docs.map((doc) => _documentToFoodItem(doc)).toList();
    });
  }

  Future<DocumentReference> addMenuItem(FoodItem item) async {
    try {
      return await _menuCollection.add({
        'name': item.name,
        'price': item.price,
        if (item.imageUrl != null) 'imageUrl': item.imageUrl,
        if (item.description != null) 'description': item.description,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add menu item: $e');
    }
  }

  Future<void> deleteMenuItem(String id) async {
    try {
      await _menuCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete menu item: $e');
    }
  }

  Future<void> updateMenuItem(FoodItem item) async {
    try {
      await _menuCollection.doc(item.id).update({
        'name': item.name,
        'price': item.price,
        if (item.imageUrl != null) 'imageUrl': item.imageUrl,
        if (item.description != null) 'description': item.description,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update menu item: $e');
    }
  }

  FoodItem _documentToFoodItem(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return FoodItem(
      id: doc.id,
      name: data['name']?.toString() ?? 'Unnamed Item',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl']?.toString(),
      description: data['description']?.toString(),
    );
  }
}
