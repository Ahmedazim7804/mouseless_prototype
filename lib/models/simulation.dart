import 'package:mouseless/models/window.dart';

class SimulationModel {
  SimulationModel({required this.title, required this.windows});
  final String title;
  final List<Window> windows;

  SimulationModel copyWith({String? title, List<Window>? windows}) {
    return SimulationModel(
      title: title ?? this.title,
      windows: windows ?? this.windows,
    );
  }
}
