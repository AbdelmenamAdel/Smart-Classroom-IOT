import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'url_launcher.dart';

class AutherMedia extends StatelessWidget {
  const AutherMedia({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ),
            backgroundColor: colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text(
                'Meet the Developer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.code_rounded,
                    size: 80,
                    color: Colors.white.withOpacity(0.24),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const _DeveloperCard(
                    name: 'Abdelmoneim Adel',
                    role: 'Software Mobile Application Engineer',
                    image: 'assets/images/Men3em.png',
                    bio:
                        'Passionate Flutter developer with a focus on creating beautiful, functional, and user-centric mobile applications.',
                    whatsapp: '+201556878109',
                    facebook: 'https://www.facebook.com/abdelmenam.adel.10',
                    github: 'https://github.com/AbdelmenamAdel/',
                    linkedin: 'https://www.linkedin.com/in/abdelmoneim-adel',
                    playStore:
                        'https://play.google.com/store/apps/dev?id=5304471113374404966',
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: colorScheme.onSurface.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.favorite_rounded,
                          color: Colors.redAccent,
                          size: 30,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Built with Passion',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Smart Classroom is dedicated to helping people monitor their environment through beautiful, intuitive design.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeveloperCard extends StatelessWidget {
  final String name;
  final String role;
  final String image;
  final String bio;
  final String whatsapp;
  final String facebook;
  final String github;
  final String linkedin;
  final String playStore;

  const _DeveloperCard({
    required this.name,
    required this.role,
    required this.image,
    required this.bio,
    required this.whatsapp,
    required this.facebook,
    required this.github,
    required this.linkedin,
    required this.playStore,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withOpacity(0.15),
            colorScheme.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Photo
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.secondary],
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 75,
              backgroundColor: colorScheme.surface,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.person, size: 75, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            role,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            bio,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withOpacity(0.7),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Divider(color: colorScheme.onSurface.withOpacity(0.2)),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _SocialIconButton(
                icon: FontAwesomeIcons.whatsapp,
                color: const Color(0xFF25D366),
                onTap: () => urlLauncher(context, 'https://wa.me/$whatsapp'),
              ),
              _SocialIconButton(
                icon: FontAwesomeIcons.facebook,
                color: const Color(0xFF1877F2),
                onTap: () => urlLauncher(context, facebook),
              ),
              _SocialIconButton(
                icon: FontAwesomeIcons.github,
                color: colorScheme.onSurface.withOpacity(0.8),
                onTap: () => urlLauncher(context, github),
              ),
              _SocialIconButton(
                icon: FontAwesomeIcons.linkedinIn,
                color: const Color(0xFF0077B5),
                onTap: () => urlLauncher(context, linkedin),
              ),
              _SocialIconButton(
                icon: FontAwesomeIcons.googlePlay,
                color: const Color(0xFF4285F4),
                onTap: () => urlLauncher(context, playStore),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final FaIconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(isDark ? 0.15 : 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: FaIcon(icon, color: color, size: 22),
      ),
    );
  }
}
