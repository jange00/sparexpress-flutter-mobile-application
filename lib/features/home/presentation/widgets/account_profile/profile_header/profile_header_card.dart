import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_state.dart';
import 'edit_profile_screen.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String email;
  final String imageUrl;
  final String phoneNumber;

  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    String getProfileImageUrl(String? profileImage) {
      if (profileImage == null || profileImage.isEmpty) {
        return '';
      }
      if (profileImage.startsWith('http')) {
        return profileImage;
      }
      return 'http://localhost:3000/$profileImage';
    }
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ProfileLoaded) {
          final user = state.customer;
          final imageUrl = getProfileImageUrl(user.profileImage);
          ImageProvider avatarProvider;
          if (imageUrl.isNotEmpty && Uri.tryParse(imageUrl)?.hasAbsolutePath == true) {
            avatarProvider = NetworkImage(imageUrl);
          } else {
            avatarProvider = const AssetImage("assets/images/default_avatar.png");
          }
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFC107),
              borderRadius: BorderRadius.circular(28),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: avatarProvider,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.phoneNumber,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () async {
                    final result = await showGeneralDialog<Map<String, String>>(
                      context: context,
                      barrierLabel: "Edit Profile",
                      barrierDismissible: true,
                      barrierColor: Colors.black.withOpacity(0.5),
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (context, anim1, anim2) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Center(
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 400,
                                  maxHeight: 600,
                                ),
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: EditProfileScreen(
                                  name: name,
                                  email: email,
                                  phoneNumber: phoneNumber,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      transitionBuilder: (context, anim1, anim2, child) {
                        return FadeTransition(
                          opacity: CurvedAnimation(parent: anim1, curve: Curves.easeOut),
                          child: ScaleTransition(
                            scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
                            child: child,
                          ),
                        );
                      },
                    );

                    if (result != null) {
                      // TODO: Handle the updated data (e.g., update parent widget or state)
                      // Example: print result
                      print("Updated profile data: $result");
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: const [
                        Icon(Icons.edit, color: Colors.red),
                        SizedBox(width: 10),
                        Text(
                          'Modify',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.chevron_right, color: Color(0xFFFFC107)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(); // Or a placeholder for other states
        }
      },
    );
  }
}
