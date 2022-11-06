terraform {
  backend "s3" {
    bucket = "for-statefile-locking"
    key    = "s3statefilekey"
    region = "us-east-1"
    dynamodb_table = "for-statefile-locking"
  }
}
