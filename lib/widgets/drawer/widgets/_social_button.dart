part of '../custom_drawer.dart';

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Function() onPressed;
  const _SocialButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: MaterialButton(
        padding: Space.all(1, .5),
        color: Provider.of<AppProvider>(context).isDark
            ? color.withOpacity(0.5)
            : color,
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            Space.x!,
            Text(
              label,
              style: AppText.b1b!.copyWith(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}