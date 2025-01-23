import 'package:get/get.dart';
import 'package:staff_view_ui/models/lookup_model.dart';
import 'package:staff_view_ui/pages/lookup/lookup_service.dart';

enum LookupTypeEnum {
  gender,
  nationality,
  contractType,
  maritalStatus,
  languageLevel,
  language,
  educationLevel,
  identificationType,
  staffStatus,
  title,
  missionType,
  location,
  salaryRankType,
  awardType,
  positionLevel,
  country,
  enrollStatus,
  ethnicity,
  warningType,
  promotionType,
  educationType,
  deviceStatus,
  enrollmentStatus,
  checkInOutType,
  approveStatus,
  documentType,
  transactionType,
  budgetType,
  departmentType,
  workingZoneStatus,
  exceptionType,
  workingHourCalculation,
  missionStatus,
  absentException,
}

extension LookupTypeEnumExtension on LookupTypeEnum {
  static const Map<LookupTypeEnum, int> _values = {
    LookupTypeEnum.gender: 1,
    LookupTypeEnum.nationality: 2,
    LookupTypeEnum.contractType: 3,
    LookupTypeEnum.maritalStatus: 5,
    LookupTypeEnum.languageLevel: 6,
    LookupTypeEnum.language: 7,
    LookupTypeEnum.educationLevel: 8,
    LookupTypeEnum.identificationType: 9,
    LookupTypeEnum.staffStatus: 10,
    LookupTypeEnum.title: 11,
    LookupTypeEnum.missionType: 12,
    LookupTypeEnum.location: 13,
    LookupTypeEnum.salaryRankType: 14,
    LookupTypeEnum.awardType: 15,
    LookupTypeEnum.positionLevel: 16,
    LookupTypeEnum.country: 17,
    LookupTypeEnum.enrollStatus: 18,
    LookupTypeEnum.ethnicity: 19,
    LookupTypeEnum.warningType: 20,
    LookupTypeEnum.promotionType: 21,
    LookupTypeEnum.educationType: 22,
    LookupTypeEnum.deviceStatus: 23,
    LookupTypeEnum.enrollmentStatus: 24,
    LookupTypeEnum.checkInOutType: 25,
    LookupTypeEnum.approveStatus: 26,
    LookupTypeEnum.documentType: 27,
    LookupTypeEnum.transactionType: 28,
    LookupTypeEnum.budgetType: 29,
    LookupTypeEnum.departmentType: 30,
    LookupTypeEnum.workingZoneStatus: 31,
    LookupTypeEnum.exceptionType: 32,
    LookupTypeEnum.workingHourCalculation: 33,
    LookupTypeEnum.missionStatus: 34,
    LookupTypeEnum.absentException: 35,
  };

  int get value => _values[this]!;
}

class LookupController extends GetxController {
  final LookupService service = LookupService();
  final lookups = <LookupModel>[].obs;
  final isLoading = false.obs;

  Future<void> fetchLookups(int lookupTypeId) async {
    try {
      final fetchedLookups = await service.getLookup(lookupTypeId);
      lookups.assignAll(fetchedLookups);
    } catch (e) {
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
