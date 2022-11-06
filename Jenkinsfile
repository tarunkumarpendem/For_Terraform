pipeline{
    agent { label 'python3.10'}
    parameters{
        choice(name: 'Branch_to_Build', choices: ['main'], description: 'Selecting Branch') 
    }
    triggers{
        pollSCM('* * * * *')
    }
    post{
        always{
            echo 'build is completed'
            mail  to: 'tarunkumarpendem22@gmail.com',
                  subject: "Terraform script completed",
                  body: """Job is completed for Build id: $env.BUILD_ID \n 
                                                Build Number: $env.BUILD_ID \n
                                                Build URL: $env.BUILD_URL"""                                      
        }
        failure{
            echo 'build is failed'
            mail  to: 'tarunkumarpendem22@gmail.com',
                  subject: "Terraform script failed",
                  body: """Job is failed for Build id: $env.BUILD_ID \n 
                                                Build Number: $env.BUILD_NUMBER \n
                                                Build URL: $env.BUILD_URL \n
                                                Job URL: $JOB_URL"""
        }
        success{
            echo 'build is success'
            mail  to: 'tarunkumarpendem22@gmail.com',
                  subject: "Terraform script successfully completed and infra created",
                  body: """Job is success for Build id: $env.BUILD_ID \n  
                                              Build Number: $env.BUILD_NUMBER \n
                                              Build URL: $env.BUILD_URL \n
                                              Job URL: clickhere: $JOB_URL \n
                                              JOB Name: $JOB_NAME"""
        }
    }
    stages{
        stage('clone'){
            steps{
                git url: 'https://github.com/tarunkumarpendem/For_Terraform.git',
                    branch: "${params.Branch_to_Build}"
            }
        }
        stage('script'){
            steps{
                 //sh 'cd Autoscaling/'
                 //sh 'pwd'
                 //sh 'ls -al'
                 sh 'terraform init'
                 sh 'terraform apply -var-file="dev.tfvars" -auto-approve '
                 //sh 'terraform destroy -var-file="dev.tfvars" -auto-approve'  
            }
        } 
    }
}
