import 'package:flutter/material.dart';

/// Widget that displays text with a typing cursor animation
class StreamingText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final bool showCursor;
  final Duration cursorBlinkDuration;

  const StreamingText({
    super.key,
    required this.text,
    this.style,
    this.showCursor = true,
    this.cursorBlinkDuration = const Duration(milliseconds: 500),
  });

  @override
  State<StreamingText> createState() => _StreamingTextState();
}

class _StreamingTextState extends State<StreamingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _cursorController;
  late Animation<double> _cursorOpacity;

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      vsync: this,
      duration: widget.cursorBlinkDuration,
    );
    _cursorOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _cursorController, curve: Curves.easeInOut),
    );
    _cursorController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style;
    final effectiveStyle = widget.style ?? defaultStyle;

    return RichText(
      text: TextSpan(
        style: effectiveStyle,
        children: [
          TextSpan(text: widget.text),
          if (widget.showCursor)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: AnimatedBuilder(
                animation: _cursorOpacity,
                builder: (context, child) => Opacity(
                  opacity: _cursorOpacity.value,
                  child: Container(
                    width: 2,
                    height: effectiveStyle.fontSize ?? 16,
                    margin: const EdgeInsets.only(left: 2),
                    color: effectiveStyle.color ?? Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Animated text that types out character by character
class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration characterDuration;
  final VoidCallback? onComplete;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.characterDuration = const Duration(milliseconds: 30),
    this.onComplete,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _characterCount;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void didUpdateWidget(TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _controller.dispose();
      _initAnimation();
    }
  }

  void _initAnimation() {
    final duration = widget.characterDuration * widget.text.length;
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );
    _characterCount = IntTween(
      begin: 0,
      end: widget.text.length,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _characterCount,
      builder: (context, child) {
        final displayedText = widget.text.substring(0, _characterCount.value);
        return StreamingText(
          text: displayedText,
          style: widget.style,
          showCursor: _characterCount.value < widget.text.length,
        );
      },
    );
  }
}
