terraform{
    backend "s3"{
	      bucket          = "lb-statefile-bucket"
		    key             = "lb-key"
		    region          = "us-east-1"
		    dynamodb_table  = "lb-statefile-table"
	}	
}
