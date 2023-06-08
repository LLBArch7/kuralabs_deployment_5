pipeline {
  agent any
   stages {
    stage ('Build') {
      steps {
        sh '''#!/bin/bash
        python3 -m venv test3
        source test3/bin/activate
        pip install pip --upgrade
        pip install -r requirements.txt
        export FLASK_APP=application
        flask run &
        '''
     }
   }
    stage ('test') {
      steps {
        sh '''#!/bin/bash
        source test3/bin/activate
        py.test --verbose --junit-xml test-reports/results.xml
        ''' 
      }
    
      post{
        always {
          junit 'test-reports/results.xml'
        }
       
      }
    }
   
     stage('CreateContainer') {
       agent{label 'DockerAgent'}
       steps {
        sh 'sudo docker build -t llbarch7/dep5:latest .'
    }
   }
     stage('PushtoDockerhub') {
       agent{label 'DockerAgent'}
       steps {
        sh 'sudo docker push -t llbarch7/dep5:latest'
    }
   }
     stage('DeploytoECS') {
       agent{label 'TerraformAgent'}
       steps {
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                            dir('intTerraform') {
                              sh '''
                              terraform init
                              terraform plan -out plan.tfplan -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"
                              terraform apply plan.tfplan
                              ''' 
                            }
         }
    }
   }
/*
      stage('Destroy'){
       agent{label 'TerraformAgent'}
       steps{
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'),
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                            dir('intTerraform'){
                              sh 'terraform destroy -auto-approve -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"'
                              }
                          }
        }
      }
*/
   }
}
