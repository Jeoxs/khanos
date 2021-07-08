// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.id,
    this.username,
    this.password,
    this.isLdapUser,
    this.name,
    this.email,
    this.googleId,
    this.githubId,
    this.notificationsEnabled,
    this.timezone,
    this.language,
    this.disableLoginForm,
    this.twofactorActivated,
    this.twofactorSecret,
    this.token,
    this.notificationsFilter,
    this.nbFailedLogin,
    this.lockExpirationDate,
    this.gitlabId,
    this.role,
    this.isActive,
    this.avatarPath,
    this.apiAccessToken,
    this.filter,
  });

  String id;
  String username;
  String password;
  String isLdapUser;
  String name;
  String email;
  String googleId;
  String githubId;
  String notificationsEnabled;
  String timezone;
  String language;
  String disableLoginForm;
  String twofactorActivated;
  String twofactorSecret;
  String token;
  String notificationsFilter;
  String nbFailedLogin;
  String lockExpirationDate;
  String gitlabId;
  String role;
  String isActive;
  String avatarPath;
  String apiAccessToken;
  String filter;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        username: json["username"],
        password: json["password"],
        isLdapUser: json["is_ldap_user"],
        name: json["name"],
        email: json["email"],
        googleId: json["google_id"],
        githubId: json["github_id"],
        notificationsEnabled: json["notifications_enabled"],
        timezone: json["timezone"],
        language: json["language"],
        disableLoginForm: json["disable_login_form"],
        twofactorActivated: json["twofactor_activated"],
        twofactorSecret: json["twofactor_secret"],
        token: json["token"],
        notificationsFilter: json["notifications_filter"],
        nbFailedLogin: json["nb_failed_login"],
        lockExpirationDate: json["lock_expiration_date"],
        gitlabId: json["gitlab_id"],
        role: json["role"],
        isActive: json["is_active"],
        avatarPath: json["avatar_path"],
        apiAccessToken: json["api_access_token"],
        filter: json["filter"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "password": password,
        "is_ldap_user": isLdapUser,
        "name": name,
        "email": email,
        "google_id": googleId,
        "github_id": githubId,
        "notifications_enabled": notificationsEnabled,
        "timezone": timezone,
        "language": language,
        "disable_login_form": disableLoginForm,
        "twofactor_activated": twofactorActivated,
        "twofactor_secret": twofactorSecret,
        "token": token,
        "notifications_filter": notificationsFilter,
        "nb_failed_login": nbFailedLogin,
        "lock_expiration_date": lockExpirationDate,
        "gitlab_id": gitlabId,
        "role": role,
        "is_active": isActive,
        "avatar_path": avatarPath,
        "api_access_token": apiAccessToken,
        "filter": filter,
      };
}
