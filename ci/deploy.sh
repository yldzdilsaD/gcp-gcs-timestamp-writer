#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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

if [[ "$ENV" == "prod" && "$ACTION" == "apply" && "${CI:-}" != "true" ]]; then
  echo "YOU ARE APPLYING TO PROD"
  read -p "Type 'prod' to continue: " CONFIRM
  [[ "$CONFIRM" == "prod" ]] || exit 1
fi

terraform init -input=false

TF_CMD=(terraform "$ACTION" -var-file="$TFVARS")

# imaj pipelinedan alınacak sh her seferinde güncellendiği için
if [[ -n "${IMAGE:-}" ]]; then
  echo "Using IMAGE from pipeline: $IMAGE"
  TF_CMD+=(-var="image=$IMAGE")
fi

# sadece ci için otomatik aprrove
if [[ "${CI:-}" == "true" && "$ACTION" == "apply" ]]; then
  echo "CI detected → auto-approve enabled"
  TF_CMD+=(-auto-approve)
fi

echo "-----------------------------------"
echo "Running command:"
echo "  ${TF_CMD[*]}"
echo "-----------------------------------"

"${TF_CMD[@]}"
