// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_model.freezed.dart';
part 'organization_model.g.dart'; // For JSON serialization

@freezed
class OrganizationModel with _$OrganizationModel {
  const factory OrganizationModel({
    required int id,
    required String name,
  }) = _OrganizationModel;

  factory OrganizationModel.fromJson(Map<String, dynamic> json) => _$OrganizationModelFromJson(json);
}
