import 'package:cncours_quiz/app/data/resources/category_resource.dart';
import 'package:cncours_quiz/app/data/resources/quiz_resource.dart';
import 'package:cncours_quiz/app/data/resources/question_resource.dart';
import 'package:cncours_quiz/app/data/resources/option_resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final RxList<CategoryResource> categories = <CategoryResource>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initCategories();
  }

  double get globalProgress {
    if (categories.isEmpty) return 0.0;
    return categories.map((c) => c.progress).reduce((a, b) => a + b) /
        categories.length;
  }

  void _initCategories() {
    categories.addAll([
      CategoryResource(
        id: 1,
        name: 'ENAREF',
        description: 'École Nationale des Régies Financières',
        progress: 0.35,
      ),
      CategoryResource(
        id: 2,
        name: 'ENAM',
        description: 'École Nationale d\'Administration et de Magistrature',
        progress: 0.15,
      ),
      CategoryResource(
        id: 3,
        name: 'Santé',
        description: 'Concours du secteur de la santé',
        progress: 0.0,
      ),
      CategoryResource(
        id: 4,
        name: 'Police',
        description: 'Concours d\'entrée à la Police Nationale',
        progress: 0.60,
      ),
      CategoryResource(
        id: 5,
        name: 'Douanes',
        description: 'Concours de la Direction Générale des Douanes',
        progress: 0.0,
      ),
      CategoryResource(
        id: 6,
        name: 'Éducation',
        description: 'Concours de l\'éducation nationale',
        progress: 0.45,
      ),
    ]);
  }

  static const Map<int, IconData> categoryIcons = {
    1: Icons.account_balance,
    2: Icons.gavel,
    3: Icons.local_hospital,
    4: Icons.shield,
    5: Icons.local_shipping,
    6: Icons.school,
  };

  static final Map<int, List<QuizResource>> _quizzes = {
    1: _buildENAREFQuizzes(),
    2: _buildENAMQuizzes(),
    3: _buildSanteQuizzes(),
    4: _buildPoliceQuizzes(),
    5: _buildDouanesQuizzes(),
    6: _buildEducationQuizzes(),
  };

  List<QuizResource> getQuizzesForCategory(int quizId) =>
      _quizzes[quizId] ?? [];

  static List<QuizResource> _buildENAREFQuizzes() => [
        QuizResource(
          id: 1,
          title: 'Culture Générale',
          description: 'Symboles, histoire et géographie du Burkina',
          questions: _sampleQuestions.sublist(0, 7),
        ),
        QuizResource(
          id: 2,
          title: 'Droit et Finances',
          description: 'Institutions, droit et finances publiques',
          questions: _sampleQuestions.sublist(3, 10),
        ),
        QuizResource(
          id: 3,
          title: 'Quiz Complet',
          description: 'Toutes les questions ENAREF',
          questions: _sampleQuestions.sublist(0),
        ),
      ];

  static List<QuizResource> _buildENAMQuizzes() => [
        QuizResource(
          id: 4,
          title: 'Droit Administratif',
          description: 'Droit administratif et institutions',
          questions: _sampleQuestions.sublist(0, 4),
        ),
        QuizResource(
          id: 5,
          title: 'Culture Générale',
          description: 'Histoire et géographie',
          questions: _sampleQuestions.sublist(0, 7),
        ),
        QuizResource(
          id: 6,
          title: 'Quiz Complet',
          description: 'Toutes les questions ENAM',
          questions: _sampleQuestions.sublist(0),
        ),
      ];

  static List<QuizResource> _buildSanteQuizzes() => [
        QuizResource(
          id: 7,
          title: 'Santé Publique',
          description: 'Quiz de connaissances générales',
          questions: _sampleQuestions.sublist(0, 5),
        ),
        QuizResource(
          id: 8,
          title: 'Quiz Complet',
          description: 'Toutes les questions Santé',
          questions: _sampleQuestions.sublist(0),
        ),
      ];

  static List<QuizResource> _buildPoliceQuizzes() => [
        QuizResource(
          id: 9,
          title: 'Droit et Institutions',
          description: 'Connaissances juridiques de base',
          questions: _sampleQuestions.sublist(0, 5),
        ),
        QuizResource(
          id: 10,
          title: 'Culture Générale',
          description: 'Histoire et géographie du Burkina',
          questions: _sampleQuestions.sublist(0, 7),
        ),
        QuizResource(
          id: 11,
          title: 'Quiz Complet',
          description: 'Toutes les questions Police',
          questions: _sampleQuestions.sublist(0),
        ),
      ];

  static List<QuizResource> _buildDouanesQuizzes() => [
        QuizResource(
          id: 12,
          title: 'Finances Publiques',
          description: 'Principes budgétaires et finances',
          questions: _sampleQuestions.sublist(8, 12),
        ),
        QuizResource(
          id: 13,
          title: 'Quiz Complet',
          description: 'Toutes les questions Douanes',
          questions: _sampleQuestions.sublist(0),
        ),
      ];

  static List<QuizResource> _buildEducationQuizzes() => [
        QuizResource(
          id: 14,
          title: 'Culture Générale',
          description: 'Histoire, géographie et culture',
          questions: _sampleQuestions.sublist(0, 7),
        ),
        QuizResource(
          id: 15,
          title: 'Quiz Complet',
          description: 'Toutes les questions Éducation',
          questions: _sampleQuestions.sublist(0),
        ),
      ];

  static final List<QuestionResource> _sampleQuestions = [
    QuestionResource(
      id: 1,
      content:
          'Quels sont les symboles de la République du Burkina Faso inscrits dans la Constitution ?',
      typeValue: 'qcm',
      typeLabel: 'QCM',
      options: [
        OptionResource(
            id: 1,
            content: 'Le drapeau national (vert, rouge, étoile jaune)',
            isCorrect: true),
        OptionResource(
            id: 2,
            content: 'L\'hymne national « Une Seule Nuit »',
            isCorrect: true),
        OptionResource(id: 3, content: 'Les armoiries', isCorrect: true),
        OptionResource(
            id: 4,
            content: 'Le balafon impérial de Bobo-Dioulasso',
            isCorrect: false),
      ],
      justification:
          'Selon la Constitution du Burkina Faso (Titre I, Art. 34), les symboles de la République sont : le drapeau national, l\'hymne national « Une Seule Nuit » et les armoiries.',
    ),
    QuestionResource(
      id: 2,
      content:
          'En quelle année la Haute-Volta a-t-elle été rebaptisée « Burkina Faso » ?',
      typeValue: 'qcm',
      typeLabel: 'QCM',
      options: [
        OptionResource(id: 1, content: '1960', isCorrect: false),
        OptionResource(id: 2, content: '1984', isCorrect: true),
        OptionResource(id: 3, content: '1987', isCorrect: false),
        OptionResource(id: 4, content: '1991', isCorrect: false),
      ],
      justification:
          'Le 4 août 1984, sous la présidence de Thomas Sankara, la Haute-Volta a été officiellement rebaptisée « Burkina Faso ».',
    ),
    QuestionResource(
      id: 3,
      content: 'Quelles villes sont des chefs-lieux de région au Burkina Faso ?',
      typeValue: 'qcm',
      typeLabel: 'QCM',
      options: [
        OptionResource(id: 1, content: 'Ouagadougou (Centre)', isCorrect: true),
        OptionResource(
            id: 2, content: 'Bobo-Dioulasso (Hauts-Bassins)', isCorrect: true),
        OptionResource(
            id: 3, content: 'Koudougou (Centre-Ouest)', isCorrect: true),
        OptionResource(id: 4, content: 'Abidjan (Lagunes)', isCorrect: false),
      ],
      justification:
          'Le Burkina Faso compte 13 régions. Ouagadougou, Bobo-Dioulasso et Koudougou sont bien des chefs-lieux de région.',
    ),
    QuestionResource(
      id: 4,
      content:
          'Quelles institutions font partie du pouvoir judiciaire au Burkina Faso ?',
      typeValue: 'qcm',
      typeLabel: 'QCM',
      options: [
        OptionResource(
            id: 1, content: 'Le Conseil constitutionnel', isCorrect: true),
        OptionResource(id: 2, content: 'La Cour de cassation', isCorrect: true),
        OptionResource(id: 3, content: 'Le Conseil d\'État', isCorrect: true),
        OptionResource(
            id: 4, content: 'L\'Assemblée nationale', isCorrect: false),
      ],
      justification:
          'Au Burkina Faso, le pouvoir judiciaire comprend le Conseil constitutionnel, la Cour de cassation et le Conseil d\'État.',
    ),
    QuestionResource(
      id: 5,
      content: 'Le Burkina Faso est un État unitaire décentralisé.',
      typeValue: 'vrai_ou_faux',
      typeLabel: 'Vrai ou Faux',
      options: [
        OptionResource(id: 1, content: 'Vrai', isCorrect: true),
        OptionResource(id: 2, content: 'Faux', isCorrect: false),
      ],
      justification:
          'Selon la Constitution (Art. 31), le Burkina Faso est un État démocratique, unitaire et laïc.',
    ),
    QuestionResource(
      id: 6,
      content: 'Le FCFA utilisé au Burkina Faso est émis par la BCEAO.',
      typeValue: 'vrai_ou_faux',
      typeLabel: 'Vrai ou Faux',
      options: [
        OptionResource(id: 1, content: 'Vrai', isCorrect: true),
        OptionResource(id: 2, content: 'Faux', isCorrect: false),
      ],
      justification:
          'Le franc CFA (XOF) utilisé au Burkina Faso est bien émis par la BCEAO.',
    ),
    QuestionResource(
      id: 7,
      content: 'Quels fleuves traversent le territoire du Burkina Faso ?',
      typeValue: 'qcm',
      typeLabel: 'QCM',
      options: [
        OptionResource(
            id: 1, content: 'Le Mouhoun (Volta Noire)', isCorrect: true),
        OptionResource(
            id: 2, content: 'Le Nakambé (Volta Blanche)', isCorrect: true),
        OptionResource(
            id: 3, content: 'Le Nazinon (Volta Rouge)', isCorrect: true),
        OptionResource(
            id: 4,
            content: 'Le fleuve Niger (cours principal)',
            isCorrect: false),
      ],
      justification:
          'Les trois principaux cours d\'eau du Burkina Faso sont le Mouhoun, le Nakambé et le Nazinon.',
    ),
    QuestionResource(
      id: 8,
      content: 'Quelle est la superficie approximative du Burkina Faso ?',
      typeValue: 'qcm',
      typeLabel: 'QCM',
      options: [
        OptionResource(id: 1, content: '274 200 km²', isCorrect: true),
        OptionResource(id: 2, content: '322 460 km²', isCorrect: false),
        OptionResource(id: 3, content: '196 720 km²', isCorrect: false),
        OptionResource(id: 4, content: '475 440 km²', isCorrect: false),
      ],
      justification: 'Le Burkina Faso s\'étend sur environ 274 200 km².',
    ),
    QuestionResource(
      id: 9,
      content:
          'Au Burkina Faso, la loi de finances est votée chaque année par l\'Assemblée nationale avant le 31 décembre.',
      typeValue: 'vrai_ou_faux',
      typeLabel: 'Vrai ou Faux',
      options: [
        OptionResource(id: 1, content: 'Vrai', isCorrect: true),
        OptionResource(id: 2, content: 'Faux', isCorrect: false),
      ],
      justification:
          'En principe, la loi de finances doit être votée avant le 31 décembre pour l\'exercice budgétaire suivant.',
    ),
    QuestionResource(
      id: 10,
      content:
          'Parmi les éléments suivants, lesquels sont des principes budgétaires fondamentaux au Burkina Faso ?',
      typeValue: 'qcm',
      typeLabel: 'QCM',
      options: [
        OptionResource(
            id: 1, content: 'Le principe d\'annualité', isCorrect: true),
        OptionResource(
            id: 2, content: 'Le principe d\'universalité', isCorrect: true),
        OptionResource(
            id: 3, content: 'Le principe de spécialité', isCorrect: true),
        OptionResource(
            id: 4, content: 'Le principe de confidentialité', isCorrect: false),
      ],
      justification:
          'Les principes budgétaires fondamentaux sont : annualité, universalité, unité, spécialité et sincérité.',
    ),
    QuestionResource(
      id: 11,
      content:
          'Qui nomme le Premier ministre au Burkina Faso selon la Constitution de 1991 ?',
      typeValue: 'qcm',
      typeLabel: 'QCM',
      options: [
        OptionResource(id: 1, content: 'Le Président du Faso', isCorrect: true),
        OptionResource(
            id: 2, content: 'L\'Assemblée nationale', isCorrect: false),
        OptionResource(
            id: 3, content: 'Le Conseil constitutionnel', isCorrect: false),
        OptionResource(
            id: 4, content: 'Le peuple par référendum', isCorrect: false),
      ],
      justification:
          'Selon l\'article 46 de la Constitution du 2 juin 1991, le Président du Faso nomme le Premier ministre.',
    ),
    QuestionResource(
      id: 12,
      content: 'Le Burkina Faso est frontalier de combien de pays ?',
      typeValue: 'qcm',
      typeLabel: 'QCM',
      options: [
        OptionResource(id: 1, content: '4 pays', isCorrect: false),
        OptionResource(id: 2, content: '6 pays', isCorrect: true),
        OptionResource(id: 3, content: '5 pays', isCorrect: false),
        OptionResource(id: 4, content: '7 pays', isCorrect: false),
      ],
      justification: 'Le Burkina Faso partage ses frontières avec 6 pays.',
    ),
    QuestionResource(
      id: 13,
      content: 'Le FESPACO se tient tous les deux ans à Ouagadougou.',
      typeValue: 'vrai_ou_faux',
      typeLabel: 'Vrai ou Faux',
      options: [
        OptionResource(id: 1, content: 'Vrai', isCorrect: true),
        OptionResource(id: 2, content: 'Faux', isCorrect: false),
      ],
      justification:
          'Le FESPACO est un festival biennal qui se tient les années impaires à Ouagadougou.',
    ),
    QuestionResource(
      id: 14,
      content:
          'Quelles sont les catégories de collectivités territoriales au Burkina Faso ?',
      typeValue: 'qcm',
      typeLabel: 'QCM',
      options: [
        OptionResource(id: 1, content: 'Les régions', isCorrect: true),
        OptionResource(id: 2, content: 'Les communes', isCorrect: true),
        OptionResource(id: 3, content: 'Les départements', isCorrect: false),
        OptionResource(id: 4, content: 'Les provinces', isCorrect: false),
      ],
      justification:
          'Les collectivités territoriales du Burkina Faso sont les régions et les communes.',
    ),
    QuestionResource(
      id: 15,
      content: 'Le Burkina Faso a obtenu son indépendance le 5 août 1960.',
      typeValue: 'vrai_ou_faux',
      typeLabel: 'Vrai ou Faux',
      options: [
        OptionResource(id: 1, content: 'Vrai', isCorrect: true),
        OptionResource(id: 2, content: 'Faux', isCorrect: false),
      ],
      justification:
          'La République de Haute-Volta a proclamé son indépendance le 5 août 1960.',
    ),
    QuestionResource(
      id: 16,
      content:
          'Quels sont les principaux produits d\'exportation du Burkina Faso ?',
      typeValue: 'qcm',
      typeLabel: 'QCM',
      options: [
        OptionResource(id: 1, content: 'L\'or', isCorrect: true),
        OptionResource(id: 2, content: 'Le coton', isCorrect: true),
        OptionResource(id: 3, content: 'Le karité', isCorrect: true),
        OptionResource(id: 4, content: 'Le pétrole', isCorrect: false),
      ],
      justification:
          'Les principaux produits d\'exportation sont l\'or, le coton et le karité.',
    ),
    QuestionResource(
      id: 17,
      content: 'La devise du Burkina Faso est « Unité – Progrès – Justice ».',
      typeValue: 'vrai_ou_faux',
      typeLabel: 'Vrai ou Faux',
      options: [
        OptionResource(id: 1, content: 'Vrai', isCorrect: true),
        OptionResource(id: 2, content: 'Faux', isCorrect: false),
      ],
      justification:
          'La devise officielle du Burkina Faso est « Unité – Progrès – Justice ».',
    ),
    QuestionResource(
      id: 18,
      content: 'Combien de régions administratives le Burkina Faso compte-t-il ?',
      typeValue: 'qcm',
      typeLabel: 'QCM',
      options: [
        OptionResource(id: 1, content: '10 régions', isCorrect: false),
        OptionResource(id: 2, content: '13 régions', isCorrect: true),
        OptionResource(id: 3, content: '15 régions', isCorrect: false),
        OptionResource(id: 4, content: '45 régions', isCorrect: false),
      ],
      justification:
          'Le Burkina Faso est divisé en 13 régions administratives.',
    ),
    QuestionResource(
      id: 19,
      content: 'Parmi ces langues, lesquelles sont parlées au Burkina Faso ?',
      typeValue: 'qcm',
      typeLabel: 'QCM',
      options: [
        OptionResource(id: 1, content: 'Le mooré', isCorrect: true),
        OptionResource(id: 2, content: 'Le dioula', isCorrect: true),
        OptionResource(id: 3, content: 'Le fulfuldé', isCorrect: true),
        OptionResource(id: 4, content: 'Le wolof', isCorrect: false),
      ],
      justification:
          'Le mooré, le dioula et le fulfuldé sont trois des principales langues nationales.',
    ),
    QuestionResource(
      id: 20,
      content:
          'Le Nahouri est une province du Burkina Faso dont le chef-lieu est Pô.',
      typeValue: 'vrai_ou_faux',
      typeLabel: 'Vrai ou Faux',
      options: [
        OptionResource(id: 1, content: 'Vrai', isCorrect: true),
        OptionResource(id: 2, content: 'Faux', isCorrect: false),
      ],
      justification:
          'Le Nahouri est bien une province de la région du Centre-Sud, et son chef-lieu est la ville de Pô.',
    ),
  ];
}
