part of '../widgets.g.dart';

class TopAppBar extends StatelessWidget {
  final String? title;

  const TopAppBar({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    // var scaffold = Scaffold.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      //padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Padding(
        padding: EdgeInsets.zero,
        child: SafeArea(
          child: Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.of(context).maybePop();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ThemeConsts.appPrimaryLightBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 26,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              if (title != null)
                Text(
                  title!,
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500),
                )
            ],
          ),
        ),
      ),
    );
  }
}
