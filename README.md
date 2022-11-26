# githubcli
A github cli docker image based on Ubuntu. If you want to bring Github to the command line, you can use this image.

### Usage
Pull the from dockerhub
```
docker pull paulgl721/githubcli:<image_version>
```
Replace image version Eg
```
docker pull paulgl721/githubcli:2.0
```

### Build the image from source
To build the image from source run the docker command below. Change the tag name and do not forget to add the current context (**the dot at the end**).
```
docker build -t <tag_name>:<tag_version> <context>
```
An example of a docker build command is shown below
```
docker build -t paulgl721/githubcli:1.0 .
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
In this example the **paulgl721/githucli** docker image is used as a build agent in the jenkins post stage.

On successful run of the development stages, a pull request is created to the production branch in github.
```
pipeline {
  agent {
    label "labelname"
    //..... change the label to your agent name .....
  }
  stages {
    stage('checkout staging branch') {
      steps {
        echo 'From github we are cloning the staging branch into our workspace'
        //.... define more steps here if necessary .....
      }
    }
    stage('Build') {
      steps {
        echo 'Build a docker image of our application'
        //.... define more build steps here......
      }
    }
    stage('deploy'){
      steps {
        echo 'Push the docker images to dockerhub'
        //.... add more steps
      }
    }
  }
  post { //create pull request on production branch
    success {
      node { 
        docker {
          image 'paulgl721/githubcli'
          label 'labelName' 
        }
      }
      script {
        //command to create pull request
        sh ' gh pr create --title "The bug is fixed" --body "Everything works again" --base master --head staging'      
      }
    }
  }
}
```

