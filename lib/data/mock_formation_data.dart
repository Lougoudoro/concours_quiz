import '../models/formation.dart';
import '../models/question.dart';

class MockFormationData {
  static Session getSession2026() {
    return Session(
      id: 's2026',
      name: 'Session 2026',
      isActive: true,
      concoursTypes: [
        // --- OPTION A : CONCOURS DIRECTS ---
        ConcoursType(
          id: 'dir',
          name: 'Concours Directs',
          category: ConcoursCategory.direct,
          subCategories: [
            SubCategory(
              id: 'bac',
              name: 'Niveau BAC',
              collections: [
                Collection(
                  id: 'f_mars',
                  name: 'Formation de Mars',
                  series: [
                    Serie(
                      id: 'ex_blanc_cg',
                      name: 'Examen Blanc : Culture Générale',
                      questions: _getMockQuestions('Culture Générale (BAC)'),
                    ),
                    Serie(
                      id: 'quiz_logique',
                      name: 'Quiz : Tests de Logique',
                      questions: _getMockQuestions('Logique (BAC)'),
                    ),
                  ],
                ),
              ],
            ),
            SubCategory(
              id: 'bepc',
              name: 'Niveau BEPC',
              collections: [],
            ),
          ],
        ),
        // --- OPTION B : CONCOURS PROFESSIONNELS ---
        ConcoursType(
          id: 'pro',
          name: 'Concours Professionnels',
          category: ConcoursCategory.professionnel,
          subCategories: [
            SubCategory(
              id: 'enam',
              name: 'ENAM (Administration)',
              collections: [
                Collection(
                  id: 'f_janv',
                  name: 'Formation de Janvier',
                  series: [
                    Serie(
                      id: 'droit_admin',
                      name: 'Quiz 1 : Droit Administratif',
                      questions: _getMockQuestions('Droit Admin (ENAM)'),
                    ),
                  ],
                ),
              ],
            ),
            SubCategory(
              id: 'sante',
              name: 'Secteur de la Santé',
              collections: [],
            ),
          ],
        ),
      ],
    );
  }

  static List<Question> _getMockQuestions(String category) {
    return [
      Question(
        id: 'q1',
        text: 'Quelle est la capitale économique du Burkina Faso ?',
        type: QuestionType.qcm,
        category: category,
        justification: 'Bobo-Dioulasso est historiquement et économiquement reconnue comme la capitale économique du pays.',
        options: [
          AnswerOption(id: 'o1', text: 'Ouagadougou', isCorrect: false),
          AnswerOption(id: 'o2', text: 'Bobo-Dioulasso', isCorrect: true),
          AnswerOption(id: 'o3', text: 'Koudougou', isCorrect: false),
        ],
      ),
      Question(
        id: 'q2',
        text: 'Le Burkina Faso est un pays enclavé.',
        type: QuestionType.vraiOuFaux,
        category: category,
        justification: 'Vrai. Le Burkina Faso n\'a pas d\'accès direct à la mer.',
        options: [
          AnswerOption(id: 'v', text: 'Vrai', isCorrect: true),
          AnswerOption(id: 'f', text: 'Faux', isCorrect: false),
        ],
      ),
      Question(
        id: 'q3',
        text: 'Quelles sont les couleurs du drapeau burkinabè ? (Choisir toutes les bonnes réponses)',
        type: QuestionType.qcm,
        category: category,
        justification: 'Le drapeau est composé de deux bandes horizontales (rouge et verte) avec une étoile jaune au milieu.',
        options: [
          AnswerOption(id: 'c1', text: 'Rouge', isCorrect: true),
          AnswerOption(id: 'c2', text: 'Bleu', isCorrect: false),
          AnswerOption(id: 'c3', text: 'Vert', isCorrect: true),
          AnswerOption(id: 'c4', text: 'Jaune (Étoile)', isCorrect: true),
        ],
      ),
    ];
  }
}
