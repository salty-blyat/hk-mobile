import 'package:get/get.dart';
import 'package:staff_view_ui/models/lookup_model.dart';
import 'package:staff_view_ui/pages/lookup/lookup_service.dart';

enum LookupTypeEnum {
  gender,
  nationality,
  executionStatus, // ស្ថានភាព EXEC
  executionStatusAlt, // ប្រភេទ EXEC
  transactionType,
  requestStatuses,
  reservationStatuses,
  amenityType,
  housekeepingStatus,
  roomAvailabilityStatus,
  rateType,
  roomClass,
  position,
  title,
  country,
  idTypes,
  guestType,
  cancelReason,
  accountStatus,
  nightAuditStatus,
}

extension LookupTypeEnumExtension on LookupTypeEnum {
  static const Map<LookupTypeEnum, int> _values = {
    LookupTypeEnum.gender: 1,
    LookupTypeEnum.nationality: 2,
    LookupTypeEnum.executionStatus: 3,
    LookupTypeEnum.executionStatusAlt: 4,
    LookupTypeEnum.transactionType: 36019,
    LookupTypeEnum.requestStatuses: 36015,
    LookupTypeEnum.reservationStatuses: 36012,
    LookupTypeEnum.amenityType: 36003,
    LookupTypeEnum.housekeepingStatus: 36002,
    LookupTypeEnum.roomAvailabilityStatus: 36001,
    LookupTypeEnum.rateType: 36007,
    LookupTypeEnum.roomClass: 36005,
    LookupTypeEnum.position: 36004,
    LookupTypeEnum.title: 36009,
    LookupTypeEnum.country: 36011,
    LookupTypeEnum.idTypes: 36010,
    LookupTypeEnum.guestType: 36008,
    LookupTypeEnum.cancelReason: 36016,
    LookupTypeEnum.accountStatus: 36017,
    LookupTypeEnum.nightAuditStatus: 36018,
  };

  int get value => _values[this]!;
}

class LookupController extends GetxController {
  final LookupService service = LookupService();
  final lookups = <LookupModel>[].obs;
  final isLoading = false.obs;

  Future<void> fetchLookups(int lookupTypeId) async {
    isLoading.value = true;
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
