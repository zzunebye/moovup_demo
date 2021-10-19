import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:moovup_demo/blocs/SearchBloc/SearchEvents.dart';
import 'package:moovup_demo/blocs/SearchBloc/SearchStates.dart';
import 'package:moovup_demo/models/search_option_data.dart';
import 'package:moovup_demo/pages/job_search_page/job_search_page.dart';
import 'package:moovup_demo/repositories/job_post.dart';
import 'package:moovup_demo/services/GraphQLService.dart';

class SearchBloc extends Bloc<SearchEvents, SearchStates> {
  late PostRepository repository;

  // NOTE: initial state of the bloc is EmptyState
  SearchBloc() : super(EmptyState(SearchOptionData.empty())) {
    this.repository = PostRepository(client: GraphQLService());
    on<FetchSearchData>(onFetchSearchData);
    on<ResetSearch>(onResetSearch);
    on<UpdateWage>(onUpdateWage);
    on<UpdateTerm>(onUpdateTerm);
  }

  // @override
  // void onChange(Change<int> change) {
  //   super.onChange(change);
  //   print(change);
  // }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }

  FutureOr<void> onFetchSearchData(
      FetchSearchData event, Emitter<SearchStates> emit) async {
    try {
      final searchResult =
          await repository.SearchJobWithOptions(this.state.searchOption);
      emit(LoadDataSuccess(searchResult.data, this.state.searchOption));
    } catch (e) {
      emit(LoadDataFail(e.toString(), this.state.searchOption));
    }
  }

  FutureOr<void> onResetSearch(ResetSearch event, Emitter<SearchStates> emit) {
    try {
      emit(EmptyState(SearchOptionData.empty()));
    }
    catch(e){
      emit(LoadDataFail(e.toString(), this.state.searchOption));

    }
  }

  FutureOr<void> onUpdateWage(
    UpdateWage event,
    Emitter<SearchStates> emit,
  ) async {
    this.state.searchOption.monthly_rate = event.wageRange;
    emit(OnLoading(this.state.searchOption));
    this.add(FetchSearchData(this.state.searchOption));
  }

  FutureOr<void> onUpdateTerm(
    UpdateTerm event,
    Emitter<SearchStates> emit,
  ) async {
    this.state.searchOption.term = event.term;
    emit(OnLoading(this.state.searchOption));
    this.add(FetchSearchData(this.state.searchOption));
  }

  @override
  Future<void> close() async {
    //cancel streams
    super.close();
  }
}
