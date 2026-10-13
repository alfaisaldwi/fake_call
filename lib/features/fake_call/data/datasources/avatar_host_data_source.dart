import 'dart:io';

import 'package:uuid/uuid.dart';

abstract class AvatarHostDataSource {
  Future<String?> resolveNativeAvatarUrl(String? localPath);
}

class AvatarHostDataSourceImpl implements AvatarHostDataSource {
  static const _contentTypes = {
    'png': 'image/png',
    'webp': 'image/webp',
    'gif': 'image/gif',
  };

  final Uuid uuid;

  HttpServer? _server;
  String? _servedPath;
  String _token = '';

  AvatarHostDataSourceImpl({required this.uuid});

  @override
  Future<String?> resolveNativeAvatarUrl(String? localPath) async {
    if (localPath == null || localPath.isEmpty) return null;
    if (localPath.startsWith('http://') || localPath.startsWith('https://')) {
      return localPath;
    }
    if (!Platform.isAndroid || !await File(localPath).exists()) return null;

    final server = await _ensureServer();
    if (_servedPath != localPath) {
      _servedPath = localPath;
      _token = uuid.v4();
    }
    return 'http://${server.address.address}:${server.port}/avatar/$_token';
  }

  Future<HttpServer> _ensureServer() async {
    final existing = _server;
    if (existing != null) return existing;
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen(_handleRequest);
    _server = server;
    return server;
  }

  Future<void> _handleRequest(HttpRequest request) async {
    final response = request.response;
    final path = _servedPath;
    final file = path == null ? null : File(path);
    if (request.uri.path != '/avatar/$_token' ||
        file == null ||
        !await file.exists()) {
      response.statusCode = HttpStatus.notFound;
      await response.close();
      return;
    }
    final extension = path!.split('.').last.toLowerCase();
    response.headers.contentType = ContentType.parse(
      _contentTypes[extension] ?? 'image/jpeg',
    );
    await response.addStream(file.openRead());
    await response.close();
  }
}
