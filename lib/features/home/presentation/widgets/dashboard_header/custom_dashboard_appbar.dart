import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparexpress/app/constant/api_endpoints.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_state.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_event.dart';
import 'package:get_it/get_it.dart';

class CustomDashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomDashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<ProfileBloc>()..add(FetchCustomerProfile()),
      child: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: SizedBox.expand(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6F00), Color(0xFFFFC107)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFC107).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 8),
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    );
                  } else if (state is ProfileLoaded) {
                    final user = state.customer;
                    String getProfileImageUrl(String? profileImage) {
                      if (profileImage == null || profileImage.isEmpty) {
                        return '';
                      }
                      if (profileImage.startsWith('http')) {
                        return profileImage;
                      }
                      return '${ApiEndpoints.serverAddress}/$profileImage';
                    }
                    final imageUrl = getProfileImageUrl(user.profileImage);
                    ImageProvider avatarProvider;
                    if (imageUrl.isNotEmpty && Uri.tryParse(imageUrl)?.hasAbsolutePath == true) {
                      avatarProvider = NetworkImage(imageUrl);
                    } else {
                      avatarProvider = const AssetImage('assets/images/mouse.jpg');
                    }
                    return Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min, // Fix overflow
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      '👋 Welcome back',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                user.fullName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.2,
                                  height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Ready to explore?',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.25),
                                Colors.white.withOpacity(0.15),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundImage: avatarProvider,
                            backgroundColor: Colors.white.withOpacity(0.1),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state is ProfileError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.white.withOpacity(0.7),
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Unable to load profile',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
