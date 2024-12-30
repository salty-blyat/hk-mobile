class LeaveData {
  final int leaveDays;
  final int leaveTotal;
  final String title;

  LeaveData(
      {required this.leaveDays, required this.leaveTotal, required this.title});
}

final List<LeaveData> leaveDetailData = [
  LeaveData(leaveDays: 1, leaveTotal: 30, title: "Total"),
  LeaveData(leaveDays: 2, leaveTotal: 30, title: "Approved"),
  LeaveData(leaveDays: 3, leaveTotal: 30, title: "Pending"),
  LeaveData(leaveDays: 0, leaveTotal: 30, title: "Rejected"),
  LeaveData(leaveDays: 5, leaveTotal: 30, title: "Annual"),
  LeaveData(leaveDays: 10, leaveTotal: 30, title: "Sick"),
];
