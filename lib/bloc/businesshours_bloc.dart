import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_tris_manager/repository/hours_repository.dart';
import 'package:pizzeria_model_package/business_hours.dart';
import 'package:pizzeria_model_package/opening_hours.dart';
import 'package:pizzeria_model_package/opening_hours_list.dart';

part 'businesshours_event.dart';
part 'businesshours_state.dart';

class BusinesshoursBloc extends Bloc<BusinesshoursEvent, BusinesshoursState> {
  late BusinessHours _initialHours;
  final HoursRepository _repository = HoursRepository();

  BusinesshoursBloc() : super(InitialBusinesshoursState()) {
    on<InitializeBusinessHoursEvent>((event, emit) async {
      emit(InitializingBusinesshoursState());
      _initialHours = await _repository.get();
      emit(InitializedBusinesshoursState(_initialHours));
    });

    on<AddBusinessHoursEvent>(
      (event, emit) {
        if (state is InitializedBusinesshoursState) {
          final res = (state as InitializedBusinesshoursState).businessHours
            ..addDayHour(event.giorno, event.orari);
          _repository.save(event.giorno, res.getHoursFromkey(event.giorno));
          emit(InitializedBusinesshoursState(res.copyWith()));
        } else {
          add(InitializeBusinessHoursEvent());
        }
      },
    );

    on<SaveAllBusinessHoursEvent>((event, emit) {
      _repository.saveAll(event.orari);
      emit(InitializedBusinesshoursState(event.orari));
    });

    on<RemoveBusinessHoursEvent>(
      (event, emit) {
        if (state is InitializedBusinesshoursState) {
          _repository.remove(event.giorno);

          add(InitializeBusinessHoursEvent());
        }
      },
    );

    on<UpdateBusinessHoursEvent>(
      (event, emit) async {
        if (state is InitializedBusinesshoursState) {
          await _repository.update(event.giorno, event.orari);
        }
        add(InitializeBusinessHoursEvent());
      },
    );

    on<UndoUpdateBusinessHoursEvent>(
      (event, emit) {
        emit(InitializedBusinesshoursState(
            _initialHours.copyWith(daysMap: Map.from(_initialHours.daysMap))));
      },
    );
  }
}
