part of '../widgets.g.dart';

class InformationRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const InformationRow({super.key, required this.label, required this.value, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label  ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
