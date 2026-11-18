import 'package:flutter/material.dart';
import 'package:ncare/widgets/custom_bottom_nav_bar.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HelpSupportScreen(),
  ));
}

// ---------------------------------------------------------------------------
// 1. Support Option Data Model
// ---------------------------------------------------------------------------
class SupportOption {
  final String title;
  final String subtitle;
  final Widget iconWidget;
  final VoidCallback onTap;

  const SupportOption({
    required this.title,
    required this.subtitle,
    required this.iconWidget,
    required this.onTap,
  });
}

// ---------------------------------------------------------------------------
// 2. Main Help & Support Screen
// ---------------------------------------------------------------------------
class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final int _currentNavIndex = 4; // 'Profile' tab active

  @override
  Widget build(BuildContext context) {
    // Support Options Configuration
    final List<SupportOption> supportOptions = [
      SupportOption(
        title: 'Chat with Us',
        subtitle: 'Get instant support',
        iconWidget: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFF25D366),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Opening chat support...')),
          );
        },
      ),
      SupportOption(
        title: 'Call Us',
        subtitle: '+91 000 0000 000',
        iconWidget: Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: Color(0xFF505BAC),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.phone,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Calling +91 000 0000 000...')),
          );
        },
      ),
      SupportOption(
        title: 'FAQs',
        subtitle: 'Find answers to common questions',
        iconWidget: Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: Color(0xFF333333),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.question_mark_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Opening FAQs...')),
          );
        },
      ),
      SupportOption(
        title: 'Raise a Ticket',
        subtitle: 'We will get back to you',
        iconWidget: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF333333), width: 1.5),
          ),
          child: const Center(
            child: Icon(
              Icons.confirmation_number_outlined,
              color: Color(0xFF333333),
              size: 20,
            ),
          ),
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Opening Ticket Creation form...')),
          );
        },
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF3880C9), // Top primary blue
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Help & Support',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // White Curved Main Sheet
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 28, 16, 20),
                    child: Column(
                      children: [
                        // Centered Heading & Subtitle
                        const Text(
                          'How can we help you?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E242B),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "We're here to assist you",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF718096),
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Options Cards List
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: supportOptions.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final option = supportOptions[index];
                            return SupportOptionCard(option: option);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) => handleBottomNavTap(
          context,
          index,
          currentIndex: _currentNavIndex,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Support Option Card Widget
// ---------------------------------------------------------------------------
class SupportOptionCard extends StatelessWidget {
  final SupportOption option;

  const SupportOptionCard({
    super.key,
    required this.option,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: option.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE5E9EE),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.015),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Outlined Icon Frame Box
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFEBEFF4),
                  width: 1.2,
                ),
              ),
              child: Center(
                child: option.iconWidget,
              ),
            ),

            const SizedBox(width: 16),

            // Title and Subtitle Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    option.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E242B),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    option.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF718096),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

