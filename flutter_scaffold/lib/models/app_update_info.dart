class AppUpdateInfo {
  AppUpdateInfo({
    this.version,
    this.changelog,
    this.apkMd5,
    this.androidReleaseUrl,
    this.iosReleaseUrl,
  });

  AppUpdateInfo.fromJson(Map<String, dynamic> map) {
    version = map['version'] as String;
    changelog = (map['changelog'] as List).cast<String>();
    apkMd5 = map['apkMd5'] as String;
    androidReleaseUrl = map['androidReleaseUrl'] as String;
    iosReleaseUrl = map['iosReleaseUrl'] as String;
  }

  String version;
  List<String> changelog;
  String apkMd5;
  String androidReleaseUrl;
  String iosReleaseUrl;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['version'] = version;
    data['changelog'] = changelog;
    data['apkMd5'] = apkMd5;
    data['androidReleaseUrl'] = androidReleaseUrl;
    data['iosReleaseUrl'] = iosReleaseUrl;

    return data;
  }
}
