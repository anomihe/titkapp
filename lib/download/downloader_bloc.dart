// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:direct_link/direct_link.dart';
import 'package:path/path.dart' as path;
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/direct.dart';

part 'downloader_event.dart';
part 'downloader_state.dart';

class DownloaderBloc extends Bloc<DownloaderEvent, DownloaderState> {
  final DioServices services = DioServices();
  final Dio _dio = Dio();
  DownloaderBloc() : super(DownloaderInitial()) {
    on<InitializeDownloader>(_onInitializeDownloader);
    on<EnterAddress>(enteraddress);
    on<Address>(link);
    on<DownloadLink>(_onUpdateDownloadProgress);
  }
  FutureOr<void> _onInitializeDownloader(
      InitializeDownloader event, Emitter<DownloaderState> emit) {
    // Initial logic here if needed
    emit(DownloaderInitial());
  }

  FutureOr<void> link(Address link, Emitter<DownloaderState> emit) {
   // emit(DownloaderInitial());
    if (state is DownloaderInitial) {
      emit(EnterLink(link.address));
    }
  }

  FutureOr<void> enteraddress(
      EnterAddress link, Emitter<DownloaderState> emit) async {
    emit(DownloaderInitial());
    // if(state is EnterLink){
    // var directLink = DirectLink();
    try {
        var directLink = DirectLink();
      var model = await directLink.check(link.address,
          timeout: const Duration(seconds: 10));
      print('inside bloc ${model?.thumbnail}');
//List<String> items = model?.links?.map((link) => link.toString()).toList() ?? [];
      if (model == null) {
        print('is null');
        emit(ErrorState('Failed to retrieve link details.'));
        return;
      } else {
        List<Map<String, dynamic>> transformedLinks = model.links!
            .map((link) => {
                  'quality': link.quality,
                  'type': link.type,
                  'link': link.link,
                })
            .toList();
        emit(DownloadDetails(
            name: model.title!,
            download: transformedLinks,
            thumbnail: model.thumbnail!));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
    //}
  }

  FutureOr<void> _onUpdateDownloadProgress(
      DownloadLink link, Emitter<DownloaderState> emit) async {
    emit(DownloaderInitial());
    PermissionStatus status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      // if (state is DownloadDetails) {
      Directory? directory = await getExternalStorageDirectory();
      String savedDir = directory!.path;
      // String fileName = path.basename(link.downloadLink);

      await _dio.download(
        link.downloadLink,
        savedDir,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total) * 100;
            emit(DownloadInProgress(progress));
          }
        },
      );
      emit(Download(link.downloadLink));
    }
  }
}
