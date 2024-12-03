bool isSvgImage(String attachment) {
  final extension = attachment.split('.').last.toLowerCase();
  return extension == 'svg';
}

bool isImageAttachment(String attachment) {
  final imageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
  final extension = attachment.split('.').last.toLowerCase();
  return imageExtensions.contains(extension);
}

bool isValidFileType(String fileName) {
  // const deniedExtensions = ['avif'];
  const deniedExtensions = [];
  final fileExtension = fileName.split('.').last.toLowerCase(); // Extract the file extension
  return !deniedExtensions.contains(fileExtension); // Check if it is in the allowed list
}
