# exercice-13

j'ai rajoutez quelque truc sur le main.tf:

Ajout d'une variable pour stocker la clé d'API Vultr

variable "vultr_api_key" {
  description = "Vultr API Key"
}

terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "2.17.1"
    }
  }
}

provider "vultr" {
  api_key     = var.vultr_api_key
  rate_limit  = 100
  retry_limit = 3
}

ce yml automatise le déploiement terra lors d'un nouveaux pull request sur la branche principale en utilisant une clé d'API vultr sécurisée: 

name: Terraform Apply

on:
  pull_request:
    branches:
      - main

jobs:
  terraform:
    runs-on: ubuntu-latest

    env:
      VULTR_API_KEY: ${{ secrets.github_pat_1 }}

    steps:
    - name: Checkout repository
      uses: actions/checkout@v2

    - name: Set up Terraform
      uses: hashicorp/setup-terraform@v1
      with:
        terraform_version: latest

    - name: Terraform Init
      run: terraform init

    - name: Terraform Plan
      run: terraform plan -out=tfplan

    - name: Terraform Apply
      if: github.event_name == 'pull_request' && github.event.action == 'opened' || github.event.action == 'synchronize'
      run: terraform apply -auto-approve tfplan

