part of 'downloader_bloc.dart';

@immutable
abstract class DownloaderEvent {}
class InitializeDownloader extends DownloaderEvent {}

class EnterAddress extends DownloaderEvent {
  final String address;
  EnterAddress(this.address);
}

class DownloadLink extends DownloaderEvent {
  final String downloadLink;
  DownloadLink(this.downloadLink);
}

class Address extends DownloaderEvent {
  final String address;
  Address(this.address);
}
