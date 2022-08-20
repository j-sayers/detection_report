# create a task to run every day
# https://www.r-bloggers.com/2020/05/how-to-schedule-r-scripts/

taskscheduleR::taskscheduler_create(
  taskname = 'detection_reports',
  rscript = 'C:/GitHub/detection_report/DetectionReport_AllActiveOntario.R',
  startdate = '2022/07/15',
  schedule = 'HOURLY',
  modifier = 12
)


