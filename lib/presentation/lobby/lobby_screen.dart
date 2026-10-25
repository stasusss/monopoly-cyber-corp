import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/cyber_theme.dart';
import '../../logic/game_controller.dart';
import '../../logic/network/lobby_controller.dart';
import '../../logic/network/network_action.dart';
import '../../logic/network/network_providers.dart';
import '../../models/player.dart';
import '../shell/game_shell_page.dart';

extension NeonTokenX on TokenColor {
  String get neonHandle => switch (this) {
        TokenColor.red => 'CRIMSON ICE',
        TokenColor.blue => 'NEON CYAN',
        TokenColor.green => 'TOXIC GRID',
        TokenColor.yellow => 'CORPO GOLD',
      };

  Color get neonPaint => switch (this) {
        TokenColor.red => CyberColors.neonMagenta,
        TokenColor.blue => CyberColors.neonCyan,
        TokenColor.green => CyberColors.terminalGreen,
        TokenColor.yellow => CyberColors.cyberYellow,
      };
}

/// Cyberpunk waiting hall — create / join room, ready-up, host launches game.
class LobbyScreen extends ConsumerStatefulWidget {
  const LobbyScreen({super.key});

  @override
  ConsumerState<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends ConsumerState<LobbyScreen> {
  final _nickCtrl = TextEditingController(text: 'NETRUNNER');
  final _joinCtrl = TextEditingController();
  var _didAutoJoin = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeDeepLink());
  }

  Future<void> _maybeDeepLink() async {
    if (_didAutoJoin) return;
    final deep = ref.read(lobbyControllerProvider).deepLinkRoom;
    if (deep == null) return;
    _didAutoJoin = true;
    _joinCtrl.text = deep;
    await ref.read(lobbyControllerProvider.notifier).joinDeepLinkIfPresent();
  }

  @override
  void dispose() {
    _nickCtrl.dispose();
    _joinCtrl.dispose();
    super.dispose();
  }

  void _goSolo() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const GameShellPage()),
    );
  }

  void _bindOnlineSession() {
    final lobby = ref.read(lobbyControllerProvider);
    final localId = lobby.localPlayerId;
    if (localId == null) return;
    ref.read(gameControllerProvider.notifier).bindOnline(
          localPlayerId: localId,
          realtime: ref.read(realtimeServiceProvider),
        );
  }

  Future<void> _hostStartMatch() async {
    // Announce start first so peers leave the waiting hall, then seed state.
    await ref.read(lobbyControllerProvider.notifier).startGame();
    _bindOnlineSession();
    final lobby = ref.read(lobbyControllerProvider);
    if (lobby.isHost) {
      ref
          .read(gameControllerProvider.notifier)
          .bootstrapOnlineRoster(lobby.members);
    }
  }

  void _goOnlineGame() {
    _bindOnlineSession();
    ref.read(lobbyControllerProvider.notifier).consumeStart();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const GameShellPage()),
    );
  }

  Future<void> _copyInvite() async {
    final url = ref.read(lobbyControllerProvider).shareUrl;
    if (url == null) return;
    await Clipboard.setData(ClipboardData(text: url));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: CyberColors.panel,
        content: Text(
          'LINK COPIED FOR CHUMS',
          style: GoogleFonts.shareTechMono(color: CyberColors.terminalGreen),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LobbyState>(lobbyControllerProvider, (prev, next) {
      if (next.phase == LobbyPhase.starting &&
          prev?.phase != LobbyPhase.starting) {
        _goOnlineGame();
      }
    });

    final lobby = ref.watch(lobbyControllerProvider);

    return Scaffold(
      backgroundColor: CyberColors.voidBlack,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              CyberColors.voidBlack,
              CyberColors.deepIndigo,
              Color(0xFF0D1220),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: switch (lobby.phase) {
                  LobbyPhase.connecting => const _ConnectingPane(),
                  LobbyPhase.room || LobbyPhase.starting => _RoomPane(
                      lobby: lobby,
                      onCopy: _copyInvite,
                      onReady: () => ref
                          .read(lobbyControllerProvider.notifier)
                          .toggleReady(),
                      onStart: _hostStartMatch,
                      onLeave: () => ref
                          .read(lobbyControllerProvider.notifier)
                          .leaveRoom(),
                    ),
                  LobbyPhase.entry || LobbyPhase.error => _EntryPane(
                      nickCtrl: _nickCtrl,
                      joinCtrl: _joinCtrl,
                      lobby: lobby,
                      onNick: (v) => ref
                          .read(lobbyControllerProvider.notifier)
                          .setNickname(v),
                      onColor: (c) => ref
                          .read(lobbyControllerProvider.notifier)
                          .setTokenColor(c),
                      onCreate: () {
                        ref
                            .read(lobbyControllerProvider.notifier)
                            .setNickname(_nickCtrl.text);
                        return ref
                            .read(lobbyControllerProvider.notifier)
                            .createRoom();
                      },
                      onJoin: () {
                        ref
                            .read(lobbyControllerProvider.notifier)
                            .setNickname(_nickCtrl.text);
                        return ref
                            .read(lobbyControllerProvider.notifier)
                            .joinRoom(_joinCtrl.text);
                      },
                      onSolo: _goSolo,
                    ),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConnectingPane extends StatelessWidget {
  const _ConnectingPane();

  @override
  Widget build(BuildContext context) {
    return CyberTheme.glass(
      glowColor: CyberColors.neonCyan,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ESTABLISHING UPLINK…',
            style: GoogleFonts.orbitron(
              color: CyberColors.neonCyan,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          const LinearProgressIndicator(
            color: CyberColors.neonCyan,
            backgroundColor: CyberColors.panel,
          ),
        ],
      ),
    );
  }
}

class _EntryPane extends StatelessWidget {
  const _EntryPane({
    required this.nickCtrl,
    required this.joinCtrl,
    required this.lobby,
    required this.onNick,
    required this.onColor,
    required this.onCreate,
    required this.onJoin,
    required this.onSolo,
  });

  final TextEditingController nickCtrl;
  final TextEditingController joinCtrl;
  final LobbyState lobby;
  final ValueChanged<String> onNick;
  final ValueChanged<TokenColor> onColor;
  final Future<void> Function() onCreate;
  final Future<void> Function() onJoin;
  final VoidCallback onSolo;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CyberTheme.glass(
        glowColor: CyberColors.neonMagenta,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              CyberLore.appTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.orbitron(
                color: CyberColors.neonCyan,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: CyberColors.neonCyan.withValues(alpha: 0.7),
                    blurRadius: 14,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'MULTIPLAYER LOBBY · PEER-HOST',
              textAlign: TextAlign.center,
              style: GoogleFonts.shareTechMono(
                color: CyberColors.textMuted,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
            if (lobby.errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                lobby.errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.shareTechMono(
                  color: CyberColors.neonMagenta,
                  fontSize: 12,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Text(
              'CALLSIGN',
              style: GoogleFonts.shareTechMono(
                color: CyberColors.cyberYellow,
                fontSize: 11,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: nickCtrl,
              onChanged: onNick,
              textCapitalization: TextCapitalization.characters,
              style: GoogleFonts.rajdhani(
                color: CyberColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
              decoration: InputDecoration(
                hintText: 'NETRUNNER',
                filled: true,
                fillColor: CyberColors.panel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: CyberColors.neonCyan),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: CyberColors.neonCyan.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'NEON TOKEN',
              style: GoogleFonts.shareTechMono(
                color: CyberColors.cyberYellow,
                fontSize: 11,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: TokenColor.values.map((c) {
                final selected = lobby.tokenColor == c;
                return InkWell(
                  onTap: () => onColor(c),
                  borderRadius: BorderRadius.circular(24),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: CyberColors.panel,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: selected
                            ? c.neonPaint
                            : CyberColors.gridLine,
                        width: selected ? 2 : 1,
                      ),
                      boxShadow: selected
                          ? CyberTheme.glow(c.neonPaint, blur: 10)
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: c.neonPaint,
                            boxShadow: CyberTheme.glow(c.neonPaint, blur: 6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          c.neonHandle,
                          style: GoogleFonts.shareTechMono(
                            color: CyberColors.textPrimary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add_link),
              label: const Text('OPEN NEW NODE'),
            ),
            const SizedBox(height: 16),
            Text(
              'OR JACK INTO EXISTING ROOM',
              textAlign: TextAlign.center,
              style: GoogleFonts.shareTechMono(
                color: CyberColors.textMuted,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: joinCtrl,
              textCapitalization: TextCapitalization.characters,
              style: GoogleFonts.shareTechMono(color: CyberColors.neonCyan),
              decoration: InputDecoration(
                hintText: 'NEON-73',
                hintStyle: GoogleFonts.shareTechMono(
                  color: CyberColors.textMuted,
                ),
                filled: true,
                fillColor: CyberColors.panel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: onJoin,
              icon: const Icon(Icons.lan),
              label: const Text('JOIN ROOM'),
              style: OutlinedButton.styleFrom(
                foregroundColor: CyberColors.cyberYellow,
                side: const BorderSide(color: CyberColors.cyberYellow),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: onSolo,
              child: Text(
                'SOLO OFFLINE PROTOCOL →',
                style: GoogleFonts.shareTechMono(
                  color: CyberColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomPane extends StatelessWidget {
  const _RoomPane({
    required this.lobby,
    required this.onCopy,
    required this.onReady,
    required this.onStart,
    required this.onLeave,
  });

  final LobbyState lobby;
  final VoidCallback onCopy;
  final VoidCallback onReady;
  final VoidCallback onStart;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    final slots = List<PresenceMember?>.filled(LobbyController.maxPlayers, null);
    for (var i = 0; i < lobby.members.length && i < slots.length; i++) {
      slots[i] = lobby.members[i];
    }

    final overfull = lobby.members.length > LobbyController.maxPlayers;

    return SingleChildScrollView(
      child: CyberTheme.glass(
        glowColor: CyberColors.neonCyan,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'WAITING HALL',
              textAlign: TextAlign.center,
              style: GoogleFonts.orbitron(
                color: CyberColors.neonCyan,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'ROOM ${lobby.roomCode ?? '—'}',
              textAlign: TextAlign.center,
              style: GoogleFonts.shareTechMono(
                color: CyberColors.cyberYellow,
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
            if (lobby.isHost)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'YOU ARE THE COORDINATOR',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.shareTechMono(
                    color: CyberColors.terminalGreen,
                    fontSize: 11,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: onCopy,
              icon: const Icon(Icons.copy_all),
              label: const Text('СКОПІЮВАТИ ЛІНК ДЛЯ ЧУМБ'),
              style: FilledButton.styleFrom(
                backgroundColor: CyberColors.panelElevated,
                foregroundColor: CyberColors.neonCyan,
              ),
            ),
            if (lobby.shareUrl != null) ...[
              const SizedBox(height: 8),
              SelectableText(
                lobby.shareUrl!,
                textAlign: TextAlign.center,
                style: GoogleFonts.shareTechMono(
                  color: CyberColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Text(
              'OPERATIVES  ${lobby.occupiedSlots}/${LobbyController.maxPlayers}',
              style: GoogleFonts.shareTechMono(
                color: CyberColors.cyberYellow,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
            if (overfull)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'WARNING · ROOM OVER CAPACITY',
                  style: GoogleFonts.shareTechMono(
                    color: CyberColors.neonMagenta,
                    fontSize: 11,
                  ),
                ),
              ),
            const SizedBox(height: 10),
            ...List.generate(slots.length, (i) {
              final m = slots[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _SlotCard(index: i + 1, member: m),
              );
            }),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onReady,
              icon: Icon(
                lobby.ready ? Icons.check_circle : Icons.radio_button_unchecked,
              ),
              label: Text(lobby.ready ? 'READY' : 'MARK READY'),
              style: OutlinedButton.styleFrom(
                foregroundColor: lobby.ready
                    ? CyberColors.terminalGreen
                    : CyberColors.textPrimary,
                side: BorderSide(
                  color: lobby.ready
                      ? CyberColors.terminalGreen
                      : CyberColors.gridLine,
                ),
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: lobby.canStart ? onStart : null,
              icon: const Icon(Icons.rocket_launch),
              label: const Text('ЗАПУСТИТИ ПОГЛИНАННЯ'),
            ),
            if (!lobby.isHost)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'WAITING FOR HOST TO LAUNCH…',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.shareTechMono(
                    color: CyberColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              )
            else if (lobby.members.length < LobbyController.minPlayers)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'NEED ≥${LobbyController.minPlayers} OPERATIVES',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.shareTechMono(
                    color: CyberColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ),
            TextButton(
              onPressed: onLeave,
              child: Text(
                'DISCONNECT',
                style: GoogleFonts.shareTechMono(
                  color: CyberColors.neonMagenta,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlotCard extends StatelessWidget {
  const _SlotCard({required this.index, required this.member});

  final int index;
  final PresenceMember? member;

  @override
  Widget build(BuildContext context) {
    final empty = member == null;
    final token = empty
        ? null
        : TokenColor.values.where((c) => c.name == member!.tokenColor).firstOrNull;
    final color = empty ? CyberColors.gridLine : (token ?? TokenColor.blue).neonPaint;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: CyberTheme.neonBorder(
        color: empty ? CyberColors.gridLine : color,
        fill: CyberColors.panel,
        opacity: empty ? 0.4 : 0.9,
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color),
              color: empty ? Colors.transparent : color.withValues(alpha: 0.25),
            ),
            child: Text(
              empty ? '?' : member!.name.characters.first,
              style: GoogleFonts.orbitron(
                color: empty ? CyberColors.textMuted : color,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  empty ? 'SLOT $index · EMPTY' : member!.name,
                  style: GoogleFonts.rajdhani(
                    color: CyberColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  empty
                      ? 'AWAITING SIGNAL'
                      : [
                          if (member!.isHost) 'HOST',
                          if (member!.ready) 'READY',
                          if (!member!.ready) 'STANDBY',
                        ].join(' · '),
                  style: GoogleFonts.shareTechMono(
                    color: member?.ready == true
                        ? CyberColors.terminalGreen
                        : CyberColors.textMuted,
                    fontSize: 11,
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
