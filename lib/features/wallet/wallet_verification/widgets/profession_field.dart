// lib/widgets/app_dropdown_field.dart

import 'package:flutter/material.dart';

class AppDropdownField<T> extends StatefulWidget {
  final String? label;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  final double maxMenuHeight;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.value,
    this.maxMenuHeight = 260,
  });

  @override
  State<AppDropdownField<T>> createState() => _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T> extends State<AppDropdownField<T>> {
  final _layerLink = LayerLink();
  final _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void dispose() {
    // Remove overlay directly — calling setState during dispose crashes
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _toggleMenu() => _isOpen ? _removeOverlay() : _showOverlay();

  void _showOverlay() {
    final renderBox = _fieldKey.currentContext!.findRenderObject() as RenderBox;
    final fieldWidth = renderBox.size.width;
    final fieldHeight = renderBox.size.height;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _removeOverlay,
            ),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, fieldHeight + 6),
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: fieldWidth,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: widget.maxMenuHeight,
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: widget.items.length,
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        return InkWell(
                          onTap: () {
                            widget.onChanged(item);
                            _removeOverlay();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            child: Text(
                              widget.itemLabel(item),
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _isOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label!,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 6),
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            key: _fieldKey,
            onTap: _toggleMenu,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: _isOpen
                    ? Border.all(color: const Color(0xFF2F80ED), width: 1.5)
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.value != null
                          ? widget.itemLabel(widget.value as T)
                          : widget.hint,
                      style: TextStyle(
                        fontSize: 15,
                        color: widget.value != null
                            ? const Color(0xFF1A1A1A)
                            : Colors.black54,
                      ),
                    ),
                  ),
                  Icon(
                    _isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
