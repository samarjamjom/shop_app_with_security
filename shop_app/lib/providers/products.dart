import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
    /*  Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ), */
  ];

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items]; //copy of items , not the referance
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchProducts(bool filterByUser) async {
    String filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' :'';
    print(filterByUser);
    var url =
        'https://prefab-glazing-330207-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken&$filterString';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body)as Map<String, dynamic>; //String:id, dynamic:Product Obj
      if (extractedData == null) {
        return;
      }

      //favorites
      url =
          'https://prefab-glazing-330207-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProducts = [];

      extractedData.forEach((prodId, product) {
        loadedProducts.add(Product(
            id: prodId,
            title: product['title'],
            description: product['description'],
            price: product['price'],
            imageUrl: product['imageUrl'],
            isFavorite: favoriteData == null ? false : favoriteData[prodId] ?? false,
            ));
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://prefab-glazing-330207-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorId': userId,
        }),
      );

      _items.add(Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      ));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> editProduct(id, Product newProduct) async {
    final prodIndex = _items.indexWhere((item) => item.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://prefab-glazing-330207-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            'isFavorite': newProduct.isFavorite,
          }));

      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("...");
    }
  }

  Future<void> deletProduct(String id) async {
    final url =
        'https://prefab-glazing-330207-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken';

    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[prodIndex];
    _items.removeAt(prodIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(prodIndex, existingProduct);
      notifyListeners();
      throw HttpException('could not delete product');
    }
  }
}
