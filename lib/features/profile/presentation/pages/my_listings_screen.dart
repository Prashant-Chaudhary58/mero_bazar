import 'package:flutter/material.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data based on the user's image
    final List<Map<String, String>> listings = [
      {
        "name": "Cabbage",
        "price": "Rs. 80/kg",
        "image": "assets/images/cabbage.jpg" 
      },
      {
        "name": "Mango",
        "price": "Rs. 120/kg",
        "image": "assets/images/mango.jpg"
      },
      {
        "name": "Brinjal",
        "price": "Rs. 40/kg",
        "image": "assets/images/brinjal.jpg"
      },
      {
        "name": "Maize",
        "price": "Rs. 10/piece",
        "image": "assets/images/maize.jpg"
      },
       {
        "name": "Apple",
        "price": "Rs. 200/kg",
        "image": "assets/images/apple.jpg"
      },
       {
        "name": "Orange",
        "price": "Rs. 150/kg",
        "image": "assets/images/orange.jpg"
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "My Listing",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: listings.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75, // Adjust based on card height
          ),
          itemBuilder: (context, index) {
            final item = listings[index];
            return InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context, 
                  '/product-details', 
                  arguments: {
                    ...item,
                    'isEditable': true,
                  }
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Section
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        // Using a container with placeholder color if image fails or for existing assets
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey.shade200,
                          child: Image.asset(
                            item["name"] == "Cabbage" ? "assets/images/cabbage.png" : // Trying to match potential assets or fallback
                            "assets/images/logo.jpg", 
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                               return const Center(child: Icon(Icons.image, size: 40, color: Colors.grey));
                            },
                          ),
                        ),
                      ),
                    ),
                    
                    // Details Section
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item["name"]!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Icon(Icons.favorite_border, size: 20, color: Colors.green),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            item["price"]!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: 3, // Assuming profile is the last tab or this is just a standalone screen
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
           BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
