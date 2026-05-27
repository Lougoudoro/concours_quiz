/// Banque de questions d'exemple pour les concours du Burkina Faso.
///
/// Contient de vrais exemples couvrant :
/// - Culture générale & Histoire du Burkina Faso
/// - Géographie et Institutions
/// - Droit administratif et constitutionnel
/// - Questions de type Vrai/Faux
library;

import '../app/data/resources/question_resource.dart';
import '../app/data/resources/option_resource.dart';

class SampleQuestions {
  SampleQuestions._();

  // ─── ENAREF ─────────────────────────────────────────────────────────

  static final List<QuestionResource> enarefQuestions = [
    // --- QCM : Culture Générale & Histoire ---
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
          'Selon la Constitution du Burkina Faso (Titre I, Art. 34), les symboles '
          'de la République sont : le drapeau national, l\'hymne national « Une Seule Nuit » '
          'et les armoiries. Le balafon, bien que patrimoine culturel, n\'est pas un symbole constitutionnel.',
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
          'Le 4 août 1984, sous la présidence de Thomas Sankara, la Haute-Volta '
          'a été officiellement rebaptisée « Burkina Faso », signifiant « Pays des Hommes Intègres ».',
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
          'Le Burkina Faso compte 13 régions. Ouagadougou, Bobo-Dioulasso et Koudougou '
          'sont bien des chefs-lieux de région. Abidjan est la capitale économique de la Côte d\'Ivoire.',
    ),

    // --- QCM : Droit & Institutions ---
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
          'Au Burkina Faso, le pouvoir judiciaire comprend le Conseil constitutionnel, '
          'la Cour de cassation et le Conseil d\'État. L\'Assemblée nationale relève du '
          'pouvoir législatif.',
    ),

    // --- Vrai/Faux ---
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
          'Selon la Constitution (Art. 31), le Burkina Faso est un État démocratique, '
          'unitaire et laïc. La décentralisation est un principe organisationnel '
          'consacré avec les collectivités territoriales (régions et communes).',
    ),

    QuestionResource(
      id: 6,
      content:
          'Le FCFA utilisé au Burkina Faso est émis par la BCEAO (Banque Centrale des États de l\'Afrique de l\'Ouest).',
      typeValue: 'vrai_ou_faux',
      typeLabel: 'Vrai ou Faux',
      options: [
        OptionResource(id: 1, content: 'Vrai', isCorrect: true),
        OptionResource(id: 2, content: 'Faux', isCorrect: false),
      ],
      justification:
          'Le franc CFA (XOF) utilisé au Burkina Faso est bien émis par la BCEAO, '
          'dont le siège est à Dakar. Le Burkina Faso est membre de l\'UEMOA.',
    ),

    // --- QCM : Géographie ---
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
          'Les trois principaux cours d\'eau du Burkina Faso sont le Mouhoun (ex-Volta Noire), '
          'le Nakambé (ex-Volta Blanche) et le Nazinon (ex-Volta Rouge). '
          'Le Niger ne traverse pas le Burkina, seul un petit affluent y passe brièvement.',
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
      justification:
          'Le Burkina Faso s\'étend sur environ 274 200 km². C\'est un pays '
          'sahélien enclavé en Afrique de l\'Ouest.',
    ),

    // --- Vrai/Faux Finances ---
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
          'En principe, la loi de finances doit être votée avant le 31 décembre '
          'pour l\'exercice budgétaire suivant (Art. 103 de la Constitution). '
          'En pratique, il peut y avoir des régimes d\'exception.',
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
          'Les principes budgétaires fondamentaux reconnus sont : annualité, universalité, '
          'unité, spécialité et sincérité. La « confidentialité » n\'est pas un principe '
          'budgétaire ; au contraire, la transparence est encouragée.',
    ),

    // --- QCM : Institutions et fonctionnement ---
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
          'Selon l\'article 46 de la Constitution du 2 juin 1991, le Président du Faso '
          'nomme le Premier ministre et met fin à ses fonctions.',
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
      justification:
          'Le Burkina Faso partage ses frontières avec 6 pays : le Mali (nord), '
          'le Niger (est), le Bénin (sud-est), le Togo (sud), le Ghana (sud) et '
          'la Côte d\'Ivoire (sud-ouest).',
    ),

    // --- Vrai/Faux Culture ---
    QuestionResource(
      id: 13,
      content:
          'Le FESPACO (Festival Panafricain du Cinéma de Ouagadougou) se tient tous les deux ans à Ouagadougou.',
      typeValue: 'vrai_ou_faux',
      typeLabel: 'Vrai ou Faux',
      options: [
        OptionResource(id: 1, content: 'Vrai', isCorrect: true),
        OptionResource(id: 2, content: 'Faux', isCorrect: false),
      ],
      justification:
          'Le FESPACO est effectivement un festival biennal qui se tient les années impaires '
          'à Ouagadougou depuis 1969. C\'est le plus grand festival de cinéma d\'Afrique.',
    ),

    // --- QCM Droit administratif ---
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
          'Selon le Code général des collectivités territoriales (CGCT), '
          'les collectivités territoriales du Burkina Faso sont les régions et les communes. '
          'Les provinces et départements relèvent de la déconcentration administrative.',
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
          'La République de Haute-Volta (aujourd\'hui Burkina Faso) a proclamé son '
          'indépendance le 5 août 1960, sous la présidence de Maurice Yaméogo.',
    ),

    // --- QCM Économie ---
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
          'Les principaux produits d\'exportation du Burkina Faso sont l\'or '
          '(premier produit d\'exportation), le coton (« or blanc ») et le karité. '
          'Le Burkina Faso ne dispose pas de ressources pétrolières significatives.',
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
          'La devise officielle du Burkina Faso est bien « Unité – Progrès – Justice », '
          'inscrite dans la Constitution et figurant sur les armoiries nationales.',
    ),

    // --- QCM Administration ---
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
          'Le Burkina Faso est divisé en 13 régions administratives, '
          '45 provinces et 351 communes.',
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
          'Le mooré, le dioula et le fulfuldé sont trois des principales langues nationales '
          'du Burkina Faso. Le wolof est principalement parlé au Sénégal et en Gambie.',
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
          'Le Nahouri est bien une province de la région du Centre-Sud, '
          'et son chef-lieu est la ville de Pô.',
    ),
  ];

  /// Retourne la liste de questions pour une catégorie donnée
  static List<QuestionResource> getQuestionsForCategory(String quizId) {
    // Pour l'instant, toutes les catégories retournent les mêmes questions
    // En production, chaque catégorie aurait sa propre banque
    return enarefQuestions;
  }
}
