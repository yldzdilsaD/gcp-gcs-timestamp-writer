#!/bin/bash
set -euo pipefail

# -----------------------------------
# Paths
# -----------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="$SCRIPT_DIR/../terraform"
cd "$TERRAFORM_DIR"

# -----------------------------------
# Args
# -----------------------------------
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

# -----------------------------------
# Prod safety (only for local)
# -----------------------------------
if [[ "$ENV" == "prod" && "$ACTION" == "apply" && "${CI:-}" != "true" ]]; then
  echo "⚠️  YOU ARE APPLYING TO PROD ⚠️"
  read -p "Type 'prod' to continue: " CONFIRM
  [[ "$CONFIRM" == "prod" ]] || exit 1
fi

# -----------------------------------
# Terraform init
# -----------------------------------
terraform init -input=false

# -----------------------------------
# Build terraform command
# -----------------------------------
TF_CMD=(terraform "$ACTION" -var-file="$TFVARS")

# IMAGE override from pipeline
if [[ -n "${IMAGE:-}" ]]; then
  echo "Using IMAGE from pipeline: $IMAGE"
  TF_CMD+=(-var="image=$IMAGE")
fi

# Auto-approve only in CI and only for apply
if [[ "${CI:-}" == "true" && "$ACTION" == "apply" ]]; then
  echo "CI detected → auto-approve enabled"
  TF_CMD+=(-auto-approve)
fi

echo "-----------------------------------"
echo "Running command:"
echo "  ${TF_CMD[*]}"
echo "-----------------------------------"

# -----------------------------------
# Execute
# -----------------------------------
"${TF_CMD[@]}"
