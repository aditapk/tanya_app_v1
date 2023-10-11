import '../Model/user_info_model.dart';

class UserInfoUtils {
  static isNullMedicalInfo(UserInfo userInfo) {
    return (userInfo.weight == null &&
            userInfo.hight == null &&
            userInfo.pressure == null &&
            userInfo.fPG == null &&
            userInfo.hbA1c == null &&
            userInfo.creatinine == null &&
            userInfo.gFR == null &&
            userInfo.totalCholesterol == null &&
            userInfo.triglyceride == null &&
            userInfo.hDLc == null &&
            userInfo.lDLc == null &&
            userInfo.aST == null &&
            userInfo.aLT == null &&
            userInfo.aLP == null &&
            userInfo.t3 == null &&
            userInfo.freeT3 == null &&
            userInfo.freeT4 == null &&
            userInfo.tSH == null &&
            userInfo.otherCheckup == null)
        ? true
        : false;
  }

  static isNullPersonalInfo(UserInfo? userInfo) {
    if (userInfo!.name == null &&
        userInfo.address == null &&
        userInfo.doctorName == null) {
      return true;
    }
    return false;
  }
}
