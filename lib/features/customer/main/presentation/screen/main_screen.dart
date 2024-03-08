import 'package:asroo_store/core/di/injection_container.dart';
import 'package:asroo_store/core/enums/nav_bar_enum.dart';
import 'package:asroo_store/core/extensions/context_extension.dart';
import 'package:asroo_store/core/routes/app_routes.dart';
import 'package:asroo_store/core/service/push_notification/local_notfication_service.dart';
import 'package:asroo_store/features/customer/notifications/persentation/screens/notification_screen.dart';
import 'package:asroo_store/features/customer/favorites/presentation/screen/favorites_screen.dart';
import 'package:asroo_store/features/customer/home/presentation/screen/home_screen.dart';
import 'package:asroo_store/features/customer/main/presentation/cubit/main_cubit.dart';
import 'package:asroo_store/features/customer/main/presentation/refactors/bottom_nav_bar.dart';
import 'package:asroo_store/features/customer/main/presentation/refactors/main_customer_app_bar.dart';
import 'package:asroo_store/features/customer/profile/presentation/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    listenToNotifications();
  }

  void listenToNotifications() {
    LocalNotificationService.streamController.stream.listen((event) {
      if (int.parse(event.payload.toString()) == -1) return;
      context.pushName(
        AppRoutes.productDetails,
        arguments: int.parse(event.payload.toString()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MainCubit>(),
      child: Scaffold(
        appBar: const MainCustomerAppBar(),
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(context.assets.homeBg!),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<MainCubit, MainState>(
                  builder: (context, state) {
                    final cubit = context.read<MainCubit>();
                    if (cubit.navBarEnum == NavBarEnum.catgeories) {
                      return const NotificationScreen();
                    } else if (cubit.navBarEnum == NavBarEnum.favorites) {
                      return const FavoritesScreen();
                    } else if (cubit.navBarEnum == NavBarEnum.profile) {
                      return const ProfileScreen();
                    }
                    return const HomeScreen();
                  },
                ),
              ),
              const MainBottomNavBar(),
            ],
          ),
        ),
      ),
    );
  }
}
