// ignore_for_file: public_member_api_docs, sort_constructors_first
class AutocompletePrediction {
  final String? description;

  final String? placeId;
  final String? reference;
  AutocompletePrediction({
    this.description,
    this.placeId,
    this.reference,
  });

  factory AutocompletePrediction.fromJson(Map<String, dynamic> map) {
    return AutocompletePrediction(
      description: map['description'] as String?,
      placeId: map['placeId'] as String?,
      reference: map['reference'] as String,
    );
  }
}
