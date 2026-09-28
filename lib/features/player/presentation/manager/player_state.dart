import 'package:equatable/equatable.dart';
import 'package:thaheen_lms/features/shared/data/models/lesson_player_data.dart';

sealed class PlayerState extends Equatable {
  const PlayerState();

  @override
  List<Object?> get props => [];
}

class PlayerInitial extends PlayerState {}

class PlayerLoading extends PlayerState {}

class PlayerLoaded extends PlayerState {
  const PlayerLoaded(this.data);

  final LessonPlayerData data;

  @override
  List<Object?> get props => [data];
}

class PlayerError extends PlayerState {
  const PlayerError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
