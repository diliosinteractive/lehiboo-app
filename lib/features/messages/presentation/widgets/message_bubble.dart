import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/message.dart';
import 'attachment_preview.dart';

class MessageBubble extends StatefulWidget {
  final Message message;
  final bool isLastOwn; // true → show delivery ticks
  final void Function(String messageUuid, String content)? onEdit;
  final void Function(String messageUuid)? onDelete;

  const MessageBubble({
    super.key,
    required this.message,
    this.isLastOwn = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool _isEditing = false;
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _editController =
        TextEditingController(text: widget.message.content ?? '');
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  static const _primaryColor = Color(0xFFFF601F);

  @override
  Widget build(BuildContext context) {
    final msg = widget.message;

    // System messages: centered pill
    if (msg.isSystem) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info_outline,
                  size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  msg.content ?? '',
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment:
          msg.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress:
            msg.isMine && !msg.isDeleted ? () => _showContextMenu(context) : null,
        child: Container(
          margin: EdgeInsets.only(
            left: msg.isMine ? 48 : 8,
            right: msg.isMine ? 8 : 48,
            top: 4,
            bottom: 4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!msg.isMine) ...[
                _buildAvatar(msg),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Column(
                  crossAxisAlignment: msg.isMine
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    _buildBubble(context, msg),
                    if (widget.isLastOwn && msg.isMine && !msg.isDeleted)
                      _buildDeliveryTicks(msg),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(Message msg) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: Colors.grey.shade300,
      child: Text(
        msg.sender?.name.isNotEmpty == true
            ? msg.sender!.name[0].toUpperCase()
            : '?',
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _buildBubble(BuildContext context, Message msg) {
    final isMine = msg.isMine;
    final bgColor = isMine ? _primaryColor : Colors.grey.shade200;
    final textColor = isMine ? Colors.white : Colors.black87;

    if (msg.isDeleted) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Ce message a été supprimé',
          style: TextStyle(
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
              fontSize: 13),
        ),
      );
    }

    if (_isEditing) {
      return _buildEditWidget(context);
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Attachments before text
          if (msg.attachments.isNotEmpty)
            ...msg.attachments.map(
                (a) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: AttachmentPreview(attachment: a),
                    )),
          // Text content
          if (msg.content != null && msg.content!.isNotEmpty)
            Text(msg.content!, style: TextStyle(color: textColor)),
          // Metadata row
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatTime(msg.createdAt),
                style: TextStyle(
                    fontSize: 10,
                    color: isMine
                        ? Colors.white.withValues(alpha: 0.7)
                        : Colors.grey.shade500),
              ),
              if (msg.isEdited) ...[
                const SizedBox(width: 4),
                Text(
                  '(modifié)',
                  style: TextStyle(
                      fontSize: 10,
                      color: isMine
                          ? Colors.white.withValues(alpha: 0.7)
                          : Colors.grey.shade500),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _primaryColor),
      ),
      child: Column(
        children: [
          TextField(
            controller: _editController,
            autofocus: true,
            maxLines: null,
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => setState(() => _isEditing = false),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  final content = _editController.text.trim();
                  if (content.isNotEmpty) {
                    widget.onEdit?.call(widget.message.uuid, content);
                  }
                  setState(() => _isEditing = false);
                },
                child: const Text('Valider',
                    style: TextStyle(color: _primaryColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryTicks(Message msg) {
    IconData icon;
    Color color;
    if (msg.isRead) {
      icon = Icons.done_all;
      color = _primaryColor;
    } else if (msg.isDelivered) {
      icon = Icons.done_all;
      color = Colors.grey;
    } else {
      icon = Icons.check;
      color = Colors.grey;
    }
    return Padding(
      padding: const EdgeInsets.only(right: 4, top: 2),
      child: Icon(icon, size: 14, color: color),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Modifier'),
              onTap: () {
                Navigator.pop(ctx);
                setState(() => _isEditing = true);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Supprimer',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(ctx);
                widget.onDelete?.call(widget.message.uuid);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copier le texte'),
              onTap: () {
                Navigator.pop(ctx);
                final text = widget.message.content ?? '';
                Clipboard.setData(ClipboardData(text: text));
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
