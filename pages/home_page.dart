import 'package:breathe/cubits/home_cubit.dart';
import 'package:breathe/screens/home.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// HomePage dient als BlocProvider für den Homescreen
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeCubit(),
      child: const HomeScreen(),
    );
  }
}
