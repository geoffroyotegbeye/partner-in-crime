import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FeaturedItemsCarouselWidget extends StatelessWidget {
  final List<Map<String, dynamic>> featuredItems;
  final Function(Map<String, dynamic>) onItemTap;

  const FeaturedItemsCarouselWidget({
    Key? key,
    required this.featuredItems,
    required this.onItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Featured Deals',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          height: 25.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: featuredItems.length,
            itemBuilder: (context, index) {
              final item = featuredItems[index];

              return GestureDetector(
                onTap: () => onItemTap(item),
                child: Container(
                  width: 75.w,
                  margin: EdgeInsets.only(right: 4.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.lightTheme.primaryColor,
                        AppTheme.lightTheme.primaryColor.withAlpha(204),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.primaryColor.withAlpha(77),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Background image
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: NetworkImage(item['imageUrl']),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withAlpha(77),
                                BlendMode.darken,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Gradient overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withAlpha(153),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Content
                      Positioned(
                        bottom: 4.w,
                        left: 4.w,
                        right: 4.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Discount badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.errorLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${item['discount']}% OFF',
                                style: GoogleFonts.inter(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            SizedBox(height: 1.h),

                            // Title
                            Text(
                              item['title'],
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),

                            SizedBox(height: 0.5.h),

                            // Description
                            Text(
                              item['description'],
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: Colors.white.withAlpha(230),
                              ),
                            ),

                            SizedBox(height: 1.h),

                            // Price and time remaining
                            Row(
                              children: [
                                // Price
                                Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'coin',
                                      color: const Color(0xFFFFD700),
                                      size: 16,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      '${item['price']}',
                                      style: GoogleFonts.inter(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFFFD700),
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      '${item['originalPrice']}',
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.white.withAlpha(179),
                                      ),
                                    ),
                                  ],
                                ),

                                const Spacer(),

                                // Time remaining
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(51),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'timer',
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        item['timeRemaining'],
                                        style: GoogleFonts.inter(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
      ],
    );
  }
}
