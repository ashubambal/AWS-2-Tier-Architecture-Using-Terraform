terraform {
  backend "s3" {
    bucket         = "tfstate-ashutosh-two-tier-archtecture-project"
    key            = "backend/10weeksofcloudops-demo.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "remote-backend"
  }
}