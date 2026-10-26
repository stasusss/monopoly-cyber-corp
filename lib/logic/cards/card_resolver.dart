import '../../core/constants/game_rules.dart';
import '../../models/cell.dart';
import '../../models/game_state.dart';
import '../../models/pending_action.dart';
import '../../models/player.dart';
import 'game_card.dart';

/// Result of applying a deck card to the active player.
class CardApplication {
  const CardApplication({
    required this.state,
    this.reresolveCell = false,
    this.wentToJail = false,
    this.salaryGranted = 0,
  });

  final GameState state;
  final bool reresolveCell;
  final bool wentToJail;

  /// Cycle Reset credits collected by a relocation. The controller applies
  /// them so syndicate installments can skim the same payout.
  final int salaryGranted;
}

abstract final class CardResolver {
  static CardApplication apply(GameState state, GameCard card) {
    var s = state;
    Player active() => s.activePlayer;

    List<Player> rep(Player p) => [
          for (final x in s.players)
            if (x.id == p.id) p else x,
        ];

    void setNotice(String detail) {
      s = s.copyWith(
        phase: TurnPhase.cellAction,
        pendingAction: PendingAction.cardNotice(
          title: card.title,
          description: '${card.description}\n($detail)',
        ),
        log: [...s.log, '[${card.title}] ${active().name}: $detail'],
      );
    }

    switch (card.effect) {
      case CardEffectType.gainMoney:
        final p = active().copyWith(balance: active().balance + card.amount);
        s = s.copyWith(players: rep(p));
        setNotice('+₵${card.amount}');
      case CardEffectType.loseMoney:
        final paid = _tryPay(s, card.amount, rep);
        s = paid;
        setNotice('-₵${card.amount}');
      case CardEffectType.getOutOfJail:
        final p = active().copyWith(
          getOutOfJailCards: active().getOutOfJailCards + 1,
          jailCardSources: [...active().jailCardSources, card.deck.name],
        );
        s = s.copyWith(players: rep(p));
        setNotice('ICE nullifier acquired');
      case CardEffectType.goToJail:
        final p = active().copyWith(
          position: GameRules.jailIndex,
          inJail: true,
          jailTurns: 0,
        );
        s = s.copyWith(
          players: rep(p),
          consecutiveDoubles: 0,
          phase: TurnPhase.cellAction,
          pendingAction: PendingAction.cardNotice(
            title: card.title,
            description: card.description,
          ),
          log: [...s.log, '[${card.title}] ${p.name} → ICE LOCKDOWN'],
        );
        return CardApplication(state: s, wentToJail: true);
      case CardEffectType.moveTo:
        final moved = _relocate(s, card.targetIndex ?? 0, rep);
        s = moved.$1;
        setNotice('relocated → ${card.targetIndex}');
        return CardApplication(
          state: s,
          reresolveCell: true,
          salaryGranted: moved.$2,
        );
      case CardEffectType.moveRelative:
        var t = (active().position + card.amount) % GameRules.boardSize;
        if (t < 0) t += GameRules.boardSize;
        final moved = _relocate(s, t, rep, collectGo: card.amount > 0);
        s = moved.$1;
        setNotice('offset ${card.amount}');
        return CardApplication(
          state: s,
          reresolveCell: true,
          salaryGranted: moved.$2,
        );
      case CardEffectType.collectFromEach:
        var gain = 0;
        var players = [...s.players];
        final meId = active().id;
        for (var i = 0; i < players.length; i++) {
          final o = players[i];
          if (o.id == meId || o.isBankrupt) continue;
          final pay = card.amount.clamp(0, o.balance);
          gain += pay;
          players[i] = o.copyWith(balance: o.balance - pay);
        }
        final mi = players.indexWhere((p) => p.id == meId);
        players[mi] =
            players[mi].copyWith(balance: players[mi].balance + gain);
        s = s.copyWith(players: players);
        setNotice('collected ₵$gain');
      case CardEffectType.payEach:
        final n = s.livingPlayers.where((p) => p.id != active().id).length;
        final transferred = _payEach(s, card.amount, rep);
        s = transferred;
        setNotice('paid each ₵${card.amount} × $n');
      case CardEffectType.ledgerLeak:
        s = _swapWithPoorest(s, rep);
        setNotice('stacks swapped');
      case CardEffectType.eminentDomain:
        setNotice('district claim');
      case CardEffectType.repairs:
        var cost = 0;
        for (final i in active().propertyIndexes) {
          final cell = s.cellAt(i);
          if (cell is! PropertyCell) continue;
          cost += cell.houses >= 5
              ? (card.amount == 25 ? 100 : 115)
              : cell.houses * card.amount;
        }
        s = _tryPay(s, cost, rep);
        setNotice('repairs ₵$cost');
      case CardEffectType.nearestRailroad:
        final moved =
            _relocate(s, _next(active().position, const [5, 15, 25, 35]), rep);
        s = moved.$1.copyWith(nextRentMultiplier: 2);
        setNotice('nearest Maglev · double fare');
        return CardApplication(
          state: s,
          reresolveCell: true,
          salaryGranted: moved.$2,
        );
      case CardEffectType.nearestUtility:
        final moved =
            _relocate(s, _next(active().position, const [12, 28]), rep);
        s = moved.$1.copyWith(nextUtilityFlatTen: true);
        setNotice('nearest utility · 10× dice');
        return CardApplication(
          state: s,
          reresolveCell: true,
          salaryGranted: moved.$2,
        );
    }
    return CardApplication(state: s);
  }

  static int _next(int from, List<int> targets) {
    for (var step = 1; step <= 40; step++) {
      final i = (from + step) % 40;
      if (targets.contains(i)) return i;
    }
    return targets.first;
  }

  /// Returns the updated state and any Cycle Reset salary the move earned.
  /// Salary is not added here.
  static (GameState, int) _relocate(
    GameState s,
    int target,
    List<Player> Function(Player) rep, {
    bool collectGo = true,
  }) {
    final p = s.activePlayer;
    var salary = 0;
    if (collectGo && target != p.position) {
      final passedOrLandedGo = target < p.position || target == 0;
      if (passedOrLandedGo) salary = GameRules.goSalary;
    }
    return (
      s.copyWith(players: rep(p.copyWith(position: target))),
      salary,
    );
  }

  static GameState _payEach(
    GameState s,
    int each,
    List<Player> Function(Player) rep,
  ) {
    if (each <= 0) return s;
    var payer = s.activePlayer;
    final players = [...s.players];
    for (var i = 0; i < players.length; i++) {
      final other = players[i];
      if (other.id == payer.id || other.isBankrupt) continue;
      final pay = each <= payer.balance ? each : payer.balance;
      if (pay <= 0) break;
      payer = payer.copyWith(balance: payer.balance - pay);
      players[i] = other.copyWith(balance: other.balance + pay);
    }
    final mi = players.indexWhere((p) => p.id == payer.id);
    players[mi] = payer;
    return s.copyWith(players: players);
  }

  static GameState _swapWithPoorest(
    GameState s,
    List<Player> Function(Player) rep,
  ) {
    final me = s.activePlayer;
    Player? poorest;
    for (final p in s.livingPlayers) {
      if (p.id == me.id) continue;
      if (poorest == null || p.balance < poorest.balance) poorest = p;
    }
    if (poorest == null || poorest.balance == me.balance) return s;
    final them = poorest;
    var players = rep(me.copyWith(balance: them.balance));
    final ti = players.indexWhere((p) => p.id == them.id);
    players[ti] = them.copyWith(balance: me.balance);
    return s.copyWith(players: players);
  }

  static GameState _tryPay(
    GameState s,
    int amount,
    List<Player> Function(Player) rep,
  ) {
    final p = s.activePlayer;
    if (amount <= 0) return s;
    if (p.balance < amount) {
      return s.copyWith(players: rep(p.copyWith(balance: 0)));
    }
    return s.copyWith(players: rep(p.copyWith(balance: p.balance - amount)));
  }
}
