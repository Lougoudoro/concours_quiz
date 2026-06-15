enum CustomQuiz {
    blanc(0, 'Exam'),
    last(-1, 'Bis'),
    bookmarks(-2, 'Mes favoris'),
    revision(-3, 'Révision');

  final int id;
  final String name;

  // Constructor
  const CustomQuiz(this.id, this.name);
}