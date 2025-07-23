import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: SizedBox.expand(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF6F00), Color(0xFFC107)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orangeAccent,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 16),
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProfileLoaded) {
                    final user = state.customer;
                    String getProfileImageUrl(String? profileImage) {
                      if (profileImage == null || profileImage.isEmpty) {
                        return '';
                      }
                      if (profileImage.startsWith('http')) {
                        return profileImage;
                      }
                      return 'http://localhost:3000/$profileImage';
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
                            children: [
                              const Text(
                                'Welcome back,',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                user.fullName,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.7,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: avatarProvider,
                          backgroundColor: Colors.white24,
                        ),
                      ],
                    );
                  } else if (state is ProfileError) {
                    return Center(child: Text('Error: \\${state.message}', style: const TextStyle(color: Colors.red)));
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
  Size get preferredSize => const Size.fromHeight(120);
}
