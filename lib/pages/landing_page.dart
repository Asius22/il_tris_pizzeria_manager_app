import 'package:flutter/material.dart';
import 'package:il_tris_manager/pages/lingue_page.dart';
import 'package:il_tris_manager/pages/menu_bloc_page.dart';
import 'package:il_tris_manager/pages/orari_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  static const String routeName = '/';
  static const Map<String, String> actions = {
    'Modifica Menu': MenuBlocPage.routeName,
    'Modifica Orari': OrariPage.routeName,
    'Aggiungi Lingua': LinguaPage.routeName,
  };

  static const Map<String, IconData> _icons = {
    'Modifica Menu': Icons.restaurant_menu_outlined,
    'Modifica Orari': Icons.schedule_outlined,
    'Aggiungi Lingua': Icons.translate_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 24),
                Text(
                  'Gestisci dati',
                  style: textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Aggiorna menu, orari e lingue del sito.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 700 ? 3 : 1;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: actions.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 132,
                      ),
                      itemBuilder: (context, index) {
                        final title = actions.keys.elementAt(index);
                        return _ActionCard(
                          title: title,
                          icon: _icons[title]!,
                          routeName: actions[title]!,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.icon,
    required this.routeName,
  });

  final String title;
  final IconData icon;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => Navigator.of(context).pushNamed(routeName),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: colorScheme.primary),
              const Spacer(),
              Text(title, style: textTheme.titleMedium),
              const SizedBox(height: 4),
              Icon(
                Icons.arrow_forward_outlined,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
