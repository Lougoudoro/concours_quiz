enum CustomQuiz {
   last(0, 'Bis'),
   blanc(-1, 'Examen Blanc'),
   bookmarks(-2, 'Mes favoris'),
   revision(-3, 'Révision');

  final int id;
  final String name;

  // Constructor
  const CustomQuiz(this.id, this.name);
}