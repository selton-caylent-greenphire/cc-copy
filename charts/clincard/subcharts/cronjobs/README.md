# cronjobs

![Version: 1.4.1](https://img.shields.io/badge/Version-1.4.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

It is a Helm chart to manage multiple Kubernetes **CronJobs** that **use** the ***ClinCard base image***.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Helene McElroy | <helene.mcelroy@greenphire.com> |  |
| Jeisson Osorio | <jeisson.osorio@greenphire.com> |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `"cronjobs"` |  |
| fullnameOverride | string | `"cronjobs"` |  |
| tier | string | `"cronjobs"` |  |
| image | string | `"160116585046.dkr.ecr.us-east-1.amazonaws.com/clincard/clincard:task-13.3.1"` | Default clincard cronjobs image |
| imagePullPolicy | string | `"Always"` |  |
| suspend | bool | `false` |  |
| restartPolicy | string | `"OnFailure"` |  |
| concurrencyPolicy | string | `"Forbid"` |  |
| schedulerName | string | `"default-scheduler"` |  |
| enableDebug | bool | `false` | Used to set the DEBUG environment variable for all CronJobs |
| historyLimits | object | `{"failedJobsHistoryLimit":3,"successfulJobsHistoryLimit":1}` | History limits that apply for all cronJobs |
| resources.limits | object | `{"cpu":"256m","memory":"256Mi"}` | Default CronJobs resources: To change specific cronjob add the values in the parameters resourcesLimitsCpu, resourcesLimitsMemory. |
| resources.requests | object | `{"cpu":"20m","memory":"128Mi"}` | Default CronJobs resources: To change specific cronjob add the values in the parameters resourcesRequestsCpu, resourcesRequestsMemory. |
| commonEnv.emailHost | string | `"smtp.sendgrid.net"` |  |
| commonEnv.emailHostUser | string | `"apikey"` |  |
| commonEnv.emailNoLogin | string | `"0"` |  |
| commonEnv.emailPort | string | `"587"` |  |
| commonEnv.emailUseTls | string | `"1"` |  |
| commonPassManagerEnv.accountName | string | `"clincardsftp"` |  |
| commonPassManagerEnv.certDir | string | `"/root/.pmp/"` |  |
| commonPassManagerEnv.hostName | string | `"locker.greenphire.net"` |  |
| commonPassManagerEnv.port | int | `7070` |  |
| commonWfEnv.enablePayments | string | `"True"` |  |
| commonWfEnv.s3BucketRegionName | string | `"us-east-1"` |  |
| dependencies.configsvc | string | `"configsvc"` | Service dependency [configsvc](https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard/subcharts/configsvc) |
| dependencies.paymentapprovals | string | `"paymentapprovals"` | Service dependency [paymentapprovals](https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard/subcharts/paymentapprovals) |
| dependencies.ridesharesvc | string | `"rideshare-svc"` | Service dependency [rideshare](https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard/subcharts/rideshare) |
| dependencies.taxablereport | string | `"taxablereport"` | Service dependency [taxablereport](https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard/subcharts/taxablereport) |
| dependencies.tenninetynine | string | `"tenninetynine"` | Service dependency [tenninetynine](https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard/subcharts/tenninetynine) |
| dependencies.clincardsecrets | string | `"clincard-secret"` | Secrets dependency [clincard](https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard) |
| dependencies.ccsshsecrets | string | `"cc-ssh-key"` | Secrets dependency [cc-ssh-key] (https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard/templates) |
| dependencies.peoplestrustftp | string | `"peoples-trust-ftp"` | Secrets dependency [peoples-trust-ftp] (https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard/templates) |
| dependencies.tplsecrets | string | `"tpl-secrets"` | Secrets dependency [tpl-secrets] (https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard/templates) |
| dependencies.passmanagersecrets | string | `"password-manager"` | Secrets dependency [password-manager] (https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard/templates) |
| dependencies.fisgpgsecrets | string | `"fis-gpg-key"` | Secrets dependency [fis-gpg-key] (https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard/templates) |
| dependencies.fissshsecrets | string | `"fis-ssh-key"` | Secrets dependency [fis-ssh-key] (https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard/templates) |
| dependencies.paymentdomainsecrets | string | `"paymentdomain"` | Secrets dependency [clincard](https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard/subcharts/paymentdomain) |
| dependencies.ridesharesecrets | string | `"rideshare-secrets"` | Secrets dependency [rideshare](https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard/subcharts/rideshare) |
| dependencies.rabbitsecrets | string | `"rabbit-secret"` | Secrets dependency [rabbit-secret](https://github.com/Greenphire/clincard-config/tree/uat/) |
| dependencies.paymentevents | string | `"paymentevents"` | Service dependency [paymentevents](https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard/subcharts/paymentevents) |
| dependencies.paymentdomain | string | `"paymentdomain"` | Service dependency [paymentdomain](https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard/subcharts/paymentdomain) |
| dependencies.redis | string | `"redis"` | Service dependency [redis](https://github.com/Greenphire/clincard-config/tree/uat/) |
| volumes.ccSshName | string | `"cc-ssh"` |  |
| volumes.ccSshMountPath | string | `"/root/.ssh"` |  |
| volumes.ccSshDefaultMode | int | `384` |  |
| volumes.mediaName | string | `"media"` |  |
| volumes.mediaMountPath | string | `"/clincard/media/clinclient/studies/receipts"` |  |
| volumes.mediaClaim | string | `"clincard-efs-%s-media"` |  |
| volumes.mediaUploadName | string | `"media-uploads"` |  |
| volumes.mediaUploadMountPath | string | `"/clincard/media/uploads"` |  |
| volumes.mediaUploadClaim | string | `"clincard-%s-media-uploads"` |  |
| volumes.dataName | string | `"data"` |  |
| volumes.dataMountPath | string | `"/clincard/data"` |  |
| volumes.dataClaim | string | `"clincard-efs-%s-data"` |  |
| volumes.pmpName | string | `"pmp-vol"` |  |
| volumes.pmpMountPath | string | `"/root/.pmp"` |  |
| volumes.pmpDefaultMode | int | `384` |  |
| volumes.fisSshName | string | `"fis-ssh"` |  |
| volumes.fisSshMountPath | string | `"/root/.ssh"` |  |
| volumes.fisSshDefaultMode | int | `384` |  |
| volumes.fisGpgName | string | `"fis-gpg"` |  |
| volumes.fisGpgMountPath | string | `"/root/.gnupg_key"` |  |
| volumes.fisGpgDefaultMode | int | `384` |  |
| volumes.pgpName | string | `"pgp"` |  |
| volumes.pgpMountPath | string | `"/.pgp"` |  |
| volumes.pgpClaim | string | `"clincard-efs-%s-pgp"` |  |
| portaldb | object | `{"database":"ccportaldatabase","db_admin":"clincard","service":"portaldb-postgres","username":"cronjobs"}` | The below values can be overridden by parent chart global values.  See clincard chart values.yaml file. |
| celery.enable | bool | `false` |  |
| celery.username | string | `"celery"` |  |
| celery.service | string | `"rabbit-rabbitmq-ha"` |  |
| rabbit.username | string | `"payments"` |  |
| rabbit.service | string | `"rabbit-rabbitmq-ha"` |  |
| rabbit.adminuser | string | `"admin"` |  |
| jira.enabled | bool | `false` |  |
| jira.user | string | `"developermailbox@greenphire.com"` |  |
| jira.greenphire_system_user | string | `"557058:ea63d1b6-7134-452c-8107-51626e1291b3"` |  |
| db.service | string | `"microservicedb-postgres"` |  |
| db.username | string | `"clincard"` |  |
| db.db_admin | string | `"clincard"` |  |
| paymentProcessingAlert.enabled | bool | `false` |  |
| paymentProcessingAlert.name | string | `"payment-processing-threshold-alert"` |  |
| paymentProcessingAlert.args[0] | string | `"python"` |  |
| paymentProcessingAlert.args[1] | string | `"/clincard/scripts/cron/payment_processing_threshold_alert.py"` |  |
| paymentProcessingAlert.schedule | string | `"0 13 * * *"` |  |
| pendingPaymentsNotification.enabled | bool | `false` |  |
| pendingPaymentsNotification.name | string | `"pending-payments-notification"` |  |
| pendingPaymentsNotification.args[0] | string | `"python"` |  |
| pendingPaymentsNotification.args[1] | string | `"/clincard/scripts/cron/pending_payment_notification.py"` |  |
| pendingPaymentsNotification.schedule | string | `"5 * * * 1-5"` |  |
| pendingPaymentsNotification.resourcesLimitsMemory | string | `"4Gi"` |  |
| recentPaymentActivityEmail.enabled | bool | `false` |  |
| recentPaymentActivityEmail.name | string | `"recent-payment-activity-email"` |  |
| recentPaymentActivityEmail.args[0] | string | `"python"` |  |
| recentPaymentActivityEmail.args[1] | string | `"/clincard/scripts/cron/recent_payment_activity_email.py"` |  |
| recentPaymentActivityEmail.schedule | string | `"5 20 * * 1-5"` |  |
| recentPaymentActivityEmail.restartPolicy | string | `"Never"` |  |
| recentPaymentActivityEmail.backoffLimit | string | `"0"` |  |
| recentPaymentActivityEmail.resourcesLimitsMemory | string | `"4Gi"` |  |
| depositStatusAlert.enabled | bool | `false` |  |
| depositStatusAlert.name | string | `"deposit-status-alert"` |  |
| depositStatusAlert.args[0] | string | `"python"` |  |
| depositStatusAlert.args[1] | string | `"/clincard/scripts/cron/deposit_status_alert.py"` |  |
| depositStatusAlert.schedule | string | `"0 12 * * *"` |  |
| negativeBalanceReport.enabled | bool | `false` |  |
| negativeBalanceReport.name | string | `"negative-balance-report"` |  |
| negativeBalanceReport.args[0] | string | `"python"` |  |
| negativeBalanceReport.args[1] | string | `"/clincard/scripts/reports/negative_balance_report.py"` |  |
| negativeBalanceReport.schedule | string | `"0 14 * * 1"` |  |
| nonUsdDepositsReport.enabled | bool | `false` |  |
| nonUsdDepositsReport.name | string | `"non-usd-deposits-report"` |  |
| nonUsdDepositsReport.args[0] | string | `"python"` |  |
| nonUsdDepositsReport.args[1] | string | `"/clincard/scripts/cron/non_usd_deposits_report.py"` |  |
| nonUsdDepositsReport.schedule | string | `"0 12 * * *"` |  |
| sendIssuanceFundingReport.enabled | bool | `false` |  |
| sendIssuanceFundingReport.name | string | `"send-issuance-funding-report"` |  |
| sendIssuanceFundingReport.args[0] | string | `"python"` |  |
| sendIssuanceFundingReport.args[1] | string | `"/clincard/scripts/cron/send_issuance_funding_report.py"` |  |
| sendIssuanceFundingReport.schedule | string | `"30 12 * * *"` |  |
| i2cCardCreationProcessor.enabled | bool | `false` |  |
| i2cCardCreationProcessor.name | string | `"i2c-card-creation-processor"` |  |
| i2cCardCreationProcessor.args[0] | string | `"python"` |  |
| i2cCardCreationProcessor.args[1] | string | `"/clincard/scripts/cron/i2c_card_creation_processor.py"` |  |
| i2cCardCreationProcessor.schedule | string | `"0 10,22 * * *"` |  |
| i2cCardCreationProcessor.customEnv.XFR_HOST | string | `"xfrtest.greenphire.com"` |  |
| i2cCardCreationProcessor.resourcesRequestsCpu | string | `"250m"` |  |
| i2cCardCreationProcessor.resourcesRequestsMemory | string | `"256Mi"` |  |
| i2cCardCreationProcessor.resourcesLimitsCpu | string | `"1500m"` |  |
| i2cCardCreationProcessor.resourcesLimitsMemory | string | `"8Gi"` |  |
| i2cCardSummaryProcessor.enabled | bool | `false` |  |
| i2cCardSummaryProcessor.name | string | `"i2c-card-summary-processor"` |  |
| i2cCardSummaryProcessor.args[0] | string | `"python"` |  |
| i2cCardSummaryProcessor.args[1] | string | `"/clincard/scripts/cron/i2c_card_summary_processor.py"` |  |
| i2cCardSummaryProcessor.schedule | string | `"0 10,22 * * *"` |  |
| i2cCardSummaryProcessor.customEnv.XFR_HOST | string | `"xfrtest.greenphire.com"` |  |
| i2cCardSummaryProcessor.resourcesRequestsCpu | string | `"250m"` |  |
| i2cCardSummaryProcessor.resourcesRequestsMemory | string | `"256Mi"` |  |
| i2cCardSummaryProcessor.resourcesLimitsCpu | string | `"1500m"` |  |
| i2cCardSummaryProcessor.resourcesLimitsMemory | string | `"8Gi"` |  |
| i2cForexProcessorCanadaPt.enabled | bool | `false` |  |
| i2cForexProcessorCanadaPt.name | string | `"i2c-forex-processor-canada-pt"` |  |
| i2cForexProcessorCanadaPt.args[0] | string | `"python"` |  |
| i2cForexProcessorCanadaPt.args[1] | string | `"/clincard/scripts/cron/i2c_forex_processor.py"` |  |
| i2cForexProcessorCanadaPt.schedule | string | `"0 10,22 * * *"` |  |
| i2cForexProcessorCanadaPt.customEnv.I2C_FOREX_HOST | string | `"sftpp.peoplemft.opentext.cloud:10022"` |  |
| i2cForexProcessorCanadaPt.customEnv.I2C_FOREX_PATH | string | `"Home/greenphire01/Inbound"` |  |
| i2cForexProcessorCorrections.enabled | bool | `false` |  |
| i2cForexProcessorCorrections.name | string | `"i2c-forex-processor-corrections"` |  |
| i2cForexProcessorCorrections.args[0] | string | `"python"` |  |
| i2cForexProcessorCorrections.args[1] | string | `"/clincard/scripts/cron/i2c_forex_processor.py"` |  |
| i2cForexProcessorCorrections.schedule | string | `"0 0 1 1 0"` |  |
| i2cForexProcessorCorrections.customEnv.I2C_FOREX_HOST | string | `"xfrtest.greenphire.com"` |  |
| i2cForexProcessorCorrections.customEnv.I2C_FOREX_PATH | string | `"vendor_file_corrections/to_greenphire"` |  |
| i2cForexProcessorCorrections.customEnv.I2C_FOREX_MULTIFACTOR | string | `"False"` |  |
| i2cForexProcessorCorrections.customEnv.I2C_FOREX_FILENAME | string | `"TPL_GP_FIN_FXDAILY"` |  |
| i2cForexProcessorEuropeTpl.enabled | bool | `false` |  |
| i2cForexProcessorEuropeTpl.name | string | `"i2c-forex-processor-europe-tpl"` |  |
| i2cForexProcessorEuropeTpl.args[0] | string | `"python"` |  |
| i2cForexProcessorEuropeTpl.args[1] | string | `"/clincard/scripts/cron/i2c_forex_processor.py"` |  |
| i2cForexProcessorEuropeTpl.schedule | string | `"0 10,22 * * *"` |  |
| i2cForexProcessorEuropeTpl.customEnv.I2C_FOREX_HOST | string | `"195.244.198.81:9822"` |  |
| i2cForexProcessorEuropeTpl.customEnv.I2C_FOREX_PATH | string | `"From_tpl"` |  |
| i2cForexProcessorEuropeTpl.customEnv.I2C_FOREX_MULTIFACTOR | string | `"True"` |  |
| i2cForexProcessorEuropeTpl.customEnv.I2C_FOREX_FILENAME | string | `"TPL_GP_FIN_FXDAILY"` |  |
| monthlyInventoryControlReport.enabled | bool | `false` |  |
| monthlyInventoryControlReport.name | string | `"monthly-inventory-control-report"` |  |
| monthlyInventoryControlReport.args[0] | string | `"python"` |  |
| monthlyInventoryControlReport.args[1] | string | `"/clincard/scripts/cron/monthly_inventory_control_report.py"` |  |
| monthlyInventoryControlReport.schedule | string | `"30 11 1 * *"` |  |
| monthlyInventoryControlReport.customEnv.JIRA_ASSIGNEE | string | `"5a0469b387c3eb1913c47dbd"` |  |
| monthlyInventoryControlReport.customEnv.CRON_K8S_REPORT_RECIPIENTS | string | `"clincard@greenphire.com,jared.steenhoff@greenphire.com,keinan.fry@greenphire.com"` |  |
| processTransferFundsTickets.enabled | bool | `false` |  |
| processTransferFundsTickets.name | string | `"process-transfer-funds-tickets"` |  |
| processTransferFundsTickets.args[0] | string | `"python"` |  |
| processTransferFundsTickets.args[1] | string | `"/clincard/scripts/cron/process_transfer_funds_tickets.py"` |  |
| processTransferFundsTickets.schedule | string | `"*/10 * * * *"` |  |
| processTransferFundsTickets.customEnv.JIRA_ASSIGNEE | string | `"null"` |  |
| travelModuleDaily.enabled | bool | `false` |  |
| travelModuleDaily.name | string | `"travel-module-daily"` |  |
| travelModuleDaily.args[0] | string | `"python"` |  |
| travelModuleDaily.args[1] | string | `"/clincard/scripts/cron/travel_module_daily.py"` |  |
| travelModuleDaily.schedule | string | `"0 16 * * *"` |  |
| travelModuleDaily.customEnv.DISABLE_MEMOIZE | string | `"True"` |  |
| travelModuleDaily.customEnv.JIRA_ASSIGNEE | string | `"557058:809f6df1-f9ea-4155-a2ba-1258e675a738"` |  |
| travelModuleHourly.enabled | bool | `false` |  |
| travelModuleHourly.name | string | `"travel-module-hourly"` |  |
| travelModuleHourly.args[0] | string | `"python"` |  |
| travelModuleHourly.args[1] | string | `"/clincard/scripts/cron/travel_module_hourly.py"` |  |
| travelModuleHourly.schedule | string | `"0 * * * *"` |  |
| travelModuleHourly.customEnv.DISABLE_MEMOIZE | string | `"True"` |  |
| travelModuleHourly.customEnv.JIRA_ASSIGNEE | string | `"557058:809f6df1-f9ea-4155-a2ba-1258e675a738"` |  |
| cbOrderMonitoring.enabled | bool | `false` |  |
| cbOrderMonitoring.name | string | `"cb-order-monitoring"` |  |
| cbOrderMonitoring.args[0] | string | `"python"` |  |
| cbOrderMonitoring.args[1] | string | `"/clincard/scripts/cron/cb_order_monitoring.py"` |  |
| cbOrderMonitoring.schedule | string | `"10 * * * *"` |  |
| cbOrderMonitoring.customEnv.PASSWORD_MANAGER_RESOURCE_ID | string | `"601"` |  |
| cbOrderMonitoring.customEnv.HOME | string | `"/root"` |  |
| cbOrderMonitoring.customEnv.PCI_SERVER_DIR | string | `"/home/ccshared/"` |  |
| cbOrderMonitoring.customEnv.PCI_SERVER_HOST | string | `"fisdev.clincard.com"` |  |
| cbOrderMonitoring.customEnv.PCI_SERVER_USER | string | `"clincardsftp"` |  |
| cbOrderMonitoring.hostAliases[0].names[0] | string | `"locker.greenphire.net"` |  |
| cbOrderMonitoring.hostAliases[0].ip | string | `"10.100.16.101"` |  |
| cbSendOrders.enabled | bool | `false` |  |
| cbSendOrders.name | string | `"cb-send-orders"` |  |
| cbSendOrders.args[0] | string | `"python"` |  |
| cbSendOrders.args[1] | string | `"/clincard/scripts/cron/cb_send_orders.py"` |  |
| cbSendOrders.schedule | string | `"30 20 * * *"` |  |
| cbSendOrders.customEnv.PASSWORD_MANAGER_RESOURCE_ID | string | `"601"` |  |
| cbSendOrders.customEnv.FIS_HOSTNAME | string | `"sftp.greenphire.com"` |  |
| cbSendOrders.customEnv.FIS_USER | string | `"autotest_fis"` |  |
| cbSendOrders.customEnv.FIS_FTP_DIR | string | `"/Cardbase/TOFIS/"` |  |
| cbSendOrders.customEnv.FIS_PUBLIC_KEY | string | `"/root/.gnupg_key/fis_pub_key.asc"` |  |
| cbSendOrders.customEnv.FIS_UIDS | string | `"Enterprise.Transmission.Group@fisglobal.com"` |  |
| cbSendOrders.hostAliases[0].names[0] | string | `"locker.greenphire.net"` |  |
| cbSendOrders.hostAliases[0].ip | string | `"10.100.16.101"` |  |
| cbSendOrders.hostAliases[1].names[0] | string | `"sftp.greenphire.com"` |  |
| cbSendOrders.hostAliases[1].ip | string | `"10.25.23.28"` |  |
| runDupePaymentsCheck.enabled | bool | `false` |  |
| runDupePaymentsCheck.name | string | `"run-dupe-payments-check"` |  |
| runDupePaymentsCheck.args[0] | string | `"python"` |  |
| runDupePaymentsCheck.args[1] | string | `"/clincard/scripts/cron/dupe_checker_non_batch.py"` |  |
| runDupePaymentsCheck.schedule | string | `"0 1 * * 0"` |  |
| runDupePaymentsCheck.client_ids | string | `""` | Comma delimited list of client Primary Keys to run the dupe-checker against |
| runDupePaymentsCheck.recipients | string | `""` | Comma delimited list of report recipients |
| runDupePaymentsCheck.database | string | `"paymentdomain"` |  |
| cardOrderReportMonthly.enabled | bool | `false` |  |
| cardOrderReportMonthly.name | string | `"card-order-report-monthly"` |  |
| cardOrderReportMonthly.args[0] | string | `"/clincard/scripts/cron/card_order_report.py"` |  |
| cardOrderReportMonthly.args[1] | string | `"bm"` |  |
| cardOrderReportMonthly.schedule | string | `"0 21 * * *"` |  |
| cardOrderReportMonthly.customEnv.CRON_K8S_REPORT_RECIPIENTS | string | `""` |  |
| cardOrderReportWeeklySupport.enabled | bool | `false` |  |
| cardOrderReportWeeklySupport.name | string | `"card-order-report-weekly-support"` |  |
| cardOrderReportWeeklySupport.args[0] | string | `"/clincard/scripts/cron/card_order_report.py"` |  |
| cardOrderReportWeeklySupport.args[1] | string | `"w"` |  |
| cardOrderReportWeeklySupport.schedule | string | `"0 8 * * 0"` |  |
| cardOrderReportWeeklySupport.customEnv.CRON_K8S_REPORT_RECIPIENTS | string | `""` |  |
| cardOrderReportWeekly.enabled | bool | `false` |  |
| cardOrderReportWeekly.name | string | `"card-order-report-weekly"` |  |
| cardOrderReportWeekly.args[0] | string | `"/clincard/scripts/cron/card_order_report.py"` |  |
| cardOrderReportWeekly.args[1] | string | `"w"` |  |
| cardOrderReportWeekly.schedule | string | `"0 8 * * 1"` |  |
| cardOrderReportWeekly.customEnv.CRON_K8S_REPORT_RECIPIENTS | string | `""` |  |
| i2cSubmitCardOrders.enabled | bool | `false` |  |
| i2cSubmitCardOrders.name | string | `"i2c-submit-card-orders"` |  |
| i2cSubmitCardOrders.schedule | string | `"0 21 * * *"` |  |
| i2cSubmitCardOrders.args[0] | string | `"python"` |  |
| i2cSubmitCardOrders.args[1] | string | `"/clincard/scripts/cron/i2c_submit_card_orders.py"` |  |
| i2cArroweyeShippingConfirmation.enabled | bool | `false` |  |
| i2cArroweyeShippingConfirmation.name | string | `"i2c-arroweye-shipping-confirmation"` |  |
| i2cArroweyeShippingConfirmation.schedule | string | `"45 23 * * *"` |  |
| i2cArroweyeShippingConfirmation.args[0] | string | `"python"` |  |
| i2cArroweyeShippingConfirmation.args[1] | string | `"/clincard/scripts/cron/arroweye_shipping_confirmation.py"` |  |
| i2cArroweyeShippingConfirmation.customEnv.ARROWEYE_SFTP_SERVER | string | `""` |  |
| i2cArroweyeShippingConfirmation.customEnv.ARROWEYE_SFTP_ROOT_DIR | string | `""` |  |
| fisArroweyeShippingConfirmation.enabled | bool | `false` |  |
| fisArroweyeShippingConfirmation.name | string | `"fis-arroweye-shipping-confirmation"` |  |
| fisArroweyeShippingConfirmation.schedule | string | `"45 23 * * *"` |  |
| fisArroweyeShippingConfirmation.args[0] | string | `"python"` |  |
| fisArroweyeShippingConfirmation.args[1] | string | `"/clincard/scripts/cron/arroweye_shipping_confirmation.py"` |  |
| fisArroweyeShippingConfirmation.customEnv.ARROWEYE_SFTP_SERVER | string | `""` |  |
| fisArroweyeShippingConfirmation.customEnv.ARROWEYE_SFTP_ROOT_DIR | string | `nil` |  |
| operationsShippingConfirmation.enabled | bool | `false` |  |
| operationsShippingConfirmation.name | string | `"operations-shipping-confirmation"` |  |
| operationsShippingConfirmation.schedule | string | `"45 */4 * * *"` |  |
| operationsShippingConfirmation.args[0] | string | `"python"` |  |
| operationsShippingConfirmation.args[1] | string | `"/clincard/scripts/cron/arroweye_shipping_confirmation.py"` |  |
| operationsShippingConfirmation.customEnv.ARROWEYE_SFTP_SERVER | string | `""` |  |
| operationsShippingConfirmation.customEnv.ARROWEYE_SFTP_ROOT_DIR | string | `""` |  |
| amcCustomExtract.enabled | bool | `false` |  |
| amcCustomExtract.name | string | `"amc-custom-extract"` |  |
| amcCustomExtract.args[0] | string | `"python"` |  |
| amcCustomExtract.args[1] | string | `"/clincard/scripts/reports/amc_custom_extract.py"` |  |
| amcCustomExtract.schedule | string | `"0 5 * * *"` |  |
| amcCustomExtract.customEnv.XFR_HOST | string | `"xfrtest.greenphire.com"` |  |
| biomarinWeeklyComplianceMessage.enabled | bool | `false` |  |
| biomarinWeeklyComplianceMessage.name | string | `"biomarin-165-304-weekly-compliance-message"` |  |
| biomarinWeeklyComplianceMessage.args[0] | string | `"python"` |  |
| biomarinWeeklyComplianceMessage.args[1] | string | `"/clincard/scripts/cron/biomarin_165_304_weekly_compliance_message.py"` |  |
| biomarinWeeklyComplianceMessage.schedule | string | `"0 17 * * 1"` |  |
| duplicatePaymentAlert.enabled | bool | `false` |  |
| duplicatePaymentAlert.name | string | `"duplicate-payment-alert"` |  |
| duplicatePaymentAlert.args[0] | string | `"python"` |  |
| duplicatePaymentAlert.args[1] | string | `"/clincard/scripts/detect_dupe_payments.py"` |  |
| duplicatePaymentAlert.schedule | string | `"0 */2 * * *"` |  |
| cbCardInfo.enabled | bool | `false` |  |
| cbCardInfo.name | string | `"cb-card-info"` |  |
| cbCardInfo.args[0] | string | `"python"` |  |
| cbCardInfo.args[1] | string | `"/clincard/scripts/cron/cb_card_info.py"` |  |
| cbCardInfo.schedule | string | `"33 8 * * *"` |  |
| cbCardInfo.customEnv.PCI_SERVER_DIR | string | `"/home/ccshared/"` |  |
| cbCardInfo.customEnv.PCI_SERVER_HOST | string | `"10.150.17.181"` |  |
| cbCardInfo.customEnv.PCI_SERVER_USER | string | `"clincardsftp"` |  |
| cbCardInfo.customEnv.PASSWORD_MANAGER_RESOURCE_ID | string | `"601"` |  |
| cbCardInfo.hostAliases[0].names[0] | string | `"xmlgateway.metavante.org"` |  |
| cbCardInfo.hostAliases[0].names[1] | string | `"ws2.mycardplace.com"` |  |
| cbCardInfo.hostAliases[0].ip | string | `"192.168.112.90"` |  |
| cbCardInfo.hostAliases[1].names[0] | string | `"locker.greenphire.net"` |  |
| cbCardInfo.hostAliases[1].ip | string | `"10.100.16.101"` |  |
| cbCardInfo.resourcesRequestsCpu | string | `"250m"` |  |
| cbCardInfo.resourcesRequestsMemory | string | `"1Gi"` |  |
| cbCardInfo.resourcesLimitsCpu | string | `"1024m"` |  |
| cbCardInfo.resourcesLimitsMemory | string | `"8Gi"` |  |
| columbiaPovertyUsageData.enabled | bool | `false` |  |
| columbiaPovertyUsageData.name | string | `"columbia-poverty-usage-data"` |  |
| columbiaPovertyUsageData.args[0] | string | `"python"` |  |
| columbiaPovertyUsageData.args[1] | string | `"/clincard/scripts/cron/poverty_card_usage.py"` |  |
| columbiaPovertyUsageData.schedule | string | `"0 0 * * *"` |  |
| columbiaPovertyPayments.enabled | bool | `false` |  |
| columbiaPovertyPayments.name | string | `"columbia-poverty-payments"` |  |
| columbiaPovertyPayments.args[0] | string | `"python"` |  |
| columbiaPovertyPayments.args[1] | string | `"/clincard/scripts/cron/columbia_poverty_payments.py"` |  |
| columbiaPovertyPayments.schedule | string | `"0 0 * * *"` |  |
| wfPullFiles.enabled | bool | `false` |  |
| wfPullFiles.name | string | `"wf-pull-files"` |  |
| wfPullFiles.args[0] | string | `"python"` |  |
| wfPullFiles.args[1] | string | `"/clincard/scripts/cron/apply_wf_pickle_info.py"` |  |
| wfPullFiles.schedule | string | `"30 15 * * *"` |  |
| wfPullFiles.customEnv.WF_S3BUCKET_BUCKET_NAME | string | `"cc-sqa-banking"` |  |
| wfPullFiles.customEnv.PASSWORD_MANAGER_ACCOUNT_NAME | string | `"clincard_xfr"` |  |
| wfPullFiles.customEnv.PASSWORD_MANAGER_RESOURCE_ID | string | `"2101"` |  |
| wfPullFiles.customEnv.WF_SFTP_PROD_SERVER | string | `"10.25.23.28"` |  |
| wfPullFiles.customEnv.WF_SFTP_USER | string | `"clincard_xfr"` |  |
| wfPullFiles.hostAliases[0].names[0] | string | `"locker.greenphire.net"` |  |
| wfPullFiles.hostAliases[0].ip | string | `"10.100.16.101"` |  |
| wfPushFiles.enabled | bool | `false` |  |
| wfPushFiles.name | string | `"wf-push-files"` |  |
| wfPushFiles.args[0] | string | `"python"` |  |
| wfPushFiles.args[1] | string | `"/clincard/scripts/cron/wf_push_files.py"` |  |
| wfPushFiles.schedule | string | `"30 19 * * 1-5"` |  |
| wfPushFiles.customEnv.WF_S3BUCKET_BUCKET_NAME | string | `"cc-sqa-banking"` |  |
| wfPushFiles.customEnv.PASSWORD_MANAGER_ACCOUNT_NAME | string | `"clincard_xfr"` |  |
| wfPushFiles.customEnv.PASSWORD_MANAGER_RESOURCE_ID | string | `"2101"` |  |
| wfPushFiles.customEnv.WF_SFTP_PROD_SERVER | string | `"10.25.23.28"` |  |
| wfPushFiles.customEnv.WF_SFTP_USER | string | `"clincard_xfr"` |  |
| wfPushFiles.hostAliases[0].names[0] | string | `"locker.greenphire.net"` |  |
| wfPushFiles.hostAliases[0].ip | string | `"10.100.16.101"` |  |
| sendAppointmentReminders.enabled | bool | `false` |  |
| sendAppointmentReminders.name | string | `"send-appointment-reminders"` |  |
| sendAppointmentReminders.args[0] | string | `"python"` |  |
| sendAppointmentReminders.args[1] | string | `"/clincard/scripts/cron/appointment_reminders.py"` |  |
| sendAppointmentReminders.schedule | string | `"*/5 * * * *"` |  |
| sendAppointmentReminders.customEnv.USE_DEMO_PG | string | `"True"` |  |
| sendAppointmentReminders.customEnv.PAYMENTS_EXCHANGE | string | `"payments"` |  |
| sendAppointmentReminders.customEnv.PAYMENTS_QUEUE | string | `"payment_processing"` |  |
| sendBalanceRemindersFis.enabled | bool | `false` |  |
| sendBalanceRemindersFis.name | string | `"send-balance-reminders-fis"` |  |
| sendBalanceRemindersFis.args[0] | string | `"python"` |  |
| sendBalanceRemindersFis.args[1] | string | `"/clincard/scripts/cron/send_balance_reminders.py"` |  |
| sendBalanceRemindersFis.args[2] | string | `"fis"` |  |
| sendBalanceRemindersFis.schedule | string | `"*/5 * * * *"` |  |
| sendBalanceRemindersFis.customEnv.USE_DEMO_PG | string | `"True"` |  |
| sendBalanceRemindersFis.customEnv.PAYMENTS_EXCHANGE | string | `"payments"` |  |
| sendBalanceRemindersFis.customEnv.PAYMENTS_QUEUE | string | `"payment_processing"` |  |
| sendBalanceRemindersFis.customEnv.STATIC_URL | string | `"https://uat-static.clincard.com/"` |  |
| sendBalanceRemindersFis.customEnv.RIDESHARE_FEE | string | `"6.0"` |  |
| sendBalanceRemindersI2cCan.enabled | bool | `false` |  |
| sendBalanceRemindersI2cCan.name | string | `"send-balance-reminders-i2c-can"` |  |
| sendBalanceRemindersI2cCan.args[0] | string | `"python"` |  |
| sendBalanceRemindersI2cCan.args[1] | string | `"/clincard/scripts/cron/send_balance_reminders.py"` |  |
| sendBalanceRemindersI2cCan.args[2] | string | `"i2c_can"` |  |
| sendBalanceRemindersI2cCan.schedule | string | `"0 12 * * *"` |  |
| sendBalanceRemindersI2cEU.enabled | bool | `false` |  |
| sendBalanceRemindersI2cEU.name | string | `"send-balance-reminders-i2c-eu"` |  |
| sendBalanceRemindersI2cEU.args[0] | string | `"python"` |  |
| sendBalanceRemindersI2cEU.args[1] | string | `"/clincard/scripts/cron/send_balance_reminders.py"` |  |
| sendBalanceRemindersI2cEU.args[2] | string | `"i2c_eu"` |  |
| sendBalanceRemindersI2cEU.schedule | string | `"0 5 * * *"` |  |
| sendBalanceRemindersI2cEU.customEnv.USE_DEMO_PG | string | `"True"` |  |
| sendBalanceRemindersI2cEU.customEnv.PAYMENTS_EXCHANGE | string | `"payments"` |  |
| sendBalanceRemindersI2cEU.customEnv.PAYMENTS_QUEUE | string | `"payment_processing"` |  |
| sendBalanceRemindersI2cEU.customEnv.STATIC_URL | string | `"https://uat-static.clincard.com/"` |  |
| sendBalanceRemindersI2cEU.customEnv.RIDESHARE_FEE | string | `"6.0"` |  |
| sendBalanceRemindersI2cUS.enabled | bool | `false` |  |
| sendBalanceRemindersI2cUS.name | string | `"send-balance-reminders-i2c-us"` |  |
| sendBalanceRemindersI2cUS.args[0] | string | `"python"` |  |
| sendBalanceRemindersI2cUS.args[1] | string | `"/clincard/scripts/cron/send_balance_reminders.py"` |  |
| sendBalanceRemindersI2cUS.args[2] | string | `"i2c_us"` |  |
| sendBalanceRemindersI2cUS.schedule | string | `"0 5 * * *"` |  |
| sendBalanceRemindersI2cUS.customEnv.USE_DEMO_PG | string | `"True"` |  |
| sendBalanceRemindersI2cUS.customEnv.PAYMENTS_EXCHANGE | string | `"payments"` |  |
| sendBalanceRemindersI2cUS.customEnv.PAYMENTS_QUEUE | string | `"payment_processing"` |  |
| sendBalanceRemindersI2cUS.customEnv.STATIC_URL | string | `"https://uat-static.clincard.com/"` |  |
| sendBalanceRemindersI2cUS.customEnv.RIDESHARE_FEE | string | `"6.0"` |  |
| smsHandler.enabled | bool | `false` |  |
| smsHandler.name | string | `"sms-handler"` |  |
| smsHandler.args[0] | string | `"python"` |  |
| smsHandler.args[1] | string | `"/clincard/scripts/cron/sms_handler.py"` |  |
| smsHandler.schedule | string | `"*/5 * * * *"` |  |
| batchProcessorSftp.enabled | bool | `false` |  |
| batchProcessorSftp.name | string | `"batch-processor-sftp"` |  |
| batchProcessorSftp.args[0] | string | `"python"` |  |
| batchProcessorSftp.args[1] | string | `"/clincard/scripts/run_batch_processor.py"` |  |
| batchProcessorSftp.schedule | string | `"*/30 * * * *"` |  |
| batchProcessorSftp.resourcesRequestsCpu | string | `"1024m"` |  |
| batchProcessorSftp.resourcesRequestsMemory | string | `"3Gi"` |  |
| batchProcessorSftp.resourcesLimitsCpu | string | `"1024m"` |  |
| batchProcessorSftp.resourcesLimitsMemory | string | `"5Gi"` |  |
| batchProcessorSftp.ccSshDefaultMode | string | `"0600"` |  |
| batchProcessorSftp.database | string | `"paymentdomain"` |  |
| batchProcessorSftp.customEnv.XFR_HOST | string | `"10.25.23.28"` |  |
| batchProcessorSftp.customEnv.GNUPG_HOMEDIR | string | `"/.pgp"` |  |
| batchProcessorSftp.customEnv.BATCHFILE_ADMIN_LIST | string | `"clincard@greenphire.com"` |  |
| batchProcessorSftp.customEnv.BATCHFILE_ALERTS_ENABLED | string | `"True"` |  |
| batchProcessorSftp.customEnv.BATCH_PAYMENT_SLEEP_LENGTH | string | `".2"` |  |
| batchProcessorSftp.customEnv.PAYMENTS_EXCHANGE | string | `"payments"` |  |
| batchProcessorSftp.customEnv.PAYMENTS_QUEUE | string | `"payment_processing"` |  |
| batchProcessorSftp.customEnv.RABBIT_QUEUE_LIMIT | string | `"15"` |  |
| batchProcessorSftp.customEnv.RABBIT_MEMORY_USAGE_LIMIT | string | `".90"` |  |
| batchProcessorSftp.customCCSecretsEnv | object | `{"GOOGLE_MAPS_API_KEY":"google_maps_api_key","RABBIT_ADMIN_PASS":"rabbit_adminpass","RABBIT_PASS":"rabbit_userpass"}` | In this section, you could put secrets that must exist in clincard-secrets,  or you need to define them into the clincardsecrets block in the flux release file.   |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
