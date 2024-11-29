part of '../widgets.g.dart';

Future<dynamic> chooseImagePickerSource(BuildContext context, Function(ImageSource) handleImageSelection) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => SafeArea(
      child: SizedBox(
        height: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  handleImageSelection(ImageSource.camera);
                },
                child: const Row(
                  children: [
                    Icon(Icons.camera_alt),
                    SizedBox(width: 10),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text('Camera'),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  handleImageSelection(ImageSource.gallery);
                },
                child: const Row(
                  children: [
                    Icon(Icons.photo_library),
                    SizedBox(width: 10),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text('Galley'),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
