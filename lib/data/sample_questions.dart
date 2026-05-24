/// Banque de questions d'exemple pour les concours du Burkina Faso.
///
/// Contient de vrais exemples couvrant :
/// - Culture générale & Histoire du Burkina Faso
/// - Géographie et Institutions
/// - Droit administratif et constitutionnel
/// - Questions de type Vrai/Faux
library;

import '../app/data/models/question.dart';

class SampleQuestions {
  SampleQuestions._();

  // ─── ENAREF ─────────────────────────────────────────────────────────

  static const List<Question> enarefQuestions = [
    // --- QCM : Culture Générale & Histoire ---
    Question(
      id: 'enaref_01',
      text:
          'Quels sont les symboles de la République du Burkina Faso inscrits dans la Constitution ?',
      type: QuestionType.qcm,
      category: 'ENAREF',
      options: [
        AnswerOption(id: 'a', text: 'Le drapeau national (vert, rouge, étoile jaune)', isCorrect: true),
        AnswerOption(id: 'b', text: 'L\'hymne national « Une Seule Nuit »', isCorrect: true),
        AnswerOption(id: 'c', text: 'Les armoiries', isCorrect: true),
        AnswerOption(id: 'd', text: 'Le balafon impérial de Bobo-Dioulasso', isCorrect: false),
      ],
      justification:
          'Selon la Constitution du Burkina Faso (Titre I, Art. 34), les symboles '
          'de la République sont : le drapeau national, l\'hymne national « Une Seule Nuit » '
          'et les armoiries. Le balafon, bien que patrimoine culturel, n\'est pas un symbole constitutionnel.',
    ),

    Question(
      id: 'enaref_02',
      text:
          'En quelle année la Haute-Volta a-t-elle été rebaptisée « Burkina Faso » ?',
      type: QuestionType.qcm,
      category: 'ENAREF',
      options: [
        AnswerOption(id: 'a', text: '1960', isCorrect: false),
        AnswerOption(id: 'b', text: '1984', isCorrect: true),
        AnswerOption(id: 'c', text: '1987', isCorrect: false),
        AnswerOption(id: 'd', text: '1991', isCorrect: false),
      ],
      justification:
          'Le 4 août 1984, sous la présidence de Thomas Sankara, la Haute-Volta '
          'a été officiellement rebaptisée « Burkina Faso », signifiant « Pays des Hommes Intègres ».',
    ),

    Question(
      id: 'enaref_03',
      text:
          'Quelles villes sont des chefs-lieux de région au Burkina Faso ?',
      type: QuestionType.qcm,
      category: 'ENAREF',
      options: [
        AnswerOption(id: 'a', text: 'Ouagadougou (Centre)', isCorrect: true),
        AnswerOption(id: 'b', text: 'Bobo-Dioulasso (Hauts-Bassins)', isCorrect: true),
        AnswerOption(id: 'c', text: 'Koudougou (Centre-Ouest)', isCorrect: true),
        AnswerOption(id: 'd', text: 'Abidjan (Lagunes)', isCorrect: false),
      ],
      justification:
          'Le Burkina Faso compte 13 régions. Ouagadougou, Bobo-Dioulasso et Koudougou '
          'sont bien des chefs-lieux de région. Abidjan est la capitale économique de la Côte d\'Ivoire.',
    ),

    // --- QCM : Droit & Institutions ---
    Question(
      id: 'enaref_04',
      text:
          'Quelles institutions font partie du pouvoir judiciaire au Burkina Faso ?',
      type: QuestionType.qcm,
      category: 'ENAREF',
      options: [
        AnswerOption(id: 'a', text: 'Le Conseil constitutionnel', isCorrect: true),
        AnswerOption(id: 'b', text: 'La Cour de cassation', isCorrect: true),
        AnswerOption(id: 'c', text: 'Le Conseil d\'État', isCorrect: true),
        AnswerOption(id: 'd', text: 'L\'Assemblée nationale', isCorrect: false),
      ],
      justification:
          'Au Burkina Faso, le pouvoir judiciaire comprend le Conseil constitutionnel, '
          'la Cour de cassation et le Conseil d\'État. L\'Assemblée nationale relève du '
          'pouvoir législatif.',
    ),

    // --- Vrai/Faux ---
    Question(
      id: 'enaref_05',
      text:
          'Le Burkina Faso est un État unitaire décentralisé.',
      type: QuestionType.vraiOuFaux,
      category: 'ENAREF',
      options: [
        AnswerOption(id: 'vrai', text: 'Vrai', isCorrect: true),
        AnswerOption(id: 'faux', text: 'Faux', isCorrect: false),
      ],
      justification:
          'Selon la Constitution (Art. 31), le Burkina Faso est un État démocratique, '
          'unitaire et laïc. La décentralisation est un principe organisationnel '
          'consacré avec les collectivités territoriales (régions et communes).',
    ),

    Question(
      id: 'enaref_06',
      text:
          'Le FCFA utilisé au Burkina Faso est émis par la BCEAO (Banque Centrale des États de l\'Afrique de l\'Ouest).',
      type: QuestionType.vraiOuFaux,
      category: 'ENAREF',
      options: [
        AnswerOption(id: 'vrai', text: 'Vrai', isCorrect: true),
        AnswerOption(id: 'faux', text: 'Faux', isCorrect: false),
      ],
      justification:
          'Le franc CFA (XOF) utilisé au Burkina Faso est bien émis par la BCEAO, '
          'dont le siège est à Dakar. Le Burkina Faso est membre de l\'UEMOA.',
    ),

    // --- QCM : Géographie ---
    Question(
      id: 'enaref_07',
      text:
          'Quels fleuves traversent le territoire du Burkina Faso ?',
      type: QuestionType.qcm,
      category: 'ENAREF',
      options: [
        AnswerOption(id: 'a', text: 'Le Mouhoun (Volta Noire)', isCorrect: true),
        AnswerOption(id: 'b', text: 'Le Nakambé (Volta Blanche)', isCorrect: true),
        AnswerOption(id: 'c', text: 'Le Nazinon (Volta Rouge)', isCorrect: true),
        AnswerOption(id: 'd', text: 'Le fleuve Niger (cours principal)', isCorrect: false),
      ],
      justification:
          'Les trois principaux cours d\'eau du Burkina Faso sont le Mouhoun (ex-Volta Noire), '
          'le Nakambé (ex-Volta Blanche) et le Nazinon (ex-Volta Rouge). '
          'Le Niger ne traverse pas le Burkina, seul un petit affluent y passe brièvement.',
    ),

    Question(
      id: 'enaref_08',
      text:
          'Quelle est la superficie approximative du Burkina Faso ?',
      type: QuestionType.qcm,
      category: 'ENAREF',
      options: [
        AnswerOption(id: 'a', text: '274 200 km²', isCorrect: true),
        AnswerOption(id: 'b', text: '322 460 km²', isCorrect: false),
        AnswerOption(id: 'c', text: '196 720 km²', isCorrect: false),
        AnswerOption(id: 'd', text: '475 440 km²', isCorrect: false),
      ],
      justification:
          'Le Burkina Faso s\'étend sur environ 274 200 km². C\'est un pays '
          'sahélien enclavé en Afrique de l\'Ouest.',
    ),

    // --- Vrai/Faux Finances ---
    Question(
      id: 'enaref_09',
      text:
          'Au Burkina Faso, la loi de finances est votée chaque année par l\'Assemblée nationale avant le 31 décembre.',
      type: QuestionType.vraiOuFaux,
      category: 'ENAREF',
      options: [
        AnswerOption(id: 'vrai', text: 'Vrai', isCorrect: true),
        AnswerOption(id: 'faux', text: 'Faux', isCorrect: false),
      ],
      justification:
          'En principe, la loi de finances doit être votée avant le 31 décembre '
          'pour l\'exercice budgétaire suivant (Art. 103 de la Constitution). '
          'En pratique, il peut y avoir des régimes d\'exception.',
    ),

    Question(
      id: 'enaref_10',
      text:
          'Parmi les éléments suivants, lesquels sont des principes budgétaires fondamentaux au Burkina Faso ?',
      type: QuestionType.qcm,
      category: 'ENAREF',
      options: [
        AnswerOption(id: 'a', text: 'Le principe d\'annualité', isCorrect: true),
        AnswerOption(id: 'b', text: 'Le principe d\'universalité', isCorrect: true),
        AnswerOption(id: 'c', text: 'Le principe de spécialité', isCorrect: true),
        AnswerOption(id: 'd', text: 'Le principe de confidentialité', isCorrect: false),
      ],
      justification:
          'Les principes budgétaires fondamentaux reconnus sont : annualité, universalité, '
          'unité, spécialité et sincérité. La « confidentialité » n\'est pas un principe '
          'budgétaire ; au contraire, la transparence est encouragée.',
    ),

    // --- QCM : Institutions et fonctionnement ---
    Question(
      id: 'enaref_11',
      text:
          'Qui nomme le Premier ministre au Burkina Faso selon la Constitution de 1991 ?',
      type: QuestionType.qcm,
      category: 'ENAREF',
      options: [
        AnswerOption(id: 'a', text: 'Le Président du Faso', isCorrect: true),
        AnswerOption(id: 'b', text: 'L\'Assemblée nationale', isCorrect: false),
        AnswerOption(id: 'c', text: 'Le Conseil constitutionnel', isCorrect: false),
        AnswerOption(id: 'd', text: 'Le peuple par référendum', isCorrect: false),
      ],
      justification:
          'Selon l\'article 46 de la Constitution du 2 juin 1991, le Président du Faso '
          'nomme le Premier ministre et met fin à ses fonctions.',
    ),

    Question(
      id: 'enaref_12',
      text:
          'Le Burkina Faso est frontalier de combien de pays ?',
      type: QuestionType.qcm,
      category: 'ENAREF',
      options: [
        AnswerOption(id: 'a', text: '4 pays', isCorrect: false),
        AnswerOption(id: 'b', text: '6 pays', isCorrect: true),
        AnswerOption(id: 'c', text: '5 pays', isCorrect: false),
        AnswerOption(id: 'd', text: '7 pays', isCorrect: false),
      ],
      justification:
          'Le Burkina Faso partage ses frontières avec 6 pays : le Mali (nord), '
          'le Niger (est), le Bénin (sud-est), le Togo (sud), le Ghana (sud) et '
          'la Côte d\'Ivoire (sud-ouest).',
    ),

    // --- Vrai/Faux Culture ---
    Question(
      id: 'enaref_13',
      text:
          'Le FESPACO (Festival Panafricain du Cinéma de Ouagadougou) se tient tous les deux ans à Ouagadougou.',
      type: QuestionType.vraiOuFaux,
      category: 'ENAREF',
      options: [
        AnswerOption(id: 'vrai', text: 'Vrai', isCorrect: true),
        AnswerOption(id: 'faux', text: 'Faux', isCorrect: false),
      ],
      justification:
          'Le FESPACO est effectivement un festival biennal qui se tient les années impaires '
          'à Ouagadougou depuis 1969. C\'est le plus grand festival de cinéma d\'Afrique.',
    ),

    // --- QCM Droit administratif ---
    Question(
      id: 'enaref_14',
      text:
          'Quelles sont les catégories de collectivités territoriales au Burkina Faso ?',
      type: QuestionType.qcm,
      category: 'ENAREF',
      options: [
        AnswerOption(id: 'a', text: 'Les régions', isCorrect: true),
        AnswerOption(id: 'b', text: 'Les communes', isCorrect: true),
        AnswerOption(id: 'c', text: 'Les départements', isCorrect: false),
        AnswerOption(id: 'd', text: 'Les provinces', isCorrect: false),
      ],
      justification:
          'Selon le Code général des collectivités territoriales (CGCT), '
          'les collectivités territoriales du Burkina Faso sont les régions et les communes. '
          'Les provinces et départements relèvent de la déconcentration administrative.',
    ),

    Question(
      id: 'enaref_15',
      text:
          'Le Burkina Faso a obtenu son indépendance le 5 août 1960.',
      type: QuestionType.vraiOuFaux,
      category: 'ENAREF',
      options: [
        AnswerOption(id: 'vrai', text: 'Vrai', isCorrect: true),
        AnswerOption(id: 'faux', text: 'Faux', isCorrect: false),
      ],
      justification:
          'La République de Haute-Volta (aujourd\'hui Burkina Faso) a proclamé son '
          'indépendance le 5 août 1960, sous la présidence de Maurice Yaméogo.',
    ),

    // --- QCM Économie ---
    Question(
      id: 'enaref_16',
      text:
          'Quels sont les principaux produits d\'exportation du Burkina Faso ?',
      type: QuestionType.qcm,
      category: 'ENAREF',
      options: [
        AnswerOption(id: 'a', text: 'L\'or', isCorrect: true),
        AnswerOption(id: 'b', text: 'Le coton', isCorrect: true),
        AnswerOption(id: 'c', text: 'Le karité', isCorrect: true),
        AnswerOption(id: 'd', text: 'Le pétrole', isCorrect: false),
      ],
      justification:
          'Les principaux produits d\'exportation du Burkina Faso sont l\'or '
          '(premier produit d\'exportation), le coton (« or blanc ») et le karité. '
          'Le Burkina Faso ne dispose pas de ressources pétrolières significatives.',
    ),

    Question(
      id: 'enaref_17',
      text:
          'La devise du Burkina Faso est « Unité – Progrès – Justice ».',
      type: QuestionType.vraiOuFaux,
      category: 'ENAREF',
      options: [
        AnswerOption(id: 'vrai', text: 'Vrai', isCorrect: true),
        AnswerOption(id: 'faux', text: 'Faux', isCorrect: false),
      ],
      justification:
          'La devise officielle du Burkina Faso est bien « Unité – Progrès – Justice », '
          'inscrite dans la Constitution et figurant sur les armoiries nationales.',
    ),

    // --- QCM Administration ---
    Question(
      id: 'enaref_18',
      text:
          'Combien de régions administratives le Burkina Faso compte-t-il ?',
      type: QuestionType.qcm,
      category: 'ENAREF',
      options: [
        AnswerOption(id: 'a', text: '10 régions', isCorrect: false),
        AnswerOption(id: 'b', text: '13 régions', isCorrect: true),
        AnswerOption(id: 'c', text: '15 régions', isCorrect: false),
        AnswerOption(id: 'd', text: '45 régions', isCorrect: false),
      ],
      justification:
          'Le Burkina Faso est divisé en 13 régions administratives, '
          '45 provinces et 351 communes.',
    ),

    Question(
      id: 'enaref_19',
      text:
          'Parmi ces langues, lesquelles sont parlées au Burkina Faso ?',
      type: QuestionType.qcm,
      category: 'ENAREF',
      options: [
        AnswerOption(id: 'a', text: 'Le mooré', isCorrect: true),
        AnswerOption(id: 'b', text: 'Le dioula', isCorrect: true),
        AnswerOption(id: 'c', text: 'Le fulfuldé', isCorrect: true),
        AnswerOption(id: 'd', text: 'Le wolof', isCorrect: false),
      ],
      justification:
          'Le mooré, le dioula et le fulfuldé sont trois des principales langues nationales '
          'du Burkina Faso. Le wolof est principalement parlé au Sénégal et en Gambie.',
    ),

    Question(
      id: 'enaref_20',
      text:
          'Le Nahouri est une province du Burkina Faso dont le chef-lieu est Pô.',
      type: QuestionType.vraiOuFaux,
      category: 'ENAREF',
      options: [
        AnswerOption(id: 'vrai', text: 'Vrai', isCorrect: true),
        AnswerOption(id: 'faux', text: 'Faux', isCorrect: false),
      ],
      justification:
          'Le Nahouri est bien une province de la région du Centre-Sud, '
          'et son chef-lieu est la ville de Pô.',
    ),
  ];

  /// Retourne la liste de questions pour une catégorie donnée
  static List<Question> getQuestionsForCategory(String categoryId) {
    // Pour l'instant, toutes les catégories retournent les mêmes questions
    // En production, chaque catégorie aurait sa propre banque
    return enarefQuestions;
  }
}
