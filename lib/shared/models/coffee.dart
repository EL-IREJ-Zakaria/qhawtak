class CoffeeItem {
  const CoffeeItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.imagePath,
    this.isAvailable = true,
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final String? imagePath;
  final bool isAvailable;

  CoffeeItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    String? imageUrl,
    String? imagePath,
    bool? isAvailable,
  }) {
    return CoffeeItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      imagePath: imagePath ?? this.imagePath,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  factory CoffeeItem.fromJson(
    Map<String, dynamic> json, {
    required String apiRootUrl,
  }) {
    final String rawImage = (json['image'] ?? '').toString();
    final String itemName = (json['name'] ?? '').toString();
    return CoffeeItem(
      id: (json['id'] ?? '').toString(),
      name: itemName,
      description: (json['description'] ?? '').toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      category: (json['category'] ?? '').toString(),
      imageUrl: _buildDisplayImage(
        rawImage: rawImage,
        itemName: itemName,
        apiRootUrl: apiRootUrl,
      ),
      imagePath: rawImage,
      isAvailable: _parseAvailability(json['is_available']),
    );
  }

  Map<String, dynamic> toApiPayload() {
    return <String, dynamic>{
      'name': name.trim(),
      'description': description.trim(),
      'price': price,
      'category': category.trim(),
      'image': (imagePath ?? imageUrl).trim(),
      'is_available': isAvailable,
    };
  }

  static String _buildDisplayImage({
    required String rawImage,
    required String itemName,
    required String apiRootUrl,
  }) {
    if (rawImage.isEmpty) {
      return _fallbackImage(itemName);
    }

    final String resolvedUrl = rawImage.startsWith('http://') || rawImage.startsWith('https://')
        ? rawImage
        : Uri.parse(apiRootUrl).resolve(rawImage).toString();

    if (resolvedUrl.toLowerCase().endsWith('.svg')) {
      return _fallbackImage(itemName);
    }

    return resolvedUrl;
  }

  static String _fallbackImage(String name) {
    final String value = name.toLowerCase();
    if (value.contains('espresso')) {
      return 'https://images.unsplash.com/photo-1510707577719-ae7c14805e8c?auto=format&fit=crop&w=1200&q=80';
    }
    if (value.contains('latte')) {
      return 'https://images.unsplash.com/photo-1494314671902-399b18174975?auto=format&fit=crop&w=1200&q=80';
    }
    if (value.contains('cappuccino')) {
      return 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?auto=format&fit=crop&w=1200&q=80';
    }
    if (value.contains('sandwich') || value.contains('panini') || value.contains('wrap')) {
      return 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?auto=format&fit=crop&w=1200&q=80';
    }
    if (value.contains('cake') || value.contains('brownie') || value.contains('tiramisu')) {
      return 'https://images.unsplash.com/photo-1551024601-bec78aea704b?auto=format&fit=crop&w=1200&q=80';
    }
    return 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?auto=format&fit=crop&w=1200&q=80';
  }

  static bool _parseAvailability(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    final String normalized = (value ?? 'true').toString().toLowerCase().trim();
    return normalized != 'false' && normalized != '0';
  }
}
