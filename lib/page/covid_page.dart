import 'package:bloc_demo/bloc/covid_bloc.dart';
import 'package:bloc_demo/bloc/covid_event.dart';
import 'package:bloc_demo/bloc/covid_state.dart';
import 'package:bloc_demo/config/app_color.dart';
import 'package:bloc_demo/model/covid_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CovidPage extends StatefulWidget {
  const CovidPage({super.key});

  @override
  State<CovidPage> createState() => _CovidPageState();
}

class _CovidPageState extends State<CovidPage> {
  final CovidBloc _covidBloc = CovidBloc();

  @override
  void initState() {
    _covidBloc.add(GetCovidList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kffffff,
      appBar: AppBar(
        title: const Text('COVID - 19'),
      ),
      body: _buildListCovid(),
    );
  }

  Widget _buildListCovid() {
    return Container(
      margin: const EdgeInsets.all(0.8),
      child: BlocProvider(
        create: (_) => _covidBloc,
        child: BlocListener<CovidBloc, CovidState>(
          listener: (context, state) {
            if (state is CovidError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                ),
              );
            }
          },
          child: BlocBuilder<CovidBloc, CovidState>(
            builder: (context, state) {
              if (state is CovidInitial) {
                return _buildLoading();
              } else if (state is CovidLoading) {
                return _buildLoading();
              } else if (state is CovidLoaded) {
                return _buildCard(context, state.covidModel);
              } else if (state is CovidError) {
                return Container();
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildCard(BuildContext context, CovidModel model) {
    return ListView.builder(
      itemCount: model.countries!.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  "Country : ${model.countries![index].country}".toUpperCase()),
              const SizedBox(
                height: 10,
              ),
              Text("Total Confirmed : ${model.countries![index].totalConfirmed}"
                  .toUpperCase()),
              const SizedBox(
                height: 10,
              ),
              Text("Total Deaths : ${model.countries![index].totalDeaths}"
                  .toUpperCase()),
              const SizedBox(
                height: 10,
              ),
              Text("Total Recovered : ${model.countries![index].totalRecovered}"
                  .toUpperCase()),
            ],
          ),
        );
      },
    );
  }
}
