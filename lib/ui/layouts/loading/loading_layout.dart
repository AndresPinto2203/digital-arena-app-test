import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'loading_cubit.dart';

class LoadingLayout extends StatelessWidget {
  const LoadingLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LoadingCubit, bool, bool>(
      selector: (state) => state,
      builder: (context, isLoading) {
        return Visibility(
          visible: isLoading,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            color: const Color(0x80000000),
            child: const CircularProgressIndicator(color: Colors.blue),
          ),
        );
      },
    );
  }
}
