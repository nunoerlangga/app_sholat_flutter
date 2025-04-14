class GoodWords {
  final int id;
  final String person;
  final String words;

  GoodWords({required this.id, required this.person, required this.words});
 
}
List<GoodWords> goodWords = [
  GoodWords(id: 1, person: "Abu Bakar", words: "Semakin banyak ilmu yang kamu miliki, maka semakin besar pula ketakwaanmu terhadap Allah SWT"),
  GoodWords(id: 2, person: "Umar Bin Khattab", words: "Suatu pengetahuan (ilmu), kalaupun tidak bermanfaat untukmu, tidak akan membahayakanmu."),
  GoodWords(id: 3, person: "Ustman Bin Affan", words: "Ilmu itu lebih cantik dari mangkuk yang cantik, orang yang menuntut ilmu itu lebih manis dari madu"),
  GoodWords(id: 4, person: "Ali bin Abi Thalib", words: "Ilmu itu lebih baik daripada harta. Ilmu akan menjaga engkau dan engkau menjaga harta"),
];