import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class MessageComposer extends ConsumerStatefulWidget {
  final String conversationUuid;
  final bool disabled;
  final bool isSupport; // true → no file attachments (support only uses text)
  final void Function(String? content, List<XFile> attachments) onSend;

  const MessageComposer({
    super.key,
    required this.conversationUuid,
    required this.onSend,
    this.disabled = false,
    this.isSupport = false,
  });

  @override
  ConsumerState<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends ConsumerState<MessageComposer> {
  final _textController = TextEditingController();
  final List<XFile> _selectedFiles = [];
  bool _isSending = false;

  static const _maxFiles = 3;
  static const _maxFileBytes = 5 * 1024 * 1024; // 5 MB
  static const _allowedExtensions = ['jpg', 'jpeg', 'png', 'webp', 'pdf'];
  static const _primaryColor = Color(0xFFFF601F);

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  bool get _canSend {
    final hasText = _textController.text.trim().isNotEmpty;
    final hasFiles = _selectedFiles.isNotEmpty;
    return (hasText || hasFiles) && !_isSending && !widget.disabled;
  }

  Future<void> _send() async {
    if (!_canSend) return;
    final content = _textController.text.trim();
    final files = List<XFile>.from(_selectedFiles);
    setState(() {
      _isSending = true;
      _textController.clear();
      _selectedFiles.clear();
    });
    try {
      widget.onSend(content.isEmpty ? null : content, files);
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _pickAttachment() async {
    if (_selectedFiles.length >= _maxFiles) {
      _showError('Maximum $_maxFiles fichiers par message.');
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Photo / Vidéo'),
              onTap: () async {
                Navigator.pop(ctx);
                await _pickImages();
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Document (PDF)'),
              onTap: () async {
                Navigator.pop(ctx);
                await _pickPdf();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    await _addFiles(picked.map((x) => XFile(x.path, name: x.name)).toList());
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;
    final path = result.files.single.path;
    final name = result.files.single.name;
    if (path != null) {
      await _addFiles([XFile(path, name: name)]);
    }
  }

  Future<void> _addFiles(List<XFile> files) async {
    for (final file in files) {
      if (_selectedFiles.length >= _maxFiles) {
        _showError('Maximum $_maxFiles fichiers par message.');
        break;
      }
      final ext = file.name.split('.').last.toLowerCase();
      if (!_allowedExtensions.contains(ext)) {
        _showError('Type de fichier non supporté: .$ext');
        continue;
      }
      final size = await file.length();
      if (size > _maxFileBytes) {
        _showError('${file.name} dépasse la limite de 5 MB.');
        continue;
      }
      setState(() => _selectedFiles.add(file));
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.disabled) {
      return Container(
        padding: const EdgeInsets.all(12),
        color: Colors.grey.shade100,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 16, color: Colors.grey),
            SizedBox(width: 8),
            Text('Cette conversation est fermée',
                style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Attachment preview chips
          if (_selectedFiles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Wrap(
                spacing: 8,
                children: _selectedFiles.map((f) {
                  return Chip(
                    label: Text(f.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11)),
                    deleteIcon: const Icon(Icons.close, size: 14),
                    onDeleted: () =>
                        setState(() => _selectedFiles.remove(f)),
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ),
          // Input row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!widget.isSupport)
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: _pickAttachment,
                    color: Colors.grey,
                    visualDensity: VisualDensity.compact,
                  ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onChanged: (_) => setState(() {}),
                    maxLines: null,
                    maxLength: 2000,
                    buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
                        null,
                    decoration: const InputDecoration(
                      hintText: 'Votre message…',
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                AnimatedOpacity(
                  opacity: _canSend ? 1.0 : 0.4,
                  duration: const Duration(milliseconds: 150),
                  child: IconButton(
                    icon: _isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: _primaryColor),
                          )
                        : const Icon(Icons.send_rounded, color: _primaryColor),
                    onPressed: _canSend ? _send : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
