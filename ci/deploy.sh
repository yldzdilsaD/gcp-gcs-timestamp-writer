#!/bin/bash
set -euo pipefail

# deploy.sh dosyasının bulunduğu dizin (ci/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Terraform root dizini (ci'nin kardeşi)
TERRAFORM_DIR="$SCRIPT_DIR/../terraform"

cd "$TERRAFORM_DIR"

ENV=${1:-}
ACTION=${2:-}

if [[ -z "$ENV" || -z "$ACTION" ]]; then
  echo "Usage: ./ci/deploy.sh [dev|prod] [plan|apply]"
  exit 1
fi

if [[ "$ENV" != "dev" && "$ENV" != "prod" ]]; then
  echo "Environment must be dev or prod"
  exit 1
fi

if [[ "$ACTION" != "plan" && "$ACTION" != "apply" ]]; then
  echo "Action must be plan or apply"
  exit 1
fi

TFVARS="envs/$ENV.tfvars"

if [[ ! -f "$TFVARS" ]]; then
  echo "tfvars file not found: $TFVARS"
  exit 1
fi

echo "-----------------------------------"
echo " Environment : $ENV"
echo " Action      : $ACTION"
echo " Terraform   : $(pwd)"
echo " Vars file   : $TFVARS"
echo "-----------------------------------"

# Prod için ekstra emniyet
if [[ "$ENV" == "prod" && "$ACTION" == "apply" ]]; then
  echo "⚠️  YOU ARE APPLYING TO PROD ⚠️"
  read -p "Type 'prod' to continue: " CONFIRM
  [[ "$CONFIRM" == "prod" ]] || exit 1
fi

terraform init -input=false

if [[ -n "${IMAGE:-}" ]]; then
  echo "Using IMAGE from pipeline: $IMAGE"
  terraform $ACTION -auto-approve -var-file="$TFVARS" -var="image=$IMAGE"
else
  terraform $ACTION -auto-approve -var-file="$TFVARS"
fi

#Script her nereden çağrılırsa çağrılsın
 #
 #Terraform hep doğru klasörde çalışır
 #
 #envs/dev.tfvars yolu bozulmaz
 #
 #GitHub Actions’ta da birebir aynı çalışır