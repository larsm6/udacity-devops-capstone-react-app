pipeline {
	agent any
	stages {
		
		stage('Cleanup of previous runs') {
			steps {
				sh '''
				docker system prune -a -f
				'''
			}
		}

		stage('Linting React App')  {
			steps {
				sh '''
					cd Application
					yarn --pure-lockfile
					yarn eslint src/App.js
					# cleanup
					rm -r node_modules
				'''
			}
		}

		
		stage('Build & Push Docker Image') {
			steps {
				withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub_credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
					sh '''
						docker build -t larsm6/udacity-capstone-react-app .
						docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
						docker push larsm6/udacity-capstone-react-app
					'''
				}
			}
		}

		stage('Configure Kubernetes Cluster') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-kubectl') {
					sh '''
						kubectl config use-context arn:aws:eks:us-west-2:311837926413:cluster/udacity-devops-capstone
						kubectl apply -f ./Deployment/blue-controller.json
						kubectl apply -f ./Deployment/green-controller.json
						kubectl apply -f ./Deployment/blue-service.json
					'''
				}
			}
		}
		
		stage('User Approval') {
			steps {
				input "Switch traffic to green?"
			}
		}
		
		stage('Create the service in the cluster, redirect to green') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-kubectl') {
					sh '''
						kubectl apply -f ./Deployment/green-service.json
					'''
				}
			}
		}
	}
}
