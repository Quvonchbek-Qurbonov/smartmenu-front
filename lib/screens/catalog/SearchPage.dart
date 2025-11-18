import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/core/routes/route_names.dart';

class SearchPage extends StatefulWidget {
  final String searchType; // 'meal' or 'restaurant'
  final List<Map<String, dynamic>> searchData;

  const SearchPage({
    super.key,
    required this.searchType,
    required this.searchData,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _hasSearched = true;
      _searchResults = widget.searchData.where((item) {
        final name = item['name'].toString().toLowerCase();
        final searchQuery = query.toLowerCase();
        return name.contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMealSearch = widget.searchType == 'meal';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF131316),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: _performSearch,
            decoration: InputDecoration(
              hintText:
                  isMealSearch ? 'Search for meal' : 'Search for restaurants',
              hintStyle: const TextStyle(
                color: Color(0xFF9E9EA7),
                fontSize: 14,
                fontFamily: 'Outfit',
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Color(0xFF9E9EA7),
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
            ),
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Outfit',
            ),
          ),
        ),
      ),
      body: _buildBody(isMealSearch),
    );
  }

  Widget _buildBody(bool isMealSearch) {
    if (!_hasSearched) {
      return _buildEmptyState(isMealSearch);
    }

    if (_searchResults.isEmpty) {
      return _buildNoResultsState(isMealSearch);
    }

    return _buildSearchResults(isMealSearch);
  }

  Widget _buildEmptyState(bool isMealSearch) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F3FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isMealSearch ? Icons.restaurant_menu : Icons.storefront,
              size: 60,
              color: const Color(0xFF875BF7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isMealSearch ? 'Search meal' : 'Search',
            style: const TextStyle(
              color: Color(0xFF131316),
              fontSize: 20,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              isMealSearch
                  ? 'Type meal name and meal appear to view, also you can know about it'
                  : 'Search result based on already added restaurant list',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF9E9EA7),
                fontSize: 14,
                fontFamily: 'Outfit',
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(bool isMealSearch) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F3FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off,
              size: 60,
              color: Color(0xFF875BF7),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No results found',
            style: TextStyle(
              color: Color(0xFF131316),
              fontSize: 20,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Try searching for something else',
            style: TextStyle(
              color: Color(0xFF9E9EA7),
              fontSize: 14,
              fontFamily: 'Outfit',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(bool isMealSearch) {
    if (isMealSearch) {
      return _buildMealResults();
    } else {
      return _buildRestaurantResults();
    }
  }

  Widget _buildMealResults() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final meal = _searchResults[index];
        return _buildMealCard(meal);
      },
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal) {
    return InkWell(
      onTap: () {
        final categoryId = meal['categoryId'] ?? '';
        final mealId = meal['id'] ?? '';
        
        // Pop and return data to scroll to the specific meal
        Navigator.pop(context, {
          'categoryId': categoryId,
          'mealId': mealId,
          'scrollToMeal': true, // Flag to indicate we should scroll to this meal
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE5E5E5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Meal Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                meal['imageUrl'] ?? '',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: const Color(0xFFF9F9F9),
                    child: const Icon(
                      Icons.restaurant,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // Meal Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal['name'] ?? '',
                    style: const TextStyle(
                      color: Color(0xFF131316),
                      fontSize: 16,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meal['price'] ?? '',
                    style: const TextStyle(
                      color: Color(0xFF875BF7),
                      fontSize: 16,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow Icon
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF9E9EA7),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(Map<String, dynamic> restaurant) {
    return InkWell(
      onTap: () {
        // Navigate to restaurant detail
        context.pushNamed(RouteNames.menu, pathParameters: {
          'restaurantId': restaurant['id'],
          'restaurantName': restaurant['name'],
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFE5E5E5),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Image
            Container(
              width: 64,
              height: 64,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.80),
                ),
              ),
              child: Image.network(
                restaurant['imageUrl'] ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFF9F9F9),
                    child: const Icon(
                      Icons.restaurant,
                      color: Colors.grey,
                      size: 24,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            // Restaurant Info
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Name with Arrow
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          restaurant['name'] ?? '',
                          style: const TextStyle(
                            color: Color(0xFF131316),
                            fontSize: 18,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w500,
                            height: 1.40,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Color(0xFF9E9EA7),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Tags
                  if (restaurant['tags'] != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: (restaurant['tags'] as List<String>)
                          .take(2)
                          .map((tag) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF5F3FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              color: Color(0xFF875BF7),
                              fontSize: 14,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w500,
                              height: 1.40,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantResults() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final restaurant = _searchResults[index];
        return _buildRestaurantCard(restaurant);
      },
    );
  }
}