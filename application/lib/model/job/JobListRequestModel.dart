class JobListRequestModel {
  List<JobModel> _jobs = [];
  List<JobModel> get jobs => _jobs;
  set jobs(List list) {
    _jobs = list.cast<JobModel>();
  }
}

class JobModel {
  String title = "";
}
