import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/file.dart';

enum ResultState {
  loading,
  error,
  success,
}

class RenderResult {
  const RenderResult({
    this.file,
    this.state = ResultState.loading,
  });

  final File? file;
  final ResultState state;
}

class RenderCubit extends Cubit<RenderResult> {
  RenderCubit() : super(const RenderResult());

  read() async {
    //loading file just once
    final file = await loadPDF('assets/stg.pdf', 'stg.pdf');

    emit(
      RenderResult(
        file: file,
        state: ResultState.success,
      ),
    );
  }
}
