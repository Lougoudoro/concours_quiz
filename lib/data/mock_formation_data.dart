import '../app/data/resources/academic_session_resource.dart';
import '../app/data/resources/category_resource.dart';
import '../app/data/resources/concours_type_resource.dart';
import '../app/data/resources/quiz_resource.dart';
import '../app/data/resources/question_resource.dart';
import '../app/data/resources/option_resource.dart';
import '../app/data/resources/serie_resource.dart';
import 'package:flutter/material.dart';

class MockFormationData {
  static AcademicSessionResource getSession2026() {
    return AcademicSessionResource(
      id: 1,
      name: 'Session 2026',
      isActive: true,
      concoursTypes: [
        ConcoursTypeResource(
          id: 1,
          name: 'Concours Directs',
          statusValue: 'direct',
          statusLabel: 'Concours Directs',
          categories: [
            CategoryResource(
              id: 1,
              name: 'Niveau BAC',
              description: 'Candidats de niveau BAC',
              series: [
                SerieResource(
                  id: 1,
                  name: 'Formation de Mars',
                  description: 'Formation intensive de Mars',
                  icon: Icons.book,
                  quizes: [
                    QuizResource(
                      id: 1,
                      title: 'Examen Blanc : Culture Générale',
                      description: 'Testez votre culture générale',
                      questions: _getMockQuestions('Culture Générale (BAC)'),
                    ),
                    QuizResource(
                      id: 2,
                      title: 'Quiz : Tests de Logique',
                      description: 'Évaluez votre raisonnement logique',
                      questions: _getMockQuestions('Logique (BAC)'),
                    ),
                  ],
                ),
              ],
            ),
            CategoryResource(
              id: 2,
              name: 'Niveau BEPC',
              description: 'Candidats de niveau BEPC',
              series: [],
            ),
          ],
        ),
        ConcoursTypeResource(
          id: 2,
          name: 'Concours Professionnels',
          statusValue: 'professionnel',
          statusLabel: 'Concours Professionnels',
          categories: [
            CategoryResource(
              id: 3,
              name: 'ENAM (Administration)',
              description: 'Concours ENAM filière administration',
              series: [
                SerieResource(
                  id: 2,
                  name: 'Formation de Janvier',
                  description: 'Formation intense de Janvier',
                  icon: Icons.book,
                  quizes: [
                    QuizResource(
                      id: 3,
                      title: 'Quiz 1 : Droit Administratif',
                      description: 'Test de droit administratif',
                      questions: _getMockQuestions('Droit Admin (ENAM)'),
                    ),
                  ],
                ),
              ],
            ),
            CategoryResource(
              id: 4,
              name: 'Secteur de la Santé',
              description: 'Concours du secteur de la santé',
              series: [],
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
        content: 'Quelle est la capitale économique du Burkina Faso ?',
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
        content: 'Le Burkina Faso est un pays enclavé.',
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
        content:
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
