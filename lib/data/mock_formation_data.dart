import '../app/data/models/formation.dart';
import '../app/data/resources/question_resource.dart';
import '../app/data/resources/option_resource.dart';

class MockFormationData {
  static Session getSession2026() {
    return Session(
      id: 1,
      name: 'Session 2026',
      isActive: true,
      concoursTypes: [
        // --- OPTION A : CONCOURS DIRECTS ---
        ConcoursType(
          id: 1,
          name: 'Concours Directs',
          category: ConcoursCategory.direct,
          subCategories: [
            SubCategory(
              id: 1,
              name: 'Niveau BAC',
              collections: [
                Collection(
                  id: 1,
                  name: 'Formation de Mars',
                  series: [
                    Serie(
                      id: 1,
                      name: 'Examen Blanc : Culture Générale',
                      questions: _getMockQuestions('Culture Générale (BAC)'),
                    ),
                    Serie(
                      id: 2,
                      name: 'Quiz : Tests de Logique',
                      questions: _getMockQuestions('Logique (BAC)'),
                    ),
                  ],
                ),
              ],
            ),
            SubCategory(
              id: 2,
              name: 'Niveau BEPC',
              collections: [],
            ),
          ],
        ),
        // --- OPTION B : CONCOURS PROFESSIONNELS ---
        ConcoursType(
          id: 2,
          name: 'Concours Professionnels',
          category: ConcoursCategory.professionnel,
          subCategories: [
            SubCategory(
              id: 3,
              name: 'ENAM (Administration)',
              collections: [
                Collection(
                  id: 2,
                  name: 'Formation de Janvier',
                  series: [
                    Serie(
                      id: 3,
                      name: 'Quiz 1 : Droit Administratif',
                      questions: _getMockQuestions('Droit Admin (ENAM)'),
                    ),
                  ],
                ),
              ],
            ),
            SubCategory(
              id: 4,
              name: 'Secteur de la Santé',
              collections: [],
            ),
          ],
        ),
      ],
    );
  }

  static List<QuestionResource> _getMockQuestions(String category) {
    return [
      QuestionResource(
        id: 1,
        text: 'Quelle est la capitale économique du Burkina Faso ?',
        typeValue: 'qcm',
        typeLabel: 'QCM',
        justification:
            'Bobo-Dioulasso est historiquement et économiquement reconnue comme la capitale économique du pays.',
        options: [
          OptionResource(id: 1, content: 'Ouagadougou', isCorrect: false),
          OptionResource(id: 2, content: 'Bobo-Dioulasso', isCorrect: true),
          OptionResource(id: 3, content: 'Koudougou', isCorrect: false),
        ],
      ),
      QuestionResource(
        id: 2,
        text: 'Le Burkina Faso est un pays enclavé.',
        typeValue: 'vrai_ou_faux',
        typeLabel: 'Vrai ou Faux',
        justification:
            'Vrai. Le Burkina Faso n\'a pas d\'accès direct à la mer.',
        options: [
          OptionResource(id: 1, content: 'Vrai', isCorrect: true),
          OptionResource(id: 2, content: 'Faux', isCorrect: false),
        ],
      ),
      QuestionResource(
        id: 3,
        text:
            'Quelles sont les couleurs du drapeau burkinabè ? (Choisir toutes les bonnes réponses)',
        typeValue: 'qcm',
        typeLabel: 'QCM',
        justification:
            'Le drapeau est composé de deux bandes horizontales (rouge et verte) avec une étoile jaune au milieu.',
        options: [
          OptionResource(id: 1, content: 'Rouge', isCorrect: true),
          OptionResource(id: 2, content: 'Bleu', isCorrect: false),
          OptionResource(id: 3, content: 'Vert', isCorrect: true),
          OptionResource(id: 4, content: 'Jaune (Étoile)', isCorrect: true),
        ],
      ),
    ];
  }
}
