// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:direct_link/direct_link.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tiktok_app/download/downloader_bloc.dart';
import 'package:tiktok_app/download_widget.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Direct Link Generator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 130, 240, 187)),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => DownloaderBloc()..add(InitializeDownloader()),
        child: const MyHomePage(title: 'Direct Link Generator'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>>? links;
  bool isLoading = false; // Added loading indicator flag.
  TextEditingController urlController = TextEditingController();
  late DownloaderBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = DownloaderBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              showSupportedLinksDialog(context);
            },
            icon: const Icon(
              Icons.info,
              size: 30,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: urlController,
                  decoration: const InputDecoration(
                    labelText: 'Enter URL',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<DownloaderBloc>()
                      .add(EnterAddress(urlController.text));
                },
                child: const Text('Generate Direct Link'),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
          BlocBuilder<DownloaderBloc, DownloaderState>(
              buildWhen: (previousState, currentState) => true,
              bloc: bloc,
              builder: (context, state) {
                // switch (state.runtimeType) {
                //   // case DownloaderInitial:
                //   //   return const CircularProgressIndicator();
                //   // case EnterLink:
                //   //   return Column(
                //   //     children: [
                //   //       Padding(
                //   //         padding: const EdgeInsets.all(16.0),
                //   //         child: TextField(
                //   //           controller: urlController,
                //   //           decoration: const InputDecoration(
                //   //             labelText: 'Enter URL',
                //   //             border: OutlineInputBorder(),
                //   //           ),
                //   //         ),
                //   //       ),
                //   //       SizedBox(
                //   //         height: 10,
                //   //       ),
                //   //       ElevatedButton(
                //   //         onPressed: () {
                //   //           context
                //   //               .read<DownloaderBloc>()
                //   //               .add(EnterAddress(urlController.text));
                //   //         },
                //   //         child: const Text('Generate Direct Link'),
                //   //       ),
                //   //       SizedBox(
                //   //         height: 10,
                //   //       ),
                //   //     ],
                //   //   );

                //   case DownloadDetails:
                //     var tate = state as DownloadDetails;
                // return Expanded(
                //   child: ListView.builder(
                //     itemCount: tate.download.length,
                //     itemBuilder: (context, index) {
                //       var link = tate.download[index];

                //       return Card(
                //         child: ListTile(
                //           // title: Text('${link['quality']}p'),
                //           title: Column(
                //             children: [
                //               Text('${link['quality']}p'),
                //               Image.network(state.thumbnail)
                //             ],
                //           ),
                //           subtitle: Text(link['type']),
                //           trailing: IconButton(
                //             icon: const Icon(Icons.download),
                //             onPressed: () {
                //               //copyToClipboard(link['link']);
                //               context
                //                   .read<DownloaderBloc>()
                //                   .add(DownloadLink(link['link']));
                //               ScaffoldMessenger.of(context).showSnackBar(
                //                 const SnackBar(
                //                   content: Text('Downloading'),
                //                   backgroundColor: Colors.green,
                //                 ),
                //               );
                //             },
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // );
                //   case ErrorState:
                //    var stat = state as ErrorState;
                //     return SnackBar(content: Text(stat.message));
                //   case DownloadInProgress:
                //     var stat = state as DownloadInProgress;
                //     return CircularPercentIndicator(
                //       radius: 50.0,
                //       lineWidth: 10.0,
                //       // animation: true,
                //       percent: stat.progress / 100,
                //       center: Text(
                //         "${stat.progress}%",
                //         style: const TextStyle(
                //             fontSize: 20.0,
                //             fontWeight: FontWeight.w600,
                //             color: Colors.black),
                //       ),
                //       backgroundColor: Colors.grey.shade300,
                //       circularStrokeCap: CircularStrokeCap.round,
                //       progressColor: Colors.blueAccent,
                //     );

                // }//  Default:
                // return Center(
                //   child: CircularProgressIndicator(),
                // );

                if (state is DownloadDetails) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.download.length,
                      itemBuilder: (context, index) {
                        var link = state.download[index];

                        return Card(
                          child: ListTile(
                            // title: Text('${link['quality']}p'),
                            title: Column(
                              children: [
                                Text('${link['quality']}p'),
                                Image.network(state.thumbnail)
                              ],
                            ),
                            subtitle: Text(link['type']),
                            trailing: IconButton(
                              icon: const Icon(Icons.download),
                              onPressed: () {
                                //copyToClipboard(link['link']);
                                context
                                    .read<DownloaderBloc>()
                                    .add(DownloadLink(link['link']));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Downloading'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is DownloaderInitial) {
                  return const CircularProgressIndicator();
                } else if (state is ErrorState) {
                  return Center(child: Text(state.message));
                } else {
                  return const Text('Unknown State');
                }
              }
              // if (state is DownloaderInitial) {
              //   return const CircularProgressIndicator();
              // }
              // if (state is EnterLink) {
              //   return
              //   Column(
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.all(16.0),
              //         child: TextField(
              //           controller: urlController,
              //           decoration: const InputDecoration(
              //             labelText: 'Enter URL',
              //             border: OutlineInputBorder(),
              //           ),
              //         ),
              //       ),
              //       SizedBox(
              //         height: 10,
              //       ),
              //       ElevatedButton(
              //         onPressed: () {
              //           context
              //               .read<DownloaderBloc>()
              //               .add(EnterAddress(urlController.text));
              //         },
              //         child: const Text('Generate Direct Link'),
              //       ),

              //       SizedBox(height: 10,),
              //     ],
              //   );
              // }
              // if (state is DownloadDetails) {
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: state.download.length,
              //     itemBuilder: (context, index) {
              //       var link = state.download[index];

              //       return Card(
              //         child: ListTile(
              //           // title: Text('${link['quality']}p'),
              //           title: Column(
              //             children: [
              //               Text('${link['quality']}p'),
              //               Image.network(state.thumbnail)
              //             ],
              //           ),
              //           subtitle: Text(link['type']),
              //           trailing: IconButton(
              //             icon: const Icon(Icons.download),
              //             onPressed: () {
              //               //copyToClipboard(link['link']);
              //               context
              //                   .read<DownloaderBloc>()
              //                   .add(DownloadLink(link['link']));
              //               ScaffoldMessenger.of(context).showSnackBar(
              //                 const SnackBar(
              //                   content: Text('Downloading'),
              //                   backgroundColor: Colors.green,
              //                 ),
              //               );
              //             },
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // );
              // }
              //if (state is DownloadInProgress) {
              // return CircularPercentIndicator(
              //   radius: 50.0,
              //   lineWidth: 10.0,
              //   // animation: true,
              //   percent: state.progress / 100,
              //   center: Text(
              //     "${state.progress}%",
              //     style: const TextStyle(
              //         fontSize: 20.0,
              //         fontWeight: FontWeight.w600,
              //         color: Colors.black),
              //   ),
              //   backgroundColor: Colors.grey.shade300,
              //   circularStrokeCap: CircularStrokeCap.round,
              //   progressColor: Colors.blueAccent,
              // );
              // } else {
              //   return const Center(child: Text('Unknown State'));
              // }
              //},
              ),
               DownloadProgressWidget(),
        ],
      ),
      // bottomNavigationBar: const Padding(
      //   padding: EdgeInsets.all(2.0),
      //   child: Text(
      //     'Developed by AdityaDev',
      //     textAlign: TextAlign.center,
      //   ),
      // ),
    );
  }

  // return Column(
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.all(16.0),
  //               child: TextField(
  //                 controller: urlController,
  //                 decoration: const InputDecoration(
  //                   labelText: 'Enter URL',
  //                   border: OutlineInputBorder(),
  //                 ),
  //               ),
  //             ),
  //             ElevatedButton(
  //               onPressed: onPressed,
  //               child: const Text('Generate Direct Link'),
  //             ),
  //             const SizedBox(
  //               height: 20,
  //             ),
  //             isLoading
  //                 ? const CircularProgressIndicator() // Show loading indicator.
  //                 : links != null
  //                     ? Expanded(
  //                         child: ListView.builder(
  //                           itemCount: links!.length,
  //                           itemBuilder: (context, index) {
  //                             var link = links![index];
  //                             return Card(
  //                               child: ListTile(
  //                                 title: Text('${link['quality']}p'),
  //                                 subtitle: Text(link['type']),
  //                                 trailing: IconButton(
  //                                   icon: const Icon(Icons.content_copy),
  //                                   onPressed: () {
  //                                     copyToClipboard(link['link']);
  //                                     ScaffoldMessenger.of(context)
  //                                         .showSnackBar(
  //                                       const SnackBar(
  //                                         content:
  //                                             Text('Link copied to clipboard'),
  //                                         backgroundColor: Colors.green,
  //                                       ),
  //                                     );
  //                                   },
  //                                 ),
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                       )
  //                     : Container(),
  //           ],
  //         );

  // // onPressed() function to generate the direct link.
  // Future<void> onPressed() async {
  //   setState(() {
  //     isLoading = true; // Set loading to true before fetching data.
  //   });

  //   var directLink = DirectLink();

  //   var url = urlController.text;

  //   if (url.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Please enter a valid URL'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     setState(() {
  //       isLoading = false; // Set loading to false when the input is invalid.
  //     });
  //     return;
  //   }

  //   var model = await directLink.check(url);

  //   if (model == null) {
  //     // ignore: avoid_print
  //     print('model is null');
  //     setState(() {
  //       isLoading = false; // Set loading to false when there is an error.
  //     });
  //     return;
  //   }
  //   model.thumbnail;

  //   setState(() {
  //     links = model.links
  //         ?.map((link) => {
  //               'quality': link.quality,
  //               'type': link.type,
  //               'link': link.link,

  //             })
  //         .toList();
  //     isLoading = false; // Set loading to false after fetching data.
  //   });
  // }

  // To copy the generated links.
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}

// To launch the url.
// Future<void> joinTelegram() async {
//   final Uri url = Uri.parse('https://telegram.me/VikiMediaOfficial/');
//   if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
//     throw Exception('Could not launch $url');
//   }
// }

// To show the dialog box.
void showSupportedLinksDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Supported Links'),
        contentPadding: const EdgeInsets.all(16.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            stylingText('- Facebook'),
            stylingText('- Instagram'),
            stylingText('- Youtube'),
            stylingText('- Twitter'),
            stylingText('- Dailymotion'),
            stylingText('- Vimeo'),
            stylingText('- VK'),
            stylingText('- SoundCloud'),
            stylingText('- Tiktok'),
            stylingText('- Reddit'),
            stylingText('- Threads'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

// To Style the text.
Widget stylingText(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      text,
      style: const TextStyle(fontSize: 16.0),
    ),
  );
}

// import 'package:direct_link/direct_link.dart';
// import 'package:flutter/material.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Direct Link Example',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Direct Link Example'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: onPressed,
//         tooltip: 'Check',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   Future<void> onPressed() async {
//     log('Checking');

//     var directLink = DirectLink();

//     var url = 'https://www.tiktok.com/@selenagomez/video/7281437289602059566?lang=en';

//     var model =
//         await directLink.check(url, timeout: const Duration(seconds: 10));

//     if (model == null) {
//       return log('model is null');
//     }

//     log('title: ${model.title}');
//     log('thumbnail: ${model.thumbnail}');
//     log('duration: ${model.duration}');
//     for (var e in model.links!) {
//       log('type: ${e.type}');
//       log('quality: ${e.quality}');
//       log('link: ${e.link}');
//     }
//   }
// }
