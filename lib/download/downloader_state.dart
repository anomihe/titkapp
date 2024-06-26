part of 'downloader_bloc.dart';

@immutable
abstract class DownloaderState {}

class DownloaderInitial extends DownloaderState {}

class EnterLink extends DownloaderState {
  final String link;
  EnterLink(this.link);
}

class Download extends DownloaderState {
  final String downloadLink;

  Download(this.downloadLink);
}

class DownloadDetails extends DownloaderState {
  final String name;
  //final List<String> download;
  final List<Map<String, dynamic>> download;
  final String thumbnail;

  DownloadDetails(
      {required this.name, required this.download, required this.thumbnail});
}
class DownloadInProgress extends DownloaderState {
  final double progress;

  DownloadInProgress(this.progress);
}

class ErrorState extends DownloaderState {
  final String message;

  ErrorState(this.message);
}