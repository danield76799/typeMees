/// Nederlandse typeles-woorden, ingedeeld in moeilijkheidsniveaus.
/// Geschikt voor kinderen van 8-12 jaar, met progressieve moeilijkheid.
///
/// Niveau 1: 2-3 letters  →  Niveau 8: lange / lastige woorden.
/// Hoe hoger het speler-level, hoe moeilijkere woorden de les geeft.
const Map<int, List<String>> wordsByDifficulty = {
  // Niveau 1: 2-3 letters, alledaagse korte woorden
  1: [
    'aap', 'bal', 'cam', 'dak', 'eet', 'fee', 'gek', 'hek', 'ijs', 'jas',
    'kat', 'lam', 'man', 'nee', 'oom', 'pet', 'qua', 'rat', 'som', 'tak',
    'uil', 'wit', 'yep', 'zon', 'bed', 'bus', 'dag', 'elf', 'fit',
  ],
  // Niveau 2: 4 letters, bekende woorden
  2: [
    'auto', 'bank', 'boek', 'cool', 'deur', 'goud', 'huis', 'jager',
    'kerk', 'lamp', 'maan', 'neus', 'park', 'stoel', 'tafel', 'vogel',
    'water', 'zomer', 'appel', 'boter', 'droom', 'eten', 'groen', 'hallo',
  ],
  // Niveau 3: 5 letters, iets moeilijker
  3: [
    'ballet', 'cadeau', 'dansen', 'eenden', 'feest', 'gitaar',
    'hockey', 'kabouter', 'lucht', 'school', 'tent',
    'winkel', 'zolder', 'bloem', 'einde', 'fiets',
    'ijsje', 'jacht', 'klimmen', 'lopen', 'muziek', 'schaap', 'zacht',
  ],
  // Niveau 4: 6 letters, complexere woorden
  4: [
    'aardappel', 'cactus', 'dolfijn', 'eiland', 'flessen',
    'gevaarlijk', 'hoppen', 'ijsblokje', 'jubileum', 'kasteel', 'ladder',
    'mannelijk', 'onderzoek', 'pinguin', 'quarantaine', 'raket', 'schaduw',
    'theelepel', 'universum', 'voorjaar', 'waterpas', 'yoghurt', 'zwaartekracht',
  ],
  // Niveau 5: 7-8 letters, langere woorden
  5: [
    'aborigines', 'bibliotheek', 'cadeaubon', 'dennenboom', 'eekhoorntje',
    'fietstas', 'gebouwen', 'haringen', 'ijscohoorn', 'juffrouw',
    'krokodil', 'leeuwerik', 'margriet', 'nachtmerrie', 'olifanten',
    'pannenkoek', 'quesadilla', 'regenboog', 'sneeuwman', 'trommelen',
    'uilenspel', 'vliegtuig', 'wandelwagen', 'zeevarend',
  ],
  // Niveau 6: 9-10 letters, uitdagende woorden
  6: [
    'aardbeien', 'boterbloem', 'cartoonfilm', 'dromedaris', 'egelwezen',
    'fluisteren', 'gymnastiek', 'hippopotamus', 'ijsbeerbabys', 'jongensnaam',
    'kameleons', 'luiaardje', 'miereneter', 'nijlpaard', 'orensoepje',
    'pinguinrot', 'question', 'ruitenwisser', 'schildpad', 'tandartsen',
    'uitleggen', 'vliegendeier', 'wolkenschaar', 'zomerseizoen',
  ],
  // Niveau 7: 11-13 letters, lange samengestelde woorden
  7: [
    'aardappelmes', 'bibliotheken', 'cartoonfiguren', 'dennenappel',
    'egeljongens', 'fluitiste', 'gebouwdeel', 'haringparty',
    'ijscojacht', 'juffrouwtje', 'krokodillen', 'leeuwenkind',
    'margrietje', 'nachtvlinder', 'olifantsnek', 'pannenkoeken',
    'regenwormen', 'sneeuwpoppen', 'trommelritme', 'uilennestje',
  ],
  // Niveau 8: 13+ letters / lastige klanken, top-niveau
  8: [
    'aardappelstruif', 'bibliotheekboek', 'cartoonavontuur', 'dennenboompje',
    'egeljongetje', 'fluisterstem', 'gebouwenblok', 'haringhappend',
    'ijscohoorntje', 'juffrouwtjes', 'krokodillenbek', 'leeuwenmanen',
    'margrietveld', 'nachtvlinders', 'olifantsjong', 'pannenkoekjes',
    'regenwormpje', 'sneeuwpoppetje', 'trommelritmes', 'uilennestjes',
  ],
};

int getMaxDifficulty() => wordsByDifficulty.length;

/// Geef de woordenlijst voor een bepaald niveau.
/// Voor niveaus hoger dan het maximum wordt het zwaarste niveau teruggegeven
/// (de les wordt niet "makkelijker" op hoge levels).
List<String> getWordsForLevel(int level) {
  final difficulty = level.clamp(1, getMaxDifficulty());
  return List.from(wordsByDifficulty[difficulty]!);
}
