# githubcli
A github cli docker image based on Ubuntu. If you want to bring Github to the command line, you can use this image. [View the project on github](https://github.com/Paul-GL721/githubcli).

### Usage
Pull the from dockerhub.
```
docker pull paulgl721/githubcli:<image_version>
```
Remember to replace the image version as shown in the command below.
```
docker pull paulgl721/githubcli:2.1.0
```

### Build the image from source
To build the image from source run the docker command below. Change the tag name and do not forget to add the current context (**the dot at the end**).
```
docker build -t <tag_name>:<tag_version> <context>
```
An example of a docker build command is shown below
```
docker build -t paulgl721/githubcli:2.1.0 .
```

### Test the image
Interactively login into the container (**replace the image version**)
```
docker container run -it paulgl721/githubcli:<image_version>
// returns: root@<container_id> 
```
Run the github login authentication command, which should prompt you for your login details
```
gh auth login
//follow the steps; it should prompt you to login into github.com or enterprise 
```

## Example with [jenkins server](https://www.jenkins.io/)
In this example the **paulgl721/githucli** docker image is used as a build agent in the jenkins pull request stage.

On successful run of the development stages, a pull request is created to the production branch in github.
```
pipeline {
  agent none
  
  //define env variables
	environment {
    VERSION="0.1.${BUILD_NUMBER}"
		GH_TOKEN=credentials('replace-with-credential-ID')
	}
  stages {
    stage('checkout staging branch') {
      agent {
        label 'agentlabel'
      }
      steps {
        echo 'From github we are cloning the staging branch into our workspace'
        //.... define more steps here if necessary .....
      }
    }
    
    stage('Build') {
      agent {
        label 'agentlabel'
      }
      steps {
        echo 'Build a docker image of our application'
        //.... define more build steps here......
      }
    }
    
    stage('deploy'){
      agent {
        label 'agentlabel'
      }
      steps {
        echo 'Push the docker images to dockerhub'
        //.... add more steps
      }
    }
    
    stage('Create pull request'){
      agent {
        docker {
          image 'paulgl721/githubcli:2.1.0'
          label 'labelName' 
        }
      }
      steps {
        echo '....Creating pull request.....'
        //check version
        sh 'gh --version'
        //authenticate
        sh 'echo \$GH_TOKEN_PSW|gh auth login --hostname github.com --with-token'
        //check status
        sh 'gh auth status'
        //create pr to production branch from staging branch
        sh 'gh pr create --title "Staging branch v$VERSION was successful" --body "Staging branch version$VERSION was successfully tested and deployed needs to be merged into production" --base production --head staging'
      }
    }
  }
}
```

