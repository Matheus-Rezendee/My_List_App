import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue.shade800, // Cor principal
        ),
        useMaterial3: true,
      ),
      home: const CategoryScreen(),
    );
  }
}

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Map<String, dynamic>> categories = [
    {"name": "Casa", "icon": Icons.home, "color": Colors.blue},
    {"name": "Material Escolar", "icon": Icons.school, "color": Colors.green},
    {"name": "Supermercado", "icon": Icons.shopping_cart, "color": Colors.orange},
    {"name": "Trabalho", "icon": Icons.work, "color": Colors.purple},
  ];

  void _addCategory(String name) {
    setState(() {
      categories.add({"name": name, "icon": Icons.category, "color": Colors.grey});
    });
  }

  void _showAddCategoryDialog(BuildContext context) {
    String categoryName = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Nova Categoria'),
          content: TextField(
            onChanged: (value) {
              categoryName = value;
            },
            decoration: const InputDecoration(hintText: "Nome da Categoria"),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () {
                if (categoryName.isNotEmpty) {
                  _addCategory(categoryName);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My List'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: categories.length + 1,
          itemBuilder: (context, index) {
            if (index == categories.length) {
              return CategoryCard(
                name: "Adicionar Categoria",
                icon: Icons.add,
                color: Colors.grey,
                onTap: () {
                  _showAddCategoryDialog(context);
                },
              );
            } else {
              final category = categories[index];
              return CategoryCard(
                name: category["name"],
                icon: category["icon"],
                color: category["color"],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemListScreen(categoryName: category["name"]),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const CategoryCard({
    required this.name,
    required this.icon,
    required this.color,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemListScreen extends StatefulWidget {
  final String categoryName;

  const ItemListScreen({required this.categoryName, super.key});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final List<Map<String, dynamic>> _items = [];
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void _addItem(String item, {String description = '', double price = 0.0, int quantity = 1}) {
    setState(() {
      _items.add({
        "title": item,
        "description": description,
        "price": price,
        "quantity": quantity,
        "completed": false,
        "total": price * quantity,
      });
    });
    _itemController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _quantityController.clear();
  }

  void _toggleItemCompletion(int index) {
    setState(() {
      _items[index]["completed"] = !_items[index]["completed"];
    });
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _showAddItemDialog(BuildContext context) {
    String itemName = '';
    String itemDescription = '';
    double itemPrice = 0.0;
    int itemQuantity = 1;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _itemController,
                onChanged: (value) {
                  itemName = value;
                },
                decoration: const InputDecoration(hintText: "Nome do Item"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                onChanged: (value) {
                  itemDescription = value;
                },
                decoration: const InputDecoration(hintText: "Descrição (opcional)"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  itemPrice = double.tryParse(value) ?? 0.0;
                },
                decoration: const InputDecoration(hintText: "Preço do Item"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  itemQuantity = int.tryParse(value) ?? 1;
                },
                decoration: const InputDecoration(hintText: "Quantidade"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () {
                if (itemName.isNotEmpty) {
                  _addItem(itemName, description: itemDescription, price: itemPrice, quantity: itemQuantity);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  double _getTotalValue() {
    double total = 0.0;
    for (var item in _items) {
      total += item["total"];
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _showAddItemDialog(context);
              },
              child: const Text('Adicionar Item'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        item["title"],
                        style: TextStyle(
                          fontSize: 16,
                          decoration: item["completed"] ? TextDecoration.lineThrough : TextDecoration.none,
                          color: item["completed"] ? Colors.grey : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                          "Preço: \$${item["price"]} | Quantidade: ${item["quantity"]} | Total: \$${item["total"]}"),
                      leading: Checkbox(
                        value: item["completed"],
                        onChanged: (value) {
                          _toggleItemCompletion(index);
                        },
                        activeColor: Colors.blue.shade800,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteItem(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Text(
              'Total Geral: \$${_getTotalValue().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
