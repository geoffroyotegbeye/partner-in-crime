import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userProfile;
  final VoidCallback onEditProfile;

  const ProfileHeaderWidget({
    Key? key,
    required this.userProfile,
    required this.onEditProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.primaryColor,
            AppTheme.lightTheme.primaryColor.withAlpha(204),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.primaryColor.withAlpha(77),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Profile Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 12.w,
                    backgroundImage: NetworkImage(userProfile['avatar']),
                    backgroundColor: Colors.white.withAlpha(51),
                  ),
                  // Level badge
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(1.5.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        '${userProfile['level']}',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(width: 4.w),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProfile['name'],
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      userProfile['email'],
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: Colors.white.withAlpha(230),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          color: Colors.white.withAlpha(230),
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          userProfile['location'],
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: Colors.white.withAlpha(230),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Edit Profile Button
              GestureDetector(
                onTap: onEditProfile,
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomIconWidget(
                    iconName: 'edit',
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // Level Progress and Coins
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level ${userProfile['level']} Progress',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: Colors.white.withAlpha(230),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      height: 1.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(77),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FractionallySizedBox(
                        widthFactor: userProfile['currentLevelProgress'],
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${(userProfile['currentLevelProgress'] * 100).toInt()}% to next level',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: Colors.white.withAlpha(204),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 6.w),

              // Total Coins
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withAlpha(77),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'coin',
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${userProfile['totalCoins']}',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Total Coins',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: Colors.white.withAlpha(230),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Bio
          if (userProfile['bio'] != null && userProfile['bio'].isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                userProfile['bio'],
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: Colors.white.withAlpha(230),
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
