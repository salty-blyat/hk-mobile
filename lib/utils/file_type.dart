import 'dart:io';

String getFileType(String? fileName) {
  if (fileName == null || fileName.isEmpty) {
    return 'assets/images/default.png';
  }

  String extension = fileName.split('.').last.toLowerCase();

  switch (extension) {
    case 'pdf':
      return 'assets/images/pdf.png';
    case 'doc':
      return 'assets/images/docx.png';
    case 'docx':
      return 'assets/images/docx.png';
    case 'xls':
      return 'assets/images/excel.png';
    case 'xlsx':
      return 'assets/images/excel.png';
    case 'jpg':
      return 'assets/images/jpeg.png';
    case 'jpeg':
      return 'assets/images/jpeg.png';
    case 'png':
      return 'assets/images/png.png';
    default:
      return 'assets/images/default.png';
  }
}

String getMimeType({File? file, String? fileName}) {
  String extension = '';
  if (file != null) {
    extension = file.path.split('.').last.toLowerCase();
  } else if (fileName != null) {
    extension = fileName.split('.').last.toLowerCase();
  }

  // Map of file extensions to MIME types
  const mimeTypes = {
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'gif': 'image/gif',
    'bmp': 'image/bmp',
    'tiff': 'image/tiff',
    'pdf': 'application/pdf',
    'txt': 'text/plain',
    'csv': 'text/csv',
    'html': 'text/html',
    'js': 'application/javascript',
    'css': 'text/css',
    'zip': 'application/zip',
    'rar': 'application/x-rar-compressed',
    'mp4': 'video/mp4',
    'mp3': 'audio/mp3',
    'avi': 'video/x-msvideo',
    'wav': 'audio/wav',
  };

  // Return MIME type based on extension or 'application/octet-stream' if not found
  return mimeTypes[extension] ?? 'application/octet-stream';
}

bool isImageType(String url) {
  final lowerUrl = url.toLowerCase();
  final imageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.bmp',
    '.webp',
    '.svg'
  ];

  return imageExtensions.any((extension) => lowerUrl.endsWith(extension));
}
