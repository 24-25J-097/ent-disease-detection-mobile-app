part of '../widgets.g.dart';

class ImageCard extends StatelessWidget {
  final void Function()? onPressed;
  final String image;
  final String text;

  const ImageCard({
    super.key,
    this.onPressed,
    required this.image,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width/1.5,
            // margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromRGBO(255, 255, 255, 1),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(3, 3),
                  blurRadius: 5,
                  spreadRadius: 0,
                  color: Color(0x1a000000),
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  decoration: const BoxDecoration(),
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Text(
                    text,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.inter(
                      color: const Color.fromRGBO(75, 85, 99, 1),
                      fontSize: 14,
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
