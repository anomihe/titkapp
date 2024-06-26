import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tiktok_app/download/downloader_bloc.dart';


class DownloadProgressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloaderBloc, DownloaderState>(
      builder: (context, state) {
        if (state is DownloadInProgress) {
          return CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 10.0,
            percent: state.progress / 100,
            center: Text(
              "${state.progress.toStringAsFixed(2)}%",
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.grey.shade300,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Colors.blueAccent,
          );
        } else if (state is Download) {
          return Center(child: Text('Download Complete'));
        } else if (state is ErrorState) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return Container();
      },
    );
  }
}

