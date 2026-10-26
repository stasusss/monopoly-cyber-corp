import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/cyber_theme.dart';
import '../../logic/trade/trade_manager.dart';
import '../../models/cell.dart';
import '../../models/player.dart';
import 'cyber_dialog_frame.dart';

Future<TradeOffer?> showTradeComposer(
  BuildContext context, {
  required Player from,
  required List<Player> opponents,
  required List<BoardCell> board,
}) {
  return showDialog<TradeOffer>(
    context: context,
    builder: (ctx) => _Composer(
      from: from,
      opponents: opponents,
      board: board,
    ),
  );
}

class _Composer extends StatefulWidget {
  const _Composer({
    required this.from,
    required this.opponents,
    required this.board,
  });

  final Player from;
  final List<Player> opponents;
  final List<BoardCell> board;

  @override
  State<_Composer> createState() => _ComposerState();
}

class _ComposerState extends State<_Composer> {
  late String _toId = widget.opponents.first.id;
  final _offerCash = TextEditingController();
  final _requestCash = TextEditingController();
  final _offer = <int>{};
  final _request = <int>{};

  @override
  void dispose() {
    _offerCash.dispose();
    _requestCash.dispose();
    super.dispose();
  }

  Player get _to => widget.opponents.firstWhere((p) => p.id == _toId);

  bool _tradable(int index) {
    final cell = widget.board[index];
    if (cell is PropertyCell && cell.houses > 0) return false;
    return true;
  }

  void _send() {
    final offer = TradeOffer(
      fromPlayerId: widget.from.id,
      toPlayerId: _toId,
      offerCash: int.tryParse(_offerCash.text.trim()) ?? 0,
      requestCash: int.tryParse(_requestCash.text.trim()) ?? 0,
      offerProperties: _offer.toList(),
      requestProperties: _request.toList(),
    );
    if (offer.offerCash == 0 &&
        offer.requestCash == 0 &&
        offer.offerProperties.isEmpty &&
        offer.requestProperties.isEmpty) {
      return;
    }
    Navigator.pop(context, offer);
  }

  @override
  Widget build(BuildContext context) {
    return CyberDialogFrame(
      glowColor: CyberColors.neonCyan,
      maxWidth: 420,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'TRADE PROTOCOL',
            style: GoogleFonts.orbitron(
              color: CyberColors.neonCyan,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: _toId,
            isExpanded: true,
            dropdownColor: CyberColors.panel,
            items: [
              for (final p in widget.opponents)
                DropdownMenuItem(value: p.id, child: Text(p.name)),
            ],
            onChanged: (id) {
              if (id == null) return;
              setState(() {
                _toId = id;
                _request.clear();
              });
            },
          ),
          const SizedBox(height: 8),
          Text('YOU GIVE', style: GoogleFonts.shareTechMono(fontSize: 12)),
          _cashField(_offerCash, 'Offer cash'),
          _checks(widget.from.propertyIndexes, _offer),
          const SizedBox(height: 8),
          Text(
            '${_to.name.toUpperCase()} GIVES',
            style: GoogleFonts.shareTechMono(fontSize: 12),
          ),
          _cashField(_requestCash, 'Request cash'),
          _checks(_to.propertyIndexes, _request),
        ],
      ),
      actions: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FilledButton(
              onPressed: _send,
              child: const Text('SEND'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cashField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: GoogleFonts.shareTechMono(color: CyberColors.textPrimary),
      decoration: InputDecoration(labelText: label, isDense: true),
    );
  }

  Widget _checks(List<int> indexes, Set<int> selected) {
    final tradable = indexes.where(_tradable).toList();
    if (tradable.isEmpty) {
      return Text(
        'No bare assets',
        style: GoogleFonts.shareTechMono(
          color: CyberColors.textMuted,
          fontSize: 12,
        ),
      );
    }
    return Wrap(
      spacing: 6,
      children: [
        for (final index in tradable)
          FilterChip(
            label: Text(widget.board[index].name),
            selected: selected.contains(index),
            onSelected: (on) {
              setState(() {
                if (on) {
                  selected.add(index);
                } else {
                  selected.remove(index);
                }
              });
            },
          ),
      ],
    );
  }
}
