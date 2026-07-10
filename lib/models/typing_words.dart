/// Nederlandse typeles-woorden, oplopend in moeilijkheid.
/// Geschikt voor kinderen van 8-12 jaar.
const List<String> typingWords = [
  // Level 1: korte woorden (2-3 letters)
  'aap', 'bal', 'cam', 'dak', 'eet', 'fee', 'gek', 'hek', 'ijs', 'jas',
  'kat', 'lam', 'man', 'nee', 'oom', 'pet', 'qua', 'rat', 'som', 'tak',
  'uil', 'van', 'wit', 'yep', 'zon', 'bed', 'bus', 'dag', 'elf', 'fit',
  'gun', 'hol', 'ink', 'juf', 'kip', 'lip', 'map', 'nul', 'oog', 'pop',

  // Level 2: middellang (4-5 letters)
  'auto', 'bank', 'cool', 'deur', 'eend', 'fiets', 'groot', 'huis', 'idee',
  'jager', 'klein', 'lamp', 'maand', 'nieuw', 'ouder', 'paard', 'robot',
  'stoel', 'tafel', 'vogel', 'water', 'zomer', 'appel', 'blauw', 'cadeau',
  'droom', 'eikel', 'feest', 'groen', 'hallo', 'jonge', 'koken', 'lente',

  // Level 3: langer (6-7 letters)
  'bakker', 'cactus', 'dansen', 'eerlijk', 'fietsen', 'gitaar', 'hockey',
  'juffrouw', 'kasteel', 'ladder', 'mama', 'natuur', 'orkest', 'piraat',
  'regen', 'school', 'toeter', 'vakantie', 'winkel', 'zolder', 'banaan',
  'circus', 'dolfijn', 'engel', 'fabriek', 'glimlach', 'herfst', 'insect',
];

/// Woorden per level (ongeveer 20 per level).
List<String> getWordsForLevel(int level) {
  final start = (level - 1) * 20;
  final end = start + 20;
  if (start >= typingWords.length) return typingWords;
  return typingWords.sublist(start, end.clamp(0, typingWords.length));
}
