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


    velero restore create --from-schedule  example-schedule -n default



sudo apt update && sudo apt install gpg wget

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install vault






vault secrets enable -version=1 -path=concourse/main kv



vault policy write concourse ./concourse-policy.hcl


vault auth enable approle


vault write auth/approle/role/concourse policies=concourse period=1h


vault read auth/approle/role/concourse/role-id


vault write -f auth/approle/role/concourse/secret-id


vault kv put -mount=concourse/main  my-secret key="I'M IN VAULT" 

