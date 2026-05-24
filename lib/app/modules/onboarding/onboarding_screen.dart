import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cncours_quiz/app/core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Bienvenue sur ConcourQuiz BF',
      description:
          'L\'application de référence pour réussir vos concours de la fonction publique burkinabè.',
      image: 'assets/images/logo.png',
    ),
    OnboardingData(
      title: 'Apprentissage Gratuit',
      description:
          'Accédez à des milliers de questions QCM et Vrai/Faux gratuitement et sans limites.',
      icon: Icons.auto_stories_outlined,
    ),
    OnboardingData(
      title: 'Suivez vos progrès',
      description:
          'Conservez votre historique et analysez vos performances pour mieux vous préparer.',
      icon: Icons.insights_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppTheme.vertFaso
                            : Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        GetStorage().write('onboarding_done', true);
                        Get.offNamed('/auth');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.vertFaso,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1
                          ? 'Commencer'
                          : 'Suivant',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (_currentPage < _pages.length - 1)
                  TextButton(
                    onPressed: () {
                      GetStorage().write('onboarding_done', true);
                      Get.offNamed('/auth');
                    },
                    child: Text(
                      'Passer',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color),
                    ),
                  ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (data.image != null)
            Image.asset(
              data.image!,
              height: 300,
            )
          else if (data.icon != null)
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: AppTheme.vertFaso.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(data.icon, size: 100, color: AppTheme.vertFaso),
            ),
          const SizedBox(height: 40),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
          ),
          const SizedBox(height: 20),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String? image;
  final IconData? icon;

  OnboardingData({
    required this.title,
    required this.description,
    this.image,
    this.icon,
  });
}
