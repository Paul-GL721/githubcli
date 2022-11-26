# githubcli
Repository to create a githubcli docker image.

This image can be used in any application that runs a docker container. 

## Example with [jenkins server](https://www.jenkins.io/)
In this example the paulgl721/githucli docker container is used as a build agent in the jenkins post stage.

On successful run of the development stages, a pull request is made to the production branch in github.

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

