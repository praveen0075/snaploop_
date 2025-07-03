import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/features/navigation/bloc/nav_bloc.dart';
import 'package:snap_loop/features/navigation/bloc/nav_event.dart';
import 'package:snap_loop/features/navigation/bloc/nav_state.dart';
import 'package:snap_loop/features/post/presentation/pages/add_post_page.dart';
import 'package:snap_loop/features/home/presentation/pages/home_page.dart';
import 'package:snap_loop/features/profile/presentation/pages/profile_page.dart';
import 'package:snap_loop/features/search/presentation/pages/search_page.dart';

class RootPage extends StatelessWidget {
  RootPage({super.key});

  final screens = [HomePage(), SearchPage(), AddPostPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: screens[state.selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            
            // backgroundColor: Theme.of(context).colorScheme.surface,
            showUnselectedLabels: false,
            showSelectedLabels: true,
            type: BottomNavigationBarType.fixed,
            iconSize: 28, 
            currentIndex: state.selectedIndex,
            unselectedItemColor: Theme.of(context).colorScheme.inversePrimary,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            onTap: (value) => context.read<NavBloc>().add(NavigateTo(value)),
            items: [
              
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_box_outlined),
                label: "Feed",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_rounded),
                label: "Profile",
              ),
            ],
          ),
        );
      },
    );
  }
}
