import 'package:flutter/material.dart';

class CommunityFeedWidget extends StatelessWidget {
  const CommunityFeedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Community Feed',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _FeedItem(
              avatar: Icons.person,
              username: 'flutter_dev',
              timeAgo: '2h',
              content: 'Just published a new Flutter widget template for e-commerce apps! 🚀',
              likes: 24,
              comments: 8,
            ),
            const Divider(),
            _FeedItem(
              avatar: Icons.person_outline,
              username: 'ui_designer',
              timeAgo: '4h',
              content: 'Looking for feedback on this new design system for mobile apps.',
              likes: 16,
              comments: 12,
            ),
            const Divider(),
            _FeedItem(
              avatar: Icons.account_circle,
              username: 'code_mentor',
              timeAgo: '6h',
              content: 'Pro tip: Always use const constructors for better performance!',
              likes: 45,
              comments: 3,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedItem extends StatelessWidget {
  final IconData avatar;
  final String username;
  final String timeAgo;
  final String content;
  final int likes;
  final int comments;

  const _FeedItem({
    required this.avatar,
    required this.username,
    required this.timeAgo,
    required this.content,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                child: Icon(avatar, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          username,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '• $timeAgo',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz),
                iconSize: 18,
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _ActionButton(
                icon: Icons.favorite_border,
                label: likes.toString(),
                onTap: () {},
              ),
              const SizedBox(width: 16),
              _ActionButton(
                icon: Icons.chat_bubble_outline,
                label: comments.toString(),
                onTap: () {},
              ),
              const SizedBox(width: 16),
              _ActionButton(
                icon: Icons.share_outlined,
                label: 'Share',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
