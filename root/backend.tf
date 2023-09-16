terraform {
  backend "s3" {
    bucket         = "tfstate-ashutosh-two-tier-archtecture-project-us-east-1"
    key            = "backend/10weeksofcloudops-demo.tfstate"
    region         = "us-east-1"
    dynamodb_table = "remote-backend"
  }
}