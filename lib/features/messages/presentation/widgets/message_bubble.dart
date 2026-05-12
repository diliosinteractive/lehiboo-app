import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/message.dart';

class MessageBubble extends StatefulWidget {
  final Message message;
  final bool isLastOwn;
  final void Function(String messageUuid, String content)? onEdit;
  final void Function(String messageUuid)? onDelete;
  /// Logo URL of the organisation involved in the conversation.
  /// Used instead of the sender's personal avatar when senderType == 'organization'.
  final String? organizationLogoUrl;

  const MessageBubble({
    super.key,
    required this.message,
    this.isLastOwn = false,
    this.onEdit,
    this.onDelete,
    this.organizationLogoUrl,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool _isEditing = false;
  late TextEditingController _editController;

  static const _primaryColor = Color(0xFFFF601F);
  static const _bubbleOtherBg = Color(0xFFF2F2F7);

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

    final isOptimistic = msg.uuid.startsWith('temp-');

    return Opacity(
      opacity: isOptimistic ? 0.6 : 1.0,
      child: Align(
      alignment:
          msg.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: msg.isMine && !msg.isDeleted && !isOptimistic
            ? () => _showContextMenu(context)
            : null,
        child: Container(
          margin: EdgeInsets.only(
            left: msg.isMine ? 48 : 8,
            right: msg.isMine ? 8 : 48,
            top: 2,
            bottom: 2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!msg.isMine) ...[
                _buildAvatar(msg, isMine: false),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Column(
                  crossAxisAlignment: msg.isMine
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    // Sender name above non-own messages
                    if (!msg.isMine && msg.sender?.name.isNotEmpty == true)
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 3),
                        child: Text(
                          msg.sender!.name,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _primaryColor,
                          ),
                        ),
                      ),
                    _buildBubble(context, msg),
                    if (widget.isLastOwn && msg.isMine && !msg.isDeleted)
                      isOptimistic
                          ? const Padding(
                              padding: EdgeInsets.only(right: 4, top: 2),
                              child: SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    color: Colors.grey),
                              ),
                            )
                          : _buildDeliveryTicks(msg),
                  ],
                ),
              ),
              if (msg.isMine) ...[
                const SizedBox(width: 6),
                _buildAvatar(msg, isMine: true),
              ],
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildAvatar(Message msg, {required bool isMine}) {
    // Organisation messages → prefer the org logo; personal messages → sender avatar.
    final url = msg.senderType == 'organization'
        ? (widget.organizationLogoUrl?.isNotEmpty == true
            ? widget.organizationLogoUrl
            : msg.sender?.avatarUrl)
        : msg.sender?.avatarUrl;
    final name = msg.sender?.name ?? '';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final bg = isMine
        ? _primaryColor.withValues(alpha: 0.2)
        : _primaryColor.withValues(alpha: 0.12);

    if (url != null && url.isNotEmpty) {
      return CircleAvatar(
        radius: 15,
        backgroundColor: bg,
        backgroundImage: CachedNetworkImageProvider(url),
      );
    }
    return CircleAvatar(
      radius: 15,
      backgroundColor: bg,
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _primaryColor,
        ),
      ),
    );
  }

  Widget _buildBubble(BuildContext context, Message msg) {
    final isMine = msg.isMine;

    if (msg.isDeleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: _bubbleRadius(isMine),
        ),
        child: Text(
          'Ce message a été supprimé',
          style: TextStyle(
              color: Colors.grey.shade500,
              fontStyle: FontStyle.italic,
              fontSize: 13),
        ),
      );
    }

    if (_isEditing) {
      return _buildEditWidget(context);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isMine ? _primaryColor : _bubbleOtherBg,
        borderRadius: _bubbleRadius(isMine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text content
          if (msg.content != null && msg.content!.isNotEmpty)
            Text(
              msg.content!,
              style: TextStyle(
                color: isMine ? Colors.white : Colors.black87,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          // Metadata row
          const SizedBox(height: 3),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatTime(msg.createdAt),
                style: TextStyle(
                  fontSize: 10,
                  color: isMine
                      ? Colors.white.withValues(alpha: 0.65)
                      : Colors.grey.shade500,
                ),
              ),
              if (msg.isEdited) ...[
                const SizedBox(width: 4),
                Text(
                  '(modifié)',
                  style: TextStyle(
                    fontSize: 10,
                    color: isMine
                        ? Colors.white.withValues(alpha: 0.65)
                        : Colors.grey.shade500,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  BorderRadius _bubbleRadius(bool isMine) {
    const r = Radius.circular(18);
    const rSmall = Radius.circular(4);
    return isMine
        ? const BorderRadius.only(
            topLeft: r, topRight: r, bottomLeft: r, bottomRight: rSmall)
        : const BorderRadius.only(
            topLeft: r, topRight: r, bottomLeft: rSmall, bottomRight: r);
  }

  Widget _buildEditWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              width: 32,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Modifier'),
              onTap: () {
                Navigator.pop(ctx);
                setState(() => _isEditing = true);
              },
            ),
            if (widget.message.content?.isNotEmpty == true)
              ListTile(
                leading: const Icon(Icons.copy_outlined),
                title: const Text('Copier le texte'),
                onTap: () {
                  Navigator.pop(ctx);
                  Clipboard.setData(
                      ClipboardData(text: widget.message.content ?? ''));
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
