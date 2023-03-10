import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

import 'package:file_picker/file_picker.dart';

class BackUpData extends StatefulWidget {
  const BackUpData({Key? key, required this.title}) : super(key: key);
  static const routeName = "/backup";

  final String title;

  @override
  State<BackUpData> createState() => _BackUpDataState();
}

class _BackUpDataState extends State<BackUpData> {
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(message),
            ElevatedButton(
              onPressed: () async {
                final dbFolder = await getDatabasesPath();

                File source1 = File('$dbFolder/transaction.db');

                // String? result = await FilePicker.platform.getDirectoryPath();
                String result = "/storage/emulated/0/Download";

                Directory copyTo = Directory(result);
                if ((await copyTo.exists())) {
                  var status = await Permission.storage.status;
                  if (!status.isGranted) {
                    await Permission.storage.request();
                  }
                } else {
                  print("not exist");
                  if (await Permission.storage.request().isGranted) {
                    // Either the permission was already granted before or the user just granted it.
                    await copyTo.create();
                  } else {
                    print('Please give permission');
                  }
                }

                String newPath = "${copyTo.path}/transaction.db";
                //final file = File(newPath);

                await source1.copy(newPath);
                //print(file);

                setState(() {
                  message = 'Successfully Copied DB';
                });

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Successfully Copied to downloads"),
                ));
              },
              child: const Text('Copy DB'),
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     var databasesPath = await getDatabasesPath();
            //     var dbPath = join(databasesPath, 'transaction.db');
            //     await deleteDatabase(dbPath);
            //     setState(() {
            //       message = 'Successfully deleted DB';
            //     });
            //   },
            //   child: const Text('Delete DB'),
            // ),
            ElevatedButton(
              onPressed: () async {
                var databasesPath = await getDatabasesPath();
                var dbPath = join(databasesPath, 'transaction.db');

                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                if (result != null) {
                  File source = File(result.files.single.path!);
                  await source.copy(dbPath);
                  setState(() {
                    message = 'Successfully Restored DB';
                  });

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Successfully Restored from downloads"),
                  ));
                } else {
                  // User canceled the picker

                }
              },
              child: const Text('Restore DB'),
            ),
          ],
        ),
      ),
    );
  }
}
