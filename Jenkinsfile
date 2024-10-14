def label = "jenkin-slave${UUID.randomUUID().toString()}"
cluster = 'ovh'
JENKINS_URL = "${JENKINS_URL}"
jenkinUrlIndexOf = JENKINS_URL.indexOf('local')

if (jenkinUrlIndexOf > -1) {
  cluster = 'local'
}

cloud = "kubernetes-${cluster}"
serviceAccount = "sa-jenkins-${cluster}"

podTemplate(
  label: label,
  cloud: cloud,
  serviceAccount: serviceAccount,
  containers: [
    containerTemplate(name: 'jnlp', image: 'jenkins/jnlp-slave:4.13.3-1-jdk11', args: '${computer.jnlpmac} ${computer.name}'),
    containerTemplate(name: 'docker', image: 'docker', command: 'cat', ttyEnabled: true),
    containerTemplate(name: 'ansible', image: 'danhnt/ansible:2.14.4', command: 'cat', ttyEnabled: true)
  ],
  imagePullSecrets: ['k8s-registry'],
  volumes: [
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
  ]
)
{
  node(label){
    stage('Integration Test') {
      container('ansible') {
        checkout scm
        withCredentials([usernamePassword(credentialsId: 'ansible_ssh_pc1', passwordVariable: 'ANSIBLE_PASSWORD', usernameVariable: 'ANSIBLE_USER')]) {
          sh 'echo "pc1 ansible_host=192.168.1.106 ansible_user=${ANSIBLE_USER} ansible_password=${ANSIBLE_PASSWORD} ansible_port=22 become_user=${ANSIBLE_USER} forever=/home/administrator/.nvm/versions/node/v14.21.1/bin/forever" >> ./host.ini'
        }
        withCredentials([usernamePassword(credentialsId: 'ansible_ssh_pc2', passwordVariable: 'ANSIBLE_PASSWORD', usernameVariable: 'ANSIBLE_USER')]) {
          sh 'echo "pc2 ansible_host=192.168.1.107 ansible_user=${ANSIBLE_USER} ansible_password=${ANSIBLE_PASSWORD} ansible_port=22 become_user=${ANSIBLE_USER} forever=/home/home/.nvm/versions/node/v14.21.2/bin/forever" >> ./host.ini'
        }
        withCredentials([usernamePassword(credentialsId: 'ansible_ssh_pc3', passwordVariable: 'ANSIBLE_PASSWORD', usernameVariable: 'ANSIBLE_USER')]) {
          sh 'echo "pc3 ansible_host=192.168.1.112 ansible_user=${ANSIBLE_USER} ansible_password=${ANSIBLE_PASSWORD} ansible_port=22 become_user=${ANSIBLE_USER} forever=/home/cpu343/.nvm/versions/node/v14.20.1/bin/forever" >> ./host.ini'
        }
        sh '''
            ansible --version
            ansible-playbook --version
            ansible-playbook playbook_deploy.yml -i host.ini
        '''
      }
    }

    stage("Deploy"){
      // // stage("Deploy") {
      // //     steps {
      // //         echo 'Deploying...'
      // //         sshPublisher(publishers:
      // //         [sshPublisherDesc(
      // //             configName: 'ansible_pc2',
      // //             transfers: [
      // //                 sshTransfer(
      // //                     sourceFiles: 'playbook_deploy.yml, host.ini',
      // //                     remoteDirectory: '/playbooks',
      // //                     cleanRemote: false,
      // //                     execCommand: 'cd playbooks/ && ansible-playbook playbook_deploy.yml -i host.ini',
      // //                     execTimeout: 120000,
      // //                 )
      // //             ],
      // //             usePromotionTimestamp: false,
      // //             useWorkspaceInPromotion: false,
      // //             verbose: false)
      // //         ])
      // //     }
      // // }
      // // stage('Deploy') {
      // //   script{

      // //     cleanWs()
      // //     sh "echo 'hello' >> file.txt"

      // //     echo 'Local files.....'
      // //     sh 'ls -l'

      // //     command='''
      // //         cat ./file.txt
      // //         ls -l
      // //         date
      // //         cat /etc/os-release
      // //     '''


      // //     // Copy file to remote server
      // //     sshPublisher(publishers: [sshPublisherDesc(configName: 'ansible_pc2',
      // //       transfers: [ sshTransfer(flatten: false,
      // //                     remoteDirectory: './',
      // //                     sourceFiles: 'file.txt'
      // //       )])
      // //     ])

      // //     // Execute commands
      // //     sshPublisher(publishers: [sshPublisherDesc(configName: 'ansible_pc2',
      // //       transfers: [ sshTransfer(execCommand: command    )])])

      // //   }
      // // }
      echo "SUCCESS ..."
    }
  }
}
