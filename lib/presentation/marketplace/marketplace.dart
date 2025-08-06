import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_tabs_widget.dart';
import './widgets/featured_items_carousel_widget.dart';
import './widgets/marketplace_header_widget.dart';
import './widgets/product_grid_widget.dart';
import './widgets/search_filter_widget.dart';

class Marketplace extends StatefulWidget {
  const Marketplace({Key? key}) : super(key: key);

  @override
  State<Marketplace> createState() => _MarketplaceState();
}

class _MarketplaceState extends State<Marketplace>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // User data
  int _coinBalance = 2847;
  int _cartItemCount = 0;

  // Category and filter state
  String _selectedCategory = 'Digital Content';
  String _searchQuery = '';
  bool _showFilters = false;

  // Mock marketplace data
  final List<String> _categories = [
    'Digital Content',
    'Productivity Tools',
    'Entertainment',
    'Wellness',
  ];

  final List<Map<String, dynamic>> _featuredItems = [
    {
      'id': 'f1',
      'title': 'Premium Task Templates',
      'description': 'Professional task templates pack',
      'price': 150,
      'originalPrice': 200,
      'rarity': 'rare',
      'imageUrl':
          'https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=300',
      'timeRemaining': '2d 5h',
      'discount': 25,
    },
    {
      'id': 'f2',
      'title': 'Meditation Pack',
      'description': 'Guided meditation collection',
      'price': 100,
      'originalPrice': 120,
      'rarity': 'epic',
      'imageUrl':
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=300',
      'timeRemaining': '1d 12h',
      'discount': 17,
    },
  ];

  final Map<String, List<Map<String, dynamic>>> _products = {
    'Digital Content': [
      {
        'id': 'dc1',
        'title': 'E-book Collection',
        'description': 'Self-improvement books bundle',
        'price': 75,
        'rarity': 'common',
        'imageUrl':
            'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=300',
        'category': 'Digital Content',
        'inStock': true,
      },
      {
        'id': 'dc2',
        'title': 'Video Course Access',
        'description': 'Premium productivity course',
        'price': 200,
        'rarity': 'rare',
        'imageUrl':
            'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=300',
        'category': 'Digital Content',
        'inStock': true,
      },
    ],
    'Productivity Tools': [
      {
        'id': 'pt1',
        'title': 'Premium Planner',
        'description': 'Digital planning templates',
        'price': 50,
        'rarity': 'common',
        'imageUrl':
            'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=300',
        'category': 'Productivity Tools',
        'inStock': true,
      },
      {
        'id': 'pt2',
        'title': 'Focus Timer Pro',
        'description': 'Advanced focus management tool',
        'price': 125,
        'rarity': 'rare',
        'imageUrl':
            'https://images.unsplash.com/photo-1434626881859-194d67b2b86f?w=300',
        'category': 'Productivity Tools',
        'inStock': true,
      },
    ],
    'Entertainment': [
      {
        'id': 'ent1',
        'title': 'Music Streaming',
        'description': '3-month premium access',
        'price': 90,
        'rarity': 'common',
        'imageUrl':
            'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300',
        'category': 'Entertainment',
        'inStock': true,
      },
    ],
    'Wellness': [
      {
        'id': 'wel1',
        'title': 'Fitness App Premium',
        'description': 'Personal trainer access',
        'price': 180,
        'rarity': 'epic',
        'imageUrl':
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300',
        'category': 'Wellness',
        'inStock': true,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
  }

  Future<void> _refreshMarketplace() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Refresh marketplace data
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'refresh',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            const Text('Marketplace refreshed'),
          ],
        ),
        backgroundColor: AppTheme.secondaryLight,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
  }

  void _onProductTap(Map<String, dynamic> product) {
    _showProductDetail(product);
  }

  void _showProductDetail(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline.withAlpha(77),
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            // Product detail content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product image
                    Container(
                      height: 25.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(product['imageUrl']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Product title and rarity
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product['title'],
                            style: GoogleFonts.inter(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: _getRarityColor(product['rarity'])
                                .withAlpha(26),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: _getRarityColor(product['rarity'])),
                          ),
                          child: Text(
                            product['rarity'].toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: _getRarityColor(product['rarity']),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Description
                    Text(
                      product['description'],
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withAlpha(179),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Price and buy button
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700).withAlpha(26),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'coin',
                                color: const Color(0xFFFFD700),
                                size: 20,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                '${product['price']}',
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFFFD700),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () => _purchaseProduct(product),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.lightTheme.primaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 2.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Buy Now',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _purchaseProduct(Map<String, dynamic> product) {
    final int price = product['price'];

    if (_coinBalance >= price) {
      setState(() {
        _coinBalance -= price;
      });

      Navigator.pop(context);

      // Show success animation
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: Colors.green,
                size: 60,
              ),
              SizedBox(height: 2.h),
              Text(
                'Purchase Successful!',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'You have successfully purchased ${product['title']}',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color:
                      AppTheme.lightTheme.colorScheme.onSurface.withAlpha(179),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Continue Shopping',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Insufficient coins! Complete more tasks to earn coins.'),
          backgroundColor: AppTheme.errorLight,
        ),
      );
    }
  }

  Color _getRarityColor(String rarity) {
    switch (rarity) {
      case 'common':
        return Colors.grey;
      case 'rare':
        return Colors.blue;
      case 'epic':
        return Colors.purple;
      case 'legendary':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  List<Map<String, dynamic>> _getFilteredProducts() {
    List<Map<String, dynamic>> products = _products[_selectedCategory] ?? [];

    if (_searchQuery.isNotEmpty) {
      products = products
          .where((product) =>
              product['title']
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              product['description']
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refreshMarketplace,
          color: AppTheme.lightTheme.primaryColor,
          child: CustomScrollView(
            slivers: [
              // Header with coin balance
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: MarketplaceHeaderWidget(
                    coinBalance: _coinBalance,
                    cartItemCount: _cartItemCount,
                  ),
                ),
              ),

              // Search and filters
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: SearchFilterWidget(
                    searchQuery: _searchQuery,
                    onSearchChanged: _onSearchChanged,
                    showFilters: _showFilters,
                    onToggleFilters: _toggleFilters,
                  ),
                ),
              ),

              // Featured items carousel
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  child: FeaturedItemsCarouselWidget(
                    featuredItems: _featuredItems,
                    onItemTap: _onProductTap,
                  ),
                ),
              ),

              // Category tabs
              SliverToBoxAdapter(
                child: CategoryTabsWidget(
                  categories: _categories,
                  selectedCategory: _selectedCategory,
                  onCategoryChanged: _onCategoryChanged,
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 2.h)),

              // Product grid
              SliverToBoxAdapter(
                child: ProductGridWidget(
                  products: _getFilteredProducts(),
                  onProductTap: _onProductTap,
                ),
              ),

              // Bottom padding
              SliverToBoxAdapter(child: SizedBox(height: 10.h)),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3, // Shop tab active
        selectedItemColor: AppTheme.lightTheme.primaryColor,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'task_alt',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'trending_up',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'store',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.dashboardHome,
                (route) => false,
              );
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.taskManagement);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.progressVisualization);
              break;
            case 3:
              // Already on marketplace
              break;
            case 4:
              Navigator.pushNamed(context, AppRoutes.userProfile);
              break;
          }
        },
      ),
    );
  }
}
