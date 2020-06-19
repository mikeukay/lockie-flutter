import 'package:equatable/equatable.dart';

class Code extends Equatable {
  final String name;
  final String seed;
  final String localImagePath;
  final String storageUrl;
  final String blurhash;

  Code({this.name, this.seed, this.localImagePath, this.storageUrl, this.blurhash});

  @override
  List<Object> get props => [name, seed, localImagePath, storageUrl, blurhash];

  @override
  String toString() => 'Code { name: $name, blurhash: $blurhash }';

  Map<String, dynamic> get asDocument{
    return {'name': name, 'seed': seed, 'storageUrl': storageUrl, 'blurhash': blurhash};
  }

  static Code fromObject(dynamic obj) {
    return Code(name: obj['name'], seed: obj['seed'], storageUrl: obj['storageUrl'], blurhash: obj['blurhash']);
  }

  Code copyWith({
    String name,
    String seed,
    String localImagePath,
    String storageUrl,
    String blurhash,
  }) {
    return new Code(
      name: name ?? this.name,
      seed: seed ?? this.seed,
      localImagePath: localImagePath ?? this.localImagePath,
      storageUrl: storageUrl ?? this.storageUrl,
      blurhash: blurhash ?? this.blurhash
    );
  }
}