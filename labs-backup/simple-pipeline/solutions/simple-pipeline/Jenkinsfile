pipeline {
    options {
        // set a timeout of 30 minutes for this pipeline
        timeout(time: 30, unit: 'MINUTES')
    }
    agent {
      node {
        label 'master'
      }
    }

    stages {

        stage('stage 1') {
            steps {
                script {
                    openshift.withCluster() {
                        openshift.withProject() {
                                echo "stage 1: using project: ${openshift.project()} in cluster ${openshift.cluster()}"
                        }
                    }
                }
            }
        }

        stage('stage 2') {
            steps {
                sh 'echo hello from stage 2!'
            }
        }

        stage('manual approval') {
            steps {
                timeout(time: 60, unit: 'MINUTES') {
                    input message: "Move to stage 3?"
                }
            }
        }

        stage('stage 3') {
            steps {
                sh 'echo hello from stage 3!. This is the last stage...'
            }
        }

    }
}
