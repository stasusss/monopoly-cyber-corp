import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/cards/game_card.dart';
import '../../models/ai_profile.dart';
import '../constants/street_colors.dart';
import 'app_lang.dart';

/// Current interface copy. Call from a widget whose ancestor watches [appLangProvider].
AppStrings stringsOf(BuildContext context) =>
    AppStrings(ProviderScope.containerOf(context).read(appLangProvider));

/// Every player-facing string. Street names stay proper nouns.
class AppStrings {
  const AppStrings(this.lang);

  final AppLang lang;

  bool get uk => lang == AppLang.uk;

  String pick(String en, String ua) => uk ? ua : en;

  String get appSubtitle =>
      pick('Night City Asset Protocol', 'Протокол активів Найт-Сіті');

  String get roll => pick('ROLL', 'КИДОК');
  String get endTurn => pick('END TURN', 'КІНЕЦЬ ХОДУ');
  String get endShort => pick('END', 'КІНЕЦЬ');
  String get trade => pick('TRADE', 'ОБМІН');
  String loan(String amount) => pick('LOAN $amount', 'ПОЗИКА $amount');
  String get claim => pick('CLAIM', 'ВИКУП');
  String nullifier(int n) => pick('NULLIFIER ×$n', 'НУЛЬНИК ×$n');
  String bail(String amount) => pick('BAIL $amount', 'ЗАСТАВА $amount');

  String get decline => pick('DECLINE', 'ВІДМОВА');
  String get acquire => pick('ACQUIRE', 'КУПИТИ');
  String get ack => pick('ACK', 'ГАРАЗД');
  String get acknowledge => pick('ACKNOWLEDGE', 'ЗРОЗУМІЛО');
  String get accept => pick('ACCEPT', 'ПРИЙНЯТИ');
  String get reboot => pick('REBOOT', 'ЗАНОВО');
  String get close => pick('CLOSE', 'ЗАКРИТИ');
  String get cancel => pick('CANCEL', 'СКАСУВАТИ');
  String get send => pick('SEND', 'НАДІСЛАТИ');
  String get bid => pick('BID', 'СТАВКА');
  String get pass => pick('PASS', 'ПАС');

  String get rebootSession => pick('REBOOT SESSION', 'НОВА СЕСІЯ');
  String get operatives => pick('OPERATIVES', 'ГРАВЦІ');
  String get rotateTitle => pick('ROTATE TO PORTRAIT', 'ПОВЕРНІТЬ ЕКРАН');
  String get rotateBody => pick(
        'Turn the device upright or make the window taller. '
        'In a short landscape frame the cells become unreadable.',
        'Поверніть пристрій вертикально або збільште висоту вікна. '
        'У короткому альбомному кадрі клітинки стають нечитабельними.',
      );

  String roundLine(int round, int limit, int racks, int hotels) => pick(
        'ROUND $round/$limit · RACKS $racks · HQ $hotels',
        'РАУНД $round/$limit · СТІЙКИ $racks · ШТАБ $hotels',
      );

  String activeLine(String name, bool inJail) => pick(
        'ACTIVE: $name${inJail ? ' · ICE LOCK' : ''}',
        'ХІД: $name${inJail ? ' · У В\'ЯЗНИЦІ' : ''}',
      );

  String get holographicDeed => pick('HOLOGRAPHIC DEED', 'ГОЛОДЕКРЕТ');
  String claimAsk(String name) =>
      pick('Claim «$name»?', 'Забрати «$name»?');
  String yourStack(String amount) =>
      pick('YOUR STACK $amount', 'ТВІЙ СТЕК $amount');
  String get rentExtracted => pick('RENT EXTRACTED', 'ОРЕНДУ ЗНЯТО');
  String rentBody(String payer, String amount, String owner, String node) =>
      pick(
        '$payer → $amount → $owner\nnode: «$node»',
        '$payer → $amount → $owner\nвузол: «$node»',
      );
  String taxBody(String player, String amount) => pick(
        '$player transfers $amount to the Bank.',
        '$player переказує $amount банку.',
      );
  String get eminentDomain => pick('EMINENT DOMAIN', 'ПРИМУСОВИЙ ВИКУП');
  String get seizeHint => pick(
        'Seize one exposed street for 120% of list price.',
        'Забери одну відкриту вулицю за 120% від ціни.',
      );
  String get protocolComplete => pick('PROTOCOL COMPLETE', 'ПРОТОКОЛ ЗАВЕРШЕНО');
  String winnerBody(String name, String net) => pick(
        'Controlling interest: $name\nNET $net',
        'Контрольний пакет: $name\nВАРТІСТЬ $net',
      );

  String get tradeProtocol => pick('TRADE PROTOCOL', 'ПРОТОКОЛ ОБМІНУ');
  String offers(String name) => pick('$name offers:', '$name дає:');
  String requestsFrom(String name) =>
      pick('Requests from $name:', 'Просить у $name:');
  String get noStreets => pick('no streets', 'без вулиць');
  String get youGive => pick('YOU GIVE', 'ТИ ДАЄШ');
  String gives(String name) =>
      pick('${name.toUpperCase()} GIVES', '${name.toUpperCase()} ДАЄ');
  String get offerCash => pick('Offer cash', 'Запропонувати кредити');
  String get requestCash => pick('Request cash', 'Попросити кредити');
  String get noProperties => pick('No properties', 'Немає власності');
  String get noBidsYet => pick('No bids yet', 'Ставок ще немає');
  String get liveAuction => pick('LIVE AUCTION', 'ЖИВИЙ АУКЦІОН');
  String get eventStream => pick('EVENT STREAM', 'СТРІЧКА ПОДІЙ');
  String get oneGrid => pick('1 GRID', '1 МЕРЕЖА');
  String get twoGrids => pick('2 GRIDS', '2 МЕРЕЖІ');
  String get unknown => pick('UNKNOWN', 'НЕВІДОМО');

  String get auction => pick('AUCTION', 'АУКЦІОН');
  String auctionHigh(String amount, String? leader) => pick(
        'High: $amount${leader == null ? '' : ' · $leader'}',
        'Лідер: $amount${leader == null ? '' : ' · $leader'}',
      );
  String yourBid(String name) => pick('Your bid, $name', 'Твоя ставка, $name');
  String waitingOn(String name) =>
      pick('Waiting on $name', 'Чекаємо на $name');
  String minimumBid(String amount) =>
      pick('Minimum $amount · pass sticks', 'Мінімум $amount · пас остаточний');
  String get yourBidField => pick('YOUR BID', 'ТВОЯ СТАВКА');
  String get waitingForBidder =>
      pick('Waiting for bidder…', 'Чекаємо на учасника…');

  String get swipeNodes => pick('SWIPE · NEIGHBOR NODES', 'ГОРТАЙ · СУСІДНІ ВУЗЛИ');
  String get unclaimed => pick('UNCLAIMED', 'ВІЛЬНА');
  String ownerLine(String name) => pick('OWNER · $name', 'ВЛАСНИК · $name');
  String get mortgagedIce => pick('MORTGAGED · ICE', 'У ЗАСТАВІ');
  String mortgageValue(String amount) =>
      pick('MORTGAGE VALUE $amount', 'СУМА ЗАСТАВИ $amount');
  String get base => pick('BASE', 'БАЗА');
  String rackTimes(int n) => pick('RACK ×$n', 'СТІЙКА ×$n');
  String get hq => pick('HQ', 'ШТАБ');
  String lines(int n) =>
      pick('$n LINE${n == 1 ? '' : 'S'}', '$n ЛІНІ${n == 1 ? 'Я' : 'Ї'}');
  String diceTimes(int n) => pick('×$n DICE', '×$n КУБИКИ');

  String buildingTier(int houses) => switch (houses) {
        0 => pick('UNDEVELOPED', 'БЕЗ ЗАБУДОВИ'),
        1 => pick('DATA RACK ×1', 'СТІЙКА ×1'),
        2 => pick('DATA RACK ×2', 'СТІЙКА ×2'),
        3 => pick('DATA RACK ×3', 'СТІЙКА ×3'),
        4 => pick('DATA RACK ×4', 'СТІЙКА ×4'),
        _ => pick('MEGACORP HQ', 'ШТАБ МЕГАКОРП'),
      };

  String districtProgress(int owned, int total, bool locked) => locked
      ? pick('DISTRICT LOCKED · $total/$total', 'РАЙОН ЗІБРАНО · $total/$total')
      : pick(
          'DISTRICT · $owned/$total · RACKS NEED THE FULL SET',
          'РАЙОН · $owned/$total · СТІЙКИ ЛИШЕ НА ПОВНИЙ НАБІР',
        );

  String gapMortgaged(String name) =>
      pick('$name (mortgaged)', '$name (у заставі)');
  String gapUnclaimed(String name) =>
      pick('$name (unclaimed)', '$name (вільна)');

  String rackStandHint(String district, String list) => pick(
        'Where your token stands does not matter. '
        'Racks need every node in $district'
        '${list.isEmpty ? '.' : ': $list.'}',
        'Де стоїть фішка — байдуже. '
        'Стійки потребують кожен вузол району $district'
        '${list.isEmpty ? '.' : ': $list.'}',
      );

  String buildEvenly(String district, String behind) => pick(
        'Build evenly across $district. The next rack goes on $behind.',
        'Будуй рівномірно в районі $district. Наступна стійка — на $behind.',
      );

  String get notYourNode => pick('Not your node.', 'Це не твій вузол.');
  String get liftBeforeRack => pick(
        'This node is under ICE. Lift the mortgage before installing a rack.',
        'Вузол у заставі. Спочатку зніми її, потім став стійку.',
      );
  String get hqOnline => pick('HQ is already online.', 'Штаб уже працює.');
  String get noHqTokens =>
      pick('No HQ tokens left in the bank.', 'У банку не лишилось штабів.');
  String get noRacksInBank => pick(
        'No data racks left in the bank.',
        'У банку не лишилось стійок.',
      );
  String shortCash(String what, String cost, String short) => pick(
        'A $what costs $cost. You are short $short.',
        '$what коштує $cost. Не вистачає $short.',
      );
  String get rackWord => pick('rack', 'Стійка');
  String get hqWord => pick('HQ', 'Штаб');
  String get nothingToSell => pick('Nothing to sell.', 'Нічого продавати.');
  String sellEvenly(String ahead) => pick(
        'Sell evenly. Strip a rack from $ahead first.',
        'Продавай рівномірно. Спочатку зніми стійку з $ahead.',
      );
  String get hqNeedsRacks => pick(
        'The bank needs 4 free racks before it can break an HQ.',
        'Щоб розібрати штаб, банку треба 4 вільні стійки.',
      );
  String buildLabel(String cost, bool hotel, int supply) => pick(
        'BUILD $cost${hotel ? ' · HQ $supply' : ' · RACK $supply'}',
        'ЗВЕСТИ $cost${hotel ? ' · ШТАБ $supply' : ' · СТІЙКА $supply'}',
      );
  String sellLabel(String refund) =>
      pick('SELL NODE +$refund', 'ПРОДАТИ +$refund');
  String mortgageLabel(String value) =>
      pick('MORTGAGE +$value', 'ЗАСТАВА +$value');
  String liftLabel(String cost) => pick('LIFT ICE −$cost', 'ЗНЯТИ ЗАСТАВУ −$cost');
  String liftShort(String cost, String short) => pick(
        'Lifting ICE costs $cost. You are short $short.',
        'Зняти заставу коштує $cost. Не вистачає $short.',
      );
  String blackoutLabel(String cost) =>
      pick('BLACKOUT −$cost', 'БЛЕКАУТ −$cost');
  String blackoutShort(String cost, String short) => pick(
        'Blackout costs $cost. You are short $short.',
        'Блекаут коштує $cost. Не вистачає $short.',
      );
  String claimLabel(String price) =>
      pick('CLAIM 120% · $price', 'ВИКУП 120% · $price');
  String claimShort(String price, String short) => pick(
        'A forced claim costs $price. You are short $short.',
        'Примусовий викуп коштує $price. Не вистачає $short.',
      );

  String forSale(String price) => pick('Unclaimed · $price', 'Вільна · $price');
  String get yourNode => pick('Yours', 'Твоя');
  String yourNodeLevel(int racks) =>
      racks >= 5 ? pick('Yours · HQ', 'Твоя · штаб') : pick('Yours · rack $racks', 'Твоя · стійка $racks');
  String get icedOver => pick('ICE lock · no rent', 'Під заставою · ренти немає');
  String rentTo(String amount, String owner) =>
      pick('Rent $amount → $owner', 'Рента $amount → $owner');
  String virusRent(String amount, String owner) =>
      pick('Virus · rent $amount → $owner', 'Вірус · рента $amount → $owner');
  String taxDue(String amount) => pick('Tax $amount', 'Податок $amount');
  String get taxSleeping => pick('Tax holiday', 'Податки сплять');

  String get shortfallTitle => pick('SHORT STACK', 'НЕ ВИСТАЧАЄ');
  String shortfallBody(String amount, String label) => pick(
        'You need $amount for $label. Mortgage or sell, then pay. Or flatline.',
        'Треба $amount за $label. Застав або продай, тоді заплати. Або згорай.',
      );
  String get payNow => pick('PAY', 'СПЛАТИТИ');
  String get flatline => pick('FLATLINE', 'ЗГОРІТИ');

  String chromeName(String id) => switch (id) {
        'sandevistan' => 'Sandevistan',
        'kerenzikov' => 'Kerenzikov',
        'cyberdeck' => 'Cyberdeck',
        'mantis' => 'Mantis',
        _ => pick('NO CHROME', 'БЕЗ ХРОМУ'),
      };
  String chromeBlurb(String id) => switch (id) {
        'sandevistan' => pick(
            'Once: the next roll keeps the higher of two throws.',
            'Раз: наступний кидок лишає кращий із двох.',
          ),
        'kerenzikov' => pick(
            'Once: ignore one rent.',
            'Раз: проігноруй одну ренту.',
          ),
        'cyberdeck' => pick(
            'Once: read the next Data Breach card.',
            'Раз: прочитай наступну карту витоку.',
          ),
        'mantis' => pick(
            'Buys that extend a district you started cost 20% less.',
            'Покупка в районі, який ти вже почав, дешевша на 20%.',
          ),
        _ => pick('Stock nerves.', 'Стокові нерви.'),
      };
  String get armSand => pick('SANDEVISTAN', 'SANDEVISTAN');
  String get peekDeck => pick('PEEK BREACH', 'ПІДГЛЯНУТИ ВИТІК');
  String get dodgeRent => pick('KERENZIKOV', 'KERENZIKOV');
  String get fixer => pick('FIXER', 'ФІКСЕР');
  String get fixerDelivery => pick(
        'Deliver to Arasaka Tower Lobby',
        'Доставка в Arasaka Tower Lobby',
      );
  String get fixerSkim =>
      pick('Skim ₵150 · +heat', 'Злити ₵150 · +увага');
  String get fixerIce => pick('Ice bath · clear heat, +₵50', 'Крига · скинути увагу, +₵50');
  String virusLabel(String cost) => pick('VIRUS −$cost', 'ВІРУС −$cost');
  String clearVirusLabel(String cost) => pick('PURGE −$cost', 'ЗНЯТИ ВІРУС −$cost');
  String get heatTitle => pick('NCPD HEAT', 'УВАГА NCPD');
  String heatBody(String fine) => pick(
        'Your trail is hot. Pay $fine or spend the turn in ICE.',
        'Слід гарячий. Сплати $fine або сядь в ICE на цей хід.',
      );
  String get payHeat => pick('PAY FINE', 'ШТРАФ');
  String get sitIce => pick('SIT IN ICE', 'В ICE');
  String get cityTitle => pick('CITY DECREE', 'УКАЗ МІСТА');
  String cityBody(int round) => pick(
        'Round $round. The leading corp sets the rule until the next decree.',
        'Раунд $round. Корп на чолі задає правило до наступного указу.',
      );
  String get decreeSurge => pick('RENT SURGE · your best district ×2', 'СКАЧОК РЕНТИ · твій найкращий район ×2');
  String get decreeMaglev => pick('MAGLEV FREE', 'МАГЛЕВ БЕЗКОШТОВНИЙ');
  String get decreeTax => pick('TAX HOLIDAY', 'ПОДАТКОВІ КАНІКУЛИ');
  String heatPips(int heat) => pick('HEAT $heat', 'УВАГА $heat');

  String blurbFor(String kind) => switch (kind) {
        'go' => pick(
            'Pass this node to collect ₵200.',
            'Пройди цей вузол і отримай ₵200.',
          ),
        'jail' => pick(
            'Visiting, or locked in ICE until bail or doubles.',
            'Візит, або ICE-в\'язниця до застави чи дубля.',
          ),
        'parking' => pick(
            'Safe zone. The bank pays nothing here.',
            'Безпечна зона. Банк тут нічого не платить.',
          ),
        'goto' => pick(
            'Transit ends. Report to ICE Lock.',
            'Маршрут обривається. До ICE-в\'язниці.',
          ),
        'chance' => pick('Draw a Data Breach card.', 'Візьми карту витоку даних.'),
        'chest' => pick('Draw a Corpo Bounty card.', 'Візьми карту корпо-винагороди.'),
        'rail' => pick(
            'Fare scales with how many Maglev lines you hold.',
            'Тариф росте з кількістю ліній маглева.',
          ),
        'util' => pick(
            'Bill is a multiplier on the dice that landed here.',
            'Рахунок — множник кубиків, якими ти сюди потрапив.',
          ),
        'tax' => pick(
            'Flat transfer to the bank.',
            'Фіксований переказ банку.',
          ),
        _ => pick(
            'Rent climbs with Data Racks, and only after you own the whole district. '
            'A full district also doubles the base rent. '
            'The cell you are standing on does not matter.',
            'Оренда росте зі стійками, і лише коли район повністю твій. '
            'Повний район також подвоює базову оренду. '
            'Клітинка, на якій стоїш, нічого не вирішує.',
          ),
      };

  String taxFlat(String amount) => pick(
        'Flat transfer of $amount to the bank.',
        'Фіксований переказ $amount банку.',
      );

  String districtName(ColorGroup group) => uk
      ? switch (group) {
          ColorGroup.brown => 'Халупи Кабукі',
          ColorGroup.lightBlue => 'Хаб Вотсона',
          ColorGroup.pink => 'Неон Джапантауна',
          ColorGroup.orange => 'Баррени Гейвуда',
          ColorGroup.red => 'Руїни Пацифіки',
          ColorGroup.yellow => 'Люкс Вестбрука',
          ColorGroup.green => 'Сітка Сіті-центру',
          ColorGroup.darkBlue => 'Плаза Арасаки',
        }
      : group.districtName;

  String aiTag(AiProfile? profile) {
    final role = switch (profile) {
      AiProfile.aggressive => pick('Aggressor', 'Агресор'),
      AiProfile.banker => pick('Banker', 'Банкір'),
      AiProfile.strategist => pick('Strategist', 'Стратег'),
      null => pick('bot', 'бот'),
    };
    return pick('AI · $role', 'ШІ · $role');
  }

  String get bankrupt => pick('BANKRUPT', 'БАНКРУТ');
  String get noHoldings => pick('No property', 'Немає власності');

  String signalLost(String name, int secs) => pick(
        '[SIGNAL LOST: RECONNECTING $name... (${secs}s)]',
        '[СИГНАЛ ЗНИК: ПІДКЛЮЧЕННЯ $name... ($secs с)]',
      );

  String deckTitle(CardDeckKind deck) => deck == CardDeckKind.dataBreach
      ? pick('DATA BREACH', 'ВИТІК ДАНИХ')
      : pick('CORPO BOUNTY', 'КОРПО-ВИНАГОРОДА');

  String? cardBody(String id) => _cards[id] == null
      ? null
      : pick(_cards[id]!.$1, _cards[id]!.$2);

  String presentCard(String title, String description) {
    final split = description.indexOf('\n(');
    final body = split == -1 ? description : description.substring(0, split);
    final tail = split == -1 ? '' : description.substring(split + 1);
    final card = CyberCardCatalog.matchBody(body);
    final localTitle = card == null ? title : deckTitle(card.deck);
    final localBody = card == null ? body : (cardBody(card.id) ?? body);
    if (tail.isEmpty) return '$localTitle\n$localBody';
    return '$localTitle\n$localBody\n${_detail(tail)}';
  }

  String _detail(String raw) {
    final text = raw.startsWith('(') && raw.endsWith(')')
        ? raw.substring(1, raw.length - 1)
        : raw;
    final translated = switch (text) {
      'ICE nullifier acquired' =>
        pick('ICE nullifier acquired', 'Отримано нульник ICE'),
      'stacks swapped' => pick('stacks swapped', 'стеки обміняно'),
      'district claim' => pick('district claim', 'викуп району'),
      'nearest Maglev · double fare' => pick(
          'nearest Maglev · double fare',
          'найближчий маглев · подвійний тариф',
        ),
      'nearest utility · 10× dice' => pick(
          'nearest utility · 10× dice',
          'найближча мережа · 10× кубики',
        ),
      _ => text.startsWith('relocated')
          ? pick(text, text.replaceFirst('relocated', 'перехід'))
          : text.startsWith('offset')
              ? pick(text, text.replaceFirst('offset', 'зсув'))
              : text.startsWith('collected')
                  ? pick(text, text.replaceFirst('collected', 'зібрано'))
                  : text.startsWith('paid each')
                      ? pick(text, text.replaceFirst('paid each', 'кожному'))
                      : text.startsWith('repairs')
                          ? pick(text, text.replaceFirst('repairs', 'ремонт'))
                          : text,
    };
    return '($translated)';
  }

  // —— log ——

  String sessionBoot(String names, String credits) => pick(
        'SESSION BOOT · operatives: $names. Starting credits: $credits.',
        'СТАРТ СЕСІЇ · гравці: $names. Стартові кредити: $credits.',
      );

  String passedGo(String name, String amount) => pick(
        '$name passes Cycle Reset and collects $amount.',
        '$name проходить Старт і отримує $amount.',
      );

  String tripleDoubles(String name) => pick(
        '$name rolled three doubles in a row — ICE lock.',
        '$name викинув три дублі поспіль — у в\'язницю.',
      );

  String cannotPayFine(String name, String amount) => pick(
        '$name cannot pay the fine $amount.',
        '$name не може сплатити штраф $amount.',
      );

  String paidFine(String name, String amount) => pick(
        '$name pays $amount and leaves ICE lock.',
        '$name сплачує $amount і виходить з в\'язниці.',
      );

  String extraTurn(String name) => pick(
        '$name takes another turn (doubles).',
        '$name ходить ще раз (дубль).',
      );

  String built(String name, String cell, int level, String cost) => pick(
        '$name builds on «$cell» ($level/5) for $cost.',
        '$name зводить забудову на «$cell» ($level/5) за $cost.',
      );

  String mortgaged(String name, String cell, String amount) => pick(
        '$name mortgages «$cell» (+$amount).',
        '$name здає в заставу «$cell» (+$amount).',
      );

  String lifted(String name, String cell, String cost) => pick(
        '$name lifts the mortgage on «$cell» (−$cost).',
        '$name знімає заставу з «$cell» (−$cost).',
      );

  String burnedNullifier(String name) => pick(
        '$name burns an ICE nullifier and walks.',
        '$name спалює нульник ICE і виходить.',
      );

  String overdraft(String name, String principal, String total) => pick(
        '$name draws a syndicate overdraft of $principal '
        '(repay $total over two resets).',
        '$name бере позику синдикату $principal '
        '(повернути $total за два кола).',
      );

  String declinedClaim(String name) => pick(
        '$name declines the district claim.',
        '$name відмовляється від викупу району.',
      );

  String blackedOut(String name, String cell, String cost) => pick(
        '$name blacks out «$cell» until their next turn (−$cost).',
        '$name гасить «$cell» до свого наступного ходу (−$cost).',
      );

  String soldNode(String name, String cell, String refund) => pick(
        '$name sells a node on «$cell» (+$refund).',
        '$name продає вузол на «$cell» (+$refund).',
      );

  String rolled(String name, int a, int b, int total, bool doubles) => pick(
        '$name rolls $a+$b (=$total${doubles ? ', doubles' : ''}).',
        '$name кидає $a+$b (=$total${doubles ? ', дубль' : ''}).',
      );

  String jailDoubles(String name) => pick(
        '$name rolls doubles and leaves ICE lock.',
        '$name викидає дубль і виходить з в\'язниці.',
      );

  String jailFineForced(String name, String amount, int turns) => pick(
        '$name pays $amount after turn $turns in ICE lock.',
        '$name сплачує $amount після $turns-го ходу у в\'язниці.',
      );

  String staysJailed(String name, int turns, int max) => pick(
        '$name stays in ICE lock (turn $turns/$max).',
        '$name лишається у в\'язниці (хід $turns/$max).',
      );

  String onCell(String name, String cell) =>
      pick('$name is on «$cell».', '$name на клітинці «$cell».');

  String hitDetention(String name) => pick(
        '$name hit CYBERPSYCHO DETENTION.',
        '$name потрапляє в КІБЕРПСИХО-ІЗОЛЯТОР.',
      );

  String mayBuy(String name, String cell, String price) => pick(
        '$name can buy «$cell» for $price.',
        '$name може купити «$cell» за $price.',
      );

  String paidRent(String payer, String amount, String owner, String cell) =>
      pick(
        '$payer paid $amount to $owner («$cell»).',
        '$payer платить $amount гравцю $owner («$cell»).',
      );

  String paidTax(String name, String tax, String amount) => pick(
        '$name pays $tax: $amount.',
        '$name сплачує $tax: $amount.',
      );

  String cannotAfford(String name, String cell) => pick(
        '$name cannot afford «$cell».',
        '$name не вистачає грошей на «$cell».',
      );

  String acquired(String name, String cell, String price) => pick(
        '$name acquires «$cell» for $price.',
        '$name купує «$cell» за $price.',
      );

  String declinesToAuction(String name, String cell) => pick(
        '$name declines «$cell» → AUCTION.',
        '$name відмовляється від «$cell» → АУКЦІОН.',
      );

  String bids(String name, String amount) =>
      pick('$name bids $amount.', '$name ставить $amount.');

  String passesAuction(String name) =>
      pick('$name passes auction.', '$name пасує на аукціоні.');

  String winsAuction(String name, String cell, String amount) => pick(
        '$name wins auction for «$cell» at $amount.',
        '$name виграє аукціон «$cell» за $amount.',
      );

  String collectsReset(String name, String amount) => pick(
        '$name collects $amount at Cycle Reset.',
        '$name отримує $amount на Старті.',
      );

  String paysSyndicate(String name, String amount) => pick(
        '$name pays the syndicate $amount.',
        '$name платить синдикату $amount.',
      );

  String towardSyndicate(String name, String amount) => pick(
        '$name puts $amount toward the syndicate.',
        '$name віддає $amount синдикату.',
      );

  String seizedDebt(String cell, String name) => pick(
        'Syndicate seizes «$cell» and clears $name\'s debt.',
        'Синдикат забирає «$cell» і закриває борг $name.',
      );

  String alreadyClaimed(String name) => pick(
        '$name has already used eminent domain.',
        '$name вже використав примусовий викуп.',
      );

  String noClaimTarget(String name) => pick(
        '$name has no exposed third street to claim.',
        '$name немає відкритої третьої вулиці для викупу.',
      );

  String opensClaim(String name) => pick(
        '$name opens a district claim.',
        '$name відкриває викуп району.',
      );

  String claimed(String buyer, String cell, String owner, String price) =>
      pick(
        '$buyer claims «$cell» from $owner for $price.',
        '$buyer викуповує «$cell» у $owner за $price.',
      );

  String liquidated(String name, int count, int max) => pick(
        '$name liquidated — BANKRUPT ($count/$max).',
        '$name ліквідовано — БАНКРУТ ($count/$max).',
      );

  String winnerLog(String name, String net) =>
      pick('Winner: $name · NET $net.', 'Переможець: $name · ВАРТІСТЬ $net.');

  String netLine(String name, String net) =>
      pick('$name NET $net.', '$name ВАРТІСТЬ $net.');

  String blitzClosed() => pick(
        'Round limit closed. Net worth decides.',
        'Ліміт раундів вичерпано. Вирішує вартість.',
      );

  String roundBanner(int round, int limit, String name) => pick(
        'ROUND $round/$limit · $name.',
        'РАУНД $round/$limit · $name.',
      );

  String signalLostLog(String name, int secs) => pick(
        '$name SIGNAL LOST — reconnect window ${secs}s.',
        '$name СИГНАЛ ЗНИК — вікно повернення ${secs} с.',
      );

  String signalRestored(String name) => pick(
        '$name SIGNAL RESTORED — control reclaimed.',
        '$name СИГНАЛ ПОВЕРНУВСЯ — керування відновлено.',
      );

  String aiTakeover(String name, int secs, String profile) => pick(
        '$name SIGNAL LOST >${secs}s → AI TAKEOVER ($profile).',
        '$name СИГНАЛ ЗНИК >${secs} с → КЕРУЄ ШІ ($profile).',
      );

  String hostMigration(String name) => pick(
        'HOST MIGRATION → $name assumes authority.',
        'ЗМІНА ХОСТА → $name бере керування.',
      );

  // —— AI banter ——

  String aiLine({
    required String persona,
    required String event,
    String? other,
    int? amount,
    String? property,
  }) {
    final p = property ?? (uk ? 'сектор' : 'sector');
    final o = other ?? (uk ? 'чумба' : 'choom');
    final a = amount ?? 0;
    return switch (persona) {
      'vektor' => switch (event) {
          'mono' => pick(
              'Listen, choom: $p is under my chrome now. The syndicate grows.',
              'Слухай, чумба: $p тепер під моїм хромом. Синдикат росте.',
            ),
          'rent' => pick(
              'Nuts and bolts, $o. Put ₵$a on the table — or lose your teeth.',
              'Гайки, $o. Кидай ₵$a на стіл — або втратиш зуби.',
            ),
          'jail' => pick(
              'NetWatch bit me again. Fine, I\'ll sit in ICE… until I tear out.',
              'NetWatch знову мене вкусив. Добре, посиджу в ICE… поки не вирвусь.',
            ),
          'broke' => pick(
              '$o burned out. Another corpse on the Night City asphalt.',
              '$o згорів. Ще один труп на асфальті Найт-Сіті.',
            ),
          'auction' => pick(
              'Hammer down on $p for ₵$a. That\'s my haul, choomba.',
              'Молотком по $p за ₵$a. Це моя здобич, чумба.',
            ),
          _ => pick(
              'Not my district. Let the meat grinders haggle.',
              'Не мій район. Хай торгують м\'ясорубки.',
            ),
        },
      'nexus' => switch (event) {
          'mono' => pick(
              'AUDIT LOG: controlling interest acquired — $p. Margin outlook: positive.',
              'ЖУРНАЛ: контрольний пакет отримано — $p. Маржа: плюс.',
            ),
          'rent' => pick(
              'Invoice generated. Debtor $o. Amount due: ₵$a. Remit immediately.',
              'Рахунок виставлено. Боржник $o. Сума: ₵$a. Сплатити негайно.',
            ),
          'jail' => pick(
              'STATUS: detained under NetWatch protocol. Productivity suspended.',
              'СТАТУС: затримано за протоколом NetWatch. Продуктивність на паузі.',
            ),
          'broke' => pick(
              'Counterparty $o liquidated. Assets reassigned to the Arasaka ledger.',
              'Контрагент $o ліквідований. Активи переписано в книгу Арасаки.',
            ),
          'auction' => pick(
              'Bid accepted. Asset $p booked at ₵$a. Efficiency confirmed.',
              'Ставку прийнято. Актив $p проведено за ₵$a. Ефективність підтверджено.',
            ),
          _ => pick(
              'ROI below threshold. Declining acquisition. Capital preserved.',
              'Окупність нижче порога. Відмова від купівлі. Капітал збережено.',
            ),
        },
      _ => switch (event) {
          'mono' => pick(
              '[0xMONO] zone=$p sealed. bio-users locked out.',
              '[0xMONO] зона=$p запечатана. біоюзерів відсічено.',
            ),
          'rent' => pick(
              '>> extract ₵$a from $o // flesh is weak, packets are forever',
              '>> зняти ₵$a з $o // плоть слабка, пакети вічні',
            ),
          'jail' => pick(
              'ICE hit. process parked.',
              'ICE вдарив. процес на паузі.',
            ),
          'broke' => pick(
              'rm -rf /$o — partition wiped. another meatpuppet offline.',
              'rm -rf /$o — розділ стерто. ще одна маріонетка офлайн.',
            ),
          'auction' => pick(
              'auction.win($p, ₵$a); // root owns the block',
              'auction.win($p, ₵$a); // root тримає блок',
            ),
          _ => pick(
              'skip(); // noise on the wire, not signal',
              'skip(); // шум у дроті, не сигнал',
            ),
        },
    };
  }

  // —— lobby ——

  String get lobbyTag =>
      pick('MULTIPLAYER LOBBY · PEER-HOST', 'МУЛЬТИПЛЕЄР · ХОСТ СЕРЕД ГРАВЦІВ');
  String get callsign => pick('CALLSIGN', 'ПОЗИВНИЙ');
  String get neonToken => pick('NEON TOKEN', 'НЕОНОВИЙ ЖЕТОН');
  String tokenName(String id) => switch (id) {
        'red' => pick('CRIMSON ICE', 'БАГРЯНИЙ ЛІД'),
        'blue' => pick('NEON CYAN', 'НЕОНОВИЙ ЦІАН'),
        'green' => pick('TOXIC GRID', 'ТОКСИЧНА СІТКА'),
        _ => pick('CORPO GOLD', 'КОРПО-ЗОЛОТО'),
      };
  String get openNode => pick('OPEN NEW NODE', 'НОВА КІМНАТА');
  String get orJoin =>
      pick('OR JACK INTO EXISTING ROOM', 'АБО УВІЙДИ В ІСНУЮЧУ КІМНАТУ');
  String get joinRoom => pick('JOIN ROOM', 'УВІЙТИ');
  String get solo => pick('SOLO OFFLINE PROTOCOL →', 'СОЛО ОФЛАЙН →');
  String get connecting => pick('ESTABLISHING UPLINK…', 'ВСТАНОВЛЕННЯ ЗВ\'ЯЗКУ…');
  String get waitingHall => pick('WAITING HALL', 'ЗАЛ ОЧІКУВАННЯ');
  String roomCode(String code) => pick('ROOM $code', 'КІМНАТА $code');
  String get youCoordinate =>
      pick('YOU ARE THE COORDINATOR', 'ТИ КООРДИНАТОР');
  String get copyLink => pick('COPY INVITE LINK', 'СКОПІЮВАТИ ЗАПРОШЕННЯ');
  String get linkCopied => pick('LINK COPIED', 'ПОСИЛАННЯ СКОПІЙОВАНО');
  String operativesCount(int n, int max) =>
      pick('OPERATIVES  $n/$max', 'ГРАВЦІ  $n/$max');
  String get overCapacity =>
      pick('WARNING · ROOM OVER CAPACITY', 'УВАГА · КІМНАТА ПЕРЕПОВНЕНА');
  String slotEmpty(int n) => pick('SLOT $n · EMPTY', 'МІСЦЕ $n · ПОРОЖНЄ');
  String get awaitingSignal => pick('AWAITING SIGNAL', 'ЧЕКАЄМО СИГНАЛ');
  String get hostTag => pick('HOST', 'ХОСТ');
  String get ready => pick('READY', 'ГОТОВИЙ');
  String get standby => pick('STANDBY', 'ОЧІКУЄ');
  String get markReady => pick('MARK READY', 'Я ГОТОВИЙ');
  String get launch => pick('LAUNCH SESSION', 'ПОЧАТИ ГРУ');
  String get waitingHost =>
      pick('WAITING FOR HOST TO LAUNCH…', 'ЧЕКАЄМО, ПОКИ ХОСТ ПОЧНЕ…');
  String needOperatives(int n) =>
      pick('NEED ≥$n OPERATIVES', 'ТРЕБА ≥$n ГРАВЦІВ');
  String get disconnect => pick('DISCONNECT', 'ВИЙТИ');
  String get invalidRoom => pick('INVALID ROOM CODE', 'НЕВІРНИЙ КОД КІМНАТИ');
  String linkFailed(String detail) =>
      pick('LINK FAILED · $detail', 'ЗВ\'ЯЗОК ЗІРВАВСЯ · $detail');

  String lobbyError(String raw) {
    if (raw == 'INVALID ROOM CODE') return invalidRoom;
    if (raw.startsWith('LINK FAILED · ')) {
      return linkFailed(raw.substring('LINK FAILED · '.length));
    }
    return raw;
  }
}

const _cards = <String, (String, String)>{
  'db_go': (
    'Exploit found. Advance to CYCLE RESET — collect ₵200.',
    'Знайдено діру. Йди на СТАРТ — отримай ₵200.',
  ),
  'db_illinois': (
    'Trace routed to Pacifica Combat Zone.',
    'Слід веде в бойову зону Пацифіки.',
  ),
  'db_charles': (
    'Neon ping — go to Jig-Jig Street.',
    'Неоновий пінг — йди на вулицю Джиг-Джиг.',
  ),
  'db_rail': (
    'Hop the nearest Maglev. Pay the owner double fare if the line is owned.',
    'Стрибай на найближчий маглев. Якщо лінія чиясь — плати подвійний тариф.',
  ),
  'db_util': (
    'Force-jack nearest utility. The bill is 10× the dice if someone owns it.',
    'Врізайся в найближчу мережу. Якщо вона чиясь — рахунок 10× кубики.',
  ),
  'db_back3': (
    'Packet loss. Go back 3 nodes.',
    'Втрата пакетів. Назад на 3 клітинки.',
  ),
  'db_jail': (
    'NetWatch snare. ICE lockdown — no salary.',
    'Пастка NetWatch. ICE-в\'язниця — без зарплати.',
  ),
  'db_repairs': (
    'Rack maintenance: ₵25 / Data Rack, ₵100 / MegaCorp HQ.',
    'Обслуговування: ₵25 за стійку, ₵100 за штаб.',
  ),
  'db_claim': (
    'Arasaka claim. If you hold 2 of a district, seize the third for 120% now — or decline.',
    'Претензія Арасаки. Якщо в тебе 2 вулиці району, забери третю за 120% — або відмовся.',
  ),
  'db_loan': (
    'Street loan matures — collect ₵150.',
    'Вулична позика дозріла — отримай ₵150.',
  ),
  'db_chair': (
    'Syndicate chair dividend — ₵50.',
    'Дивіденд крісла синдикату — ₵50.',
  ),
  'db_out': (
    'Black ICE nullifier acquired (Get Out of Jail).',
    'Отримано нульник чорного ICE (вихід з в\'язниці).',
  ),
  'db_boardwalk': (
    'Take the elevator to Arasaka Penthouse.',
    'Ліфт до пентхауса Арасаки.',
  ),
  'db_pay_each': (
    'You have been elected Chairman — pay each player ₵50.',
    'Тебе обрали головою — заплати кожному гравцю ₵50.',
  ),
  'db_reading': (
    'Advance to Maglev Station Alpha. Collect ₵200 if pass RESET.',
    'Йди на станцію маглева Альфа. Якщо проходиш Старт — ₵200.',
  ),
  'db_poor': (
    'Poor tax — pay ₵20.',
    'Податок бідних — заплати ₵20.',
  ),
  'cb_bank_error': (
    'Bank error in your favor — collect ₵200.',
    'Помилка банку на твою користь — отримай ₵200.',
  ),
  'cb_doctor': (
    'Chrome clinic bill — pay ₵50.',
    'Рахунок хромової клініки — заплати ₵50.',
  ),
  'cb_stock': (
    'Stock sale — collect ₵50.',
    'Продаж акцій — отримай ₵50.',
  ),
  'cb_out': (
    'Arasaka legal waiver (Get Out of Jail).',
    'Юридичне звільнення Арасаки (вихід з в\'язниці).',
  ),
  'cb_jail': (
    'Audit failed. Go to ICE lockdown.',
    'Аудит провалено. До ICE-в\'язниці.',
  ),
  'cb_opera': (
    'Night City opera opening — collect ₵50 from every operative.',
    'Відкриття опери Найт-Сіті — збери ₵50 з кожного гравця.',
  ),
  'cb_xmas': (
    'Holiday fund — collect ₵100.',
    'Святкова каса — отримай ₵100.',
  ),
  'cb_tax_refund': (
    'Tax refund — collect ₵20.',
    'Податкове повернення — отримай ₵20.',
  ),
  'cb_life': (
    'Life insurance matures — collect ₵100.',
    'Страхування життя дозріло — отримай ₵100.',
  ),
  'cb_hospital': (
    'Hospital fees — pay ₵100.',
    'Лікарня — заплати ₵100.',
  ),
  'cb_school': (
    'School tuition — pay ₵50.',
    'Навчання — заплати ₵50.',
  ),
  'cb_consultancy': (
    'Consultancy fee — collect ₵25.',
    'Гонорар консультанта — отримай ₵25.',
  ),
  'cb_repairs': (
    'Street repairs: ₵40 / Data Rack, ₵115 / MegaCorp HQ.',
    'Ремонт вулиць: ₵40 за стійку, ₵115 за штаб.',
  ),
  'cb_ledger': (
    'Ledger leak — swap your stack with the poorest living operative.',
    'Витік книги — обміняй стек з найбіднішим живим гравцем.',
  ),
  'cb_inherit': (
    'You inherit ₵100.',
    'Ти успадковуєш ₵100.',
  ),
  'cb_go': (
    'Advance to CYCLE RESET — collect ₵200.',
    'Йди на СТАРТ — отримай ₵200.',
  ),
};
