pipeline {
    agent { label 'kube-jenkins-agent' }
    options {
        ansiColor('xterm')
    }
    stages {
        stage('Docker build & publish') {
            steps {
                container('docker') {
                    script {
                        dockerImage = docker.build "docker.fg/flowguard/opennebula"
                    }
                }
                container('jnlp') {
                    script {
                        bn = env.BUILD_NUMBER
                        gitVersion = sh(script: 'git describe --tags --always', returnStdout: true).toString().trim()
                        currentBuild.displayName = "#${bn}:${gitVersion}"
                    }
                }
                container('docker') {
                    script {
                        if (env.BRANCH_NAME == "master") {
                            dockerImage.push("latest")
                        } else {
                            dockerImage.push(gitVersion)
                        }
                    }
                }
            }
        }
    }
}
