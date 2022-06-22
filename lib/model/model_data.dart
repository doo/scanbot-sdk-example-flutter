class ImagePickerResponse {
  List<String>? uris;

  ImagePickerResponse({this.uris});

  ImagePickerResponse.fromJson(Map<String, dynamic> json) {
    uris = json['uris'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uris'] = this.uris;
    return data;
  }
}
