// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dicoding_simple_path_provider/utils/file_helper.dart';
import 'package:dicoding_simple_path_provider/widgets/file_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  bool get _isValid => _titleController.text.isNotEmpty;

  void _createNewFile() {
    _titleController.clear();
    _contentController.clear();
  }

  Future<void> _saveFile(BuildContext context) async {
    if (_isValid) {
      final filePath = await FileHelper.getFilePath(_titleController.text);
      await FileHelper.writeFile(filePath, _contentController.text);
      _showDialogSuccess(context);
    } else {
      _showDialogFailed(context);
    }
  }

  Future<void> _getFilesInDirectory(BuildContext context) async {
    final navigator = Navigator.of(context);
    final directory = await getApplicationDocumentsDirectory();

    final dir = Directory(directory.path);
    final files =
        dir.listSync().toList().where((file) => file.path.contains('txt'));
    final selectedFile = await navigator.push(
      CupertinoPageRoute(
        builder: (context) => FileDialog(
          files: files.toList(),
        ),
        fullscreenDialog: true,
      ),
    );

    if (selectedFile != null) {
      await _openFile((selectedFile as FileSystemEntity).path);
    }
  }

  Future<void> _openFile(String filePath) async {
    final content = await FileHelper.readFile(filePath);
    _contentController.text = content;
    _titleController.text = split(filePath).last.split('.').first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar:
          const CupertinoNavigationBar(middle: Text('My Read Write File')),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    onPressed: _createNewFile,
                    child: const Text('New File'),
                  ),
                ),
                Expanded(
                  child: CupertinoButton(
                    onPressed: () => _getFilesInDirectory(context),
                    child: const Text('Open File'),
                  ),
                ),
                Expanded(
                  child: CupertinoButton(
                    onPressed: () => _saveFile(context),
                    child: const Text('Save File'),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: CupertinoTextField(
                      placeholder: 'File Name',
                      controller: _titleController,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: CupertinoTextField(
                  placeholder: 'Write your notes here...',
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _contentController,
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showDialogSuccess(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('File Saved'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  _showDialogFailed(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            'File Not Created',
            style: TextStyle(color: CupertinoColors.systemRed),
          ),
          content: const Text('File name must not be empty!'),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
