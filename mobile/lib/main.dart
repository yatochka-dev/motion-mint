import 'package:flutter/cupertino.dart';
import 'package:mobile/screens/login.dart';
import 'package:mobile/services/auth.service.dart';
import 'dart:io' as io; // ← add this

// generated code
import 'gen/v1/auth.pb.dart';
import 'gen/v1/auth.connect.client.dart';

// connect-dart runtime
import 'package:connectrpc/io.dart' as connect_io; // dart:io HTTP stack
import 'package:connectrpc/protobuf.dart'; // ProtoCodec
import 'package:connectrpc/protocol/connect.dart'
    as protocol; // Connect protocol
//  ↑ switch to protocol.grpc / grpc_web if you ever need those

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => CupertinoApp(
        home: LoginPage(),
      );
}
