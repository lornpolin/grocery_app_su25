import '../models/category.dart';
import '../models/product.dart';

class MockData {
  static const List<Category> categories = [
    Category(id: 'c1', name: 'Fresh Fruits', iconAsset: 'assets/icons/fruits.png'),
    Category(id: 'c2', name: 'Vegetables', iconAsset: 'assets/icons/vegetables.png'),
    Category(id: 'c3', name: 'Dairy & Eggs', iconAsset: 'assets/icons/dairy.png'),
    Category(id: 'c4', name: 'Meat', iconAsset: 'assets/icons/meat.png'),
    Category(id: 'c5', name: 'Bakery', iconAsset: 'assets/icons/bakery.png'),
  ];

  static const List<Product> products = [
    Product(
      id: 'p1',
      name: 'Organic Bananas',
      description: 'Fresh organic bananas directly from the farm.',
      imageUrl: 'https://images.unsplash.com/photo-1603833665858-e61d17a86224?w=500&q=80',
      price: 4.99,
      unit: '1 kg',
      categoryId: 'c1',
      stockQuantity: 100,
    ),
    Product(
      id: 'p2',
      name: 'Red Apples',
      description: 'Sweet and crunchy red apples.',
      imageUrl: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6faa6?w=500&q=80',
      price: 3.50,
      originalPrice: 4.00,
      unit: '1 kg',
      categoryId: 'c1',
      stockQuantity: 50,
    ),
    Product(
      id: 'p3',
      name: 'Broccoli',
      description: 'Fresh green broccoli heads.',
      imageUrl: 'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?w=500&q=80',
      price: 2.99,
      unit: '500 g',
      categoryId: 'c2',
      stockQuantity: 40,
    ),
    Product(
      id: 'p4',
      name: 'Fresh Milk',
      description: 'Whole cow milk, rich in calcium.',
      imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=500&q=80',
      price: 1.99,
      unit: '1 L',
      categoryId: 'c3',
      stockQuantity: 200,
    ),
    Product(
      id: 'p5',
      name: 'Chicken Breast',
      description: 'Boneless, skinless chicken breast.',
      imageUrl: 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=500&q=80',
      price: 8.99,
      unit: '1 kg',
      categoryId: 'c4',
      stockQuantity: 30,
    ),
  ];
}
