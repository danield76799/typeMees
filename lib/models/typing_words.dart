/// Nederlandse typeles-woorden, ingedeeld in moeilijkheidsniveaus.
/// Geschikt voor kinderen van 8-12 jaar.
const Map<int, List<String>> wordsByDifficulty = {
  // Niveau 1: 2-3 letters, korte woorden
  1: [
    'aap', 'bal', 'cam', 'dak', 'eet', 'fee', 'gek', 'hek', 'ijs', 'jas',
    'kat', 'lam', 'man', 'nee', 'oom', 'pet', 'qua', 'rat', 'som', 'tak',
    'uil', 'wit', 'yep', 'zon', 'bed', 'bus', 'dag', 'elf', 'fit',
  ],
  // Niveau 2: 4 letters
  2: [
    'auto', 'bank', 'blauw', 'boek', 'cool', 'deur', 'dolfijn', 'fiets',
    'goud', 'huis', 'jager', 'kerk', 'lamp', 'maan', 'neus', 'olifant',
    'park', 'stoel', 'tafel', 'vogel', 'water', 'zomer', 'appel', 'boter',
    'droom', 'eten', 'fiets', 'groen', 'hallo', 'jongen', 'keuken',
  ],
  // Niveau 3: 5 letters
  3: [
    'ballet', 'banaan', 'cadeau', 'dansen', 'eenden', 'feest', 'gitaar',
    'hockey', 'juf', 'kabouter', 'lucht', 'mama', 'papa', 'school', 'tent',
    'vakantie', 'winkel', 'zolder', 'appel', 'bloem', 'dolfijn', 'einde',
    'fiets', 'groen', 'hallo', 'ijsje', 'jacht', 'klimmen', 'lopen', 'muziek',
    'schaap', 'vogel', 'zacht',
  ],
  // Niveau 4: 6+ letters, complexere woorden
  4: [
    'aardappel', 'banaan', 'cactus', 'dolfijn', 'eiland', 'flessen',
    'gevaarlijk', 'hoppen', 'ijsblokje', 'jubileum', 'kasteel', 'ladder',
    'mannelijk', 'onderzoek', 'pinguïn', 'quarantaine', 'raket', 'schaduw',
    'theelepel', 'universum', 'voorjaar', 'waterpas', 'yoghurt', 'zwaartekracht',
    'afspraak', 'boottocht', 'deurklinke', 'fantastisch', 'gordijnen',
    'handdoek', 'ijscreme',
  ],
};

int getMaxDifficulty() => wordsByDifficulty.length;

List<String> getWordsForLevel(int level) {
  final difficulty = level.clamp(1, getMaxDifficulty());
  return List.from(wordsByDifficulty[difficulty]!);
}
