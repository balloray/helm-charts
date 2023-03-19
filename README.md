# helm-charts


   65  velero schedule create example-schedule --schedule="0 3 * * *"  -n default
   66  velero backup create --from-schedule example-schedule
   67  velero backup create --from-schedule example-schedule 
   68  velero backup create --from-schedule example-schedule -n default
   69  velero schedule create cluster-backup --snapshot-volumes --include-cluster-resources
   70  velero schedule create example-schedule --schedule="0 3 * * *"  -n default
   71  velero backup create --from-schedule example-schedule -n default
   72  velero backup create --from-schedule example-schedule
   73  velero backup create --help
   74  velero backup create --from-schedule example-schedule -n default
   75  velero backup create --help
   76  velero backup create  vvv  --from-schedule example-schedule -n default
   77  velero backup create  testing  --from-schedule example-schedule -n default