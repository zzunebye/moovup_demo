import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:moovup_demo/blocs/SearchBloc/SearchBloc.dart';
import 'package:moovup_demo/blocs/SearchBloc/SearchEvents.dart';
import 'package:moovup_demo/blocs/SearchBloc/SearchStates.dart';
import 'package:moovup_demo/models/search_option_data.dart';
import 'package:moovup_demo/widgets/job_card.dart';

import 'components/SearchOption.dart';

class JobSearchPage extends StatefulWidget {
  static const String routeName = 'job-search';
  final String title;
  final String searchCategory;

  JobSearchPage({required this.title, this.searchCategory = ''});

  @override
  _JobSearchPageState createState() => _JobSearchPageState();
}

class _JobSearchPageState extends State<JobSearchPage> {
  final _formKey = GlobalKey<FormState>();
  late SearchBloc _searchBloc;

  SearchOptionData _searchOption = new SearchOptionData.empty();

  Future<dynamic> buildModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: new Icon(Icons.share),
                title: new Text('To be implemented'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.share),
                title: new Text('To be implemented'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.share),
                title: new Text('To be implemented'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.share),
                title: new Text('To be implemented'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _searchBloc = SearchBloc();
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as Map;

    // print() For implmentation
    print("${widget.title}, ${widget.searchCategory}");
    var _termController = TextEditingController();

    return BlocProvider.value(
      value: _searchBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // JobSearchForm(),
                Container(
                  margin: EdgeInsets.all(15),
                  child: TextFormField(
                    controller: _termController,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (term) {
                      _searchBloc.add(UpdateTerm(term));
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                      labelText: 'Search ...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SearchOptionButton(
                          optionTitle: 'District',
                          buildBar: buildModalBottomSheet,
                        ),
                        SizedBox(width: 10),
                        SearchOptionButton(
                          optionTitle: 'Time',
                          buildBar: buildModalBottomSheet,
                        ),
                        SizedBox(width: 10),
                        SearchOptionButton(
                          optionTitle: 'Salary',
                          buildBar: buildModalBottomSheet,
                        ),
                      ],
                    )),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: ElevatedButton(
                    onPressed: () {
                      _searchBloc.add(ResetSearch());
                    },
                    child: Text('Reset'),
                  ),
                ),
                Container(
                  child: BlocBuilder<SearchBloc, SearchStates>(
                    builder: (context, state) {
                      if (state is LoadDataSuccess) {
                        var jobDetail = state.data['job_search']['result'];
                        // streamController.add(jobDetail?['job_name']);
                        return ListView.builder(
                          itemCount: jobDetail.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final jobId = jobDetail[index];
                            return JobCard(job: jobId);
                          },
                        );
                      } else if (state is EmptyState) {
                        return Container(
                            height: MediaQuery.of(context).size.height - 400,
                            child: Center(child: Text("Waiting for Search")));
                      } else if (state is OnLoading) {
                        return LinearProgressIndicator();
                      } else {
                        return Container(
                            height: MediaQuery.of(context).size.height - 400,
                            child: Text("Empty"));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
