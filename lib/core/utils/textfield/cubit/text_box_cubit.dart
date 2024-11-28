import 'package:flutter_bloc/flutter_bloc.dart';

class TextBoxCubit extends Cubit<bool> {
  TextBoxCubit() : super(true);

  void toggleObscureText() {
    emit(!state);
  }
}
