# **Data Stewardship Wizard Engine Frontend**

- [**Data Stewardship Wizard Engine Frontend**](#data-stewardship-wizard-engine-frontend)
  - [**Introduction and context**](#introduction-and-context)
  - [**Development**](#development)
    - [**Setup**](#setup)
    - [**Workflow**](#workflow)
  - [**Deployment**](#deployment)
  - [**Workflow**](#workflow-1)
    - [**Development**](#development-1)
    - [**Implementation**](#implementation)
  - [**Debugging**](#debugging)
  - [**Deprecated**](#deprecated)

This repository is a fork of the [Data Stewardship Wizard Engine Frontend](https://github.com/ds-wizard/engine-frontend). It is used for evaluating, and making changes relating to the Government of Canada common look and feel.

## **Introduction and context**

The [current instance of DS Wizard run by Shared Services Canada](http://federaldatasteward.scienceprogram.cloud:8080/dashboard) is based on the [dsw-deployment-example](https://github.com/ds-wizard/dsw-deployment-example) repository by DS-Wizard: it's structure is composed of a `docker-compose.yml` file listing the 6 containers required to run the service as well as database backups. The 6 containers that are run are `dsw-server`, `dsw-client`, `docworker`, `mailer`, `postgres` and `minio`.

In order to apply the Government of Canada common look and feel, we must modify either the image used for the `dsw-client` container (i.e. creating a new custom image), or we can also modify the original container itself.

The `dsw-client` image is created by testing and building the node.js application. Building the application creates a `dist` folder, which contains a compiled distributable of the application. Building the image using the Dockerfile for the engine-wizard makes a copy of the engine-wizard located in the `dist` folder, into the container. This compilation/building step has implications that will later be talked about.

## **Development**
### **Setup**
The development of this application will be done by having a local instance of the base DS-Wizard app, then applying the changes to this instance. Deployment/testing is done by sending those changes onto our dev-box/production environments.

In order to develop, you should:
1. [Have Docker Desktop installed on your development machine](https://www.docker.com/products/docker-desktop/)
2. Have access to a linux distro console. On Windows 10/11, you can obtain a Ubuntu subsystem by running the following in your terminal:
    ```
    $ wsl.exe --install -d Ubuntu
    ```
    After doing so, you may need to restart your computer. Afterwards, you will need to go in Docker Desktop, then into settings -> Resources -> WSL Integration and enable Docker Desktop for your Ubuntu subsystem, which will be available to you by searching "Ubuntu" in the search bar. 

    The first time you open your Ubuntu subsystem you will prompted to create a UNIX user. Make sure you remember your user and password.

    Most macOS computers should be able to run everything from the terminal app.
3. Have both the following repos cloned anywhere in your computer:
   ```
   $ git clone https://github.com/ssc-sp/DS-Wizard-Client.git
   $ git clone https://github.com/ds-wizard/dsw-deployment-example.git
   ```

Once you have met these requirements, access your terminal, and run:
```
$ sudo su
```
Which will give you root access after entering your password. Afterwards, you will need to set everything up in your `$HOME` folder. This includes installing nodejs, npm and elm:
```
$ cd $HOME
$ apt update
$ apt install nodejs npm
$ curl -L -o elm.gz https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz
$ gunzip elm.gz
$ chmod +x elm
$ sudo mv elm /usr/local/bin/
```
Test that everything has been done correctly by running the following:
```
$ node -v
$ npm --help
$ elm --help
```
Subsystem have access to the hosts' file system through the `/mnt` folder, and so to avoid duplicating the github repos, let us create two symlinks that link to where we originally cloned both repositories:
```
$ ln -s /mnt/absolute/path/to/repo/dsw-deployment-example $HOME/dsw-deployment-example
$ ln -s /mnt/absolute/path/to/repo/DS-Wizard-Client $HOME/DS-Wizard-Client
```
Now let us modify the `docker-compose.yml` file located in `dsw-deployment-example` in order to run our custom image instead of the base image:
```
$ vi dsw-deployment-example/docker-compose.yml
```
And edit the `dsw-client` section as such:
```
  dsw-client:
    # image: datastewardshipwizard/wizard-client
    image: dsw-client-ssc
    restart: always
    ports:
      - 127.0.0.1:8080:80
    environment:
      API_URL: http://localhost:3000
    volumes:
      - assets/
```
In order to edit, press "i" on your keyboard, do your edits, then press "ESC" followed by ":wq!", which will write your edits and quit the editor. You can also make this edit any other way. From there, you should be able to fully run your local instance:
```
$ cd DS-Wizard-Client
$ bash scripts/buildimage.sh
```
`buildimage.sh` cleans the environment, tests the application, compiles it, creates the docker image from it and restarts your local instance of `dsw-deployment-example`. You can check that your instance is running by accessing [localhost:8080](localhost:8080).

### **Workflow**
The two repos that you cloned earlier in the setup section are where you will do your work. The `dsw-deployment-example` repo contains the architecture of the whole application. With docker, this architecture is a simple list of images and how they interact with each other. The whole architecture is comprised within `docker-compose.yml`. There are many images that make DS-Wizard, but our goal is to work on only one of them, the front-end. The `DS-Wizard-Client` repo is used to create the front-end image, "dsw-client-ssc".

The front-end is a NodeJs application: it uses elm to create the entirety of the front end, then compiles it into a javascript distributable, which is then packaged into a container. Elm is a programming language meant to combine HTML and Javascript together. All elm files for the client are located in `DS-Wizard-Client/engine-wizard/elm/` but the only one of interest is the following:
```
DS-Wizard-Client/engine-wizard/elm/Wizard/Common/View/Layout.elm
```
The object of interest is the `app` object, which contains the appview.

In addition, SCSS styling is applied afterward on the app. You can find all the css files

## **Deployment**

Before we begin, make sure you have `nodejs`, `npm` and Docker installed and updated.

This repo uses v3.14 of the frontend, which at the time of writing this, is the latest release. When working on the frontend, make sure you use the version that corresponds to the version of the other containers (`dsw-server`, etc).

Begin by cloning the repo. For v3.14:
```
$ git clone https://github.com/ssc-sp/DS-Wizard-Client.git .
```

For other versions:
```
$ git clone -b <tag name> https://github.com/ds-wizard/DS-Wizard-Client.git .
```

Afterwards, install the required dependencies:
```
$ cd DS-Wizard-Client
$ npm install
```

## **Workflow**
### **Development**

After cloning the DS-Wizard-Client repo and doing the setup, you can make the appropriate changes to the frontend. In order to test out if your changes have broken the application, run the following:
```
$ npm run test
```
If you passed all the tests, you can commit and push your changes (if using this fork):
```
$ git commit -m "Commit message"
$ git pull
$ git push
```

### **Implementation**

1. **Quick implementation (for devbox only)**

    Clone this repo, run the setup and afterwards run the following:
    ```
    cd DS-Wizard-Client
    bash scripts/buildimage.sh
    ```
    This will run the tests, build the application and build the docker image. Afterwards, simply make sure that your deployment uses this custom image, inside `docker-compose.yml`:
    ```
    dsw-client:
        #image:datastewardshipwizard/wizard-client:3.14
        image:dsw-client-ssc
    ```

2. **Other implementation**

    On the environment where you want to implement those changes (either devbox or production), clone/pull this repo and repeat setup (if needed). 

    Afterwards
    ```
    $ npm run test #Optional
    $ npm run build
    $ docker -t dsw-client-ssc -f engine-wizard/docker/Dockerfile .
    ```
    This will create our required custom image. Next, navigate to the running instance of dsw-deployment-example and modify the dsw-deployment-example to use our new image:
    ```
    dsw-client:
        #image:datastewardshipwizard/wizard-client:3.14
        image:dsw-client-ssc
    ```
    Now you may use the following to test your changes:
    ```
    $ docker-compose down
    $ docker-compose up -d
    ```
    Your changes should appear.

## **Debugging**

While working on this, we ran into the following issue when trying to load the client with a different image:
```
Problem with the value at json.config.dashboard:

    {
        "welcomeWarning": null,
        "welcomeInfo": null,
        "widgets": {
            "admin": [
                "DMPWorkflow",
                "LevelsQuestionnaire"
            ],
            "dataSteward": [
                "DMPWorkflow",
                "LevelsQuestionnaire"
            ],
            "researcher": [
                "DMPWorkflow",
                "LevelsQuestionnaire"
            ]
        }
    }

Expecting an OBJECT with a field named `dashboardType`
```
In order to figure out the cause of the issue, we looked through the entire (this fork as well as the original repo) for `dashboardType`, but could not find anything.

In addition we tried running `diff` and [prettydiff](https://prettydiff.com/) on the `.js` files, comparing the JS script created by the engine-frontend repo and the JS script running inside the `dsw-client` container of `dsw-deployment-example`. Both `diff` and prettydiff crashed.

We then contacted the DS-Wizard team on Slack and they indicated that there was an issue with the version of the backend. Modifying the version of the backend fixed this error.

## **Deprecated**

This section lists previous methods that were considered for workflow but were rejected.

1. **Overriding specific files**

    This method uses volumes to override specific files inside of the dsw-client container. This method works well for assets (favicon, etc).

    Similarly to before, build this application:
    ```
    $ npm run test #Optional
    $ npm run build
    ```
    This will create a `dist` folder which is a compiled distributable. Afterward, you can navigate to the running `dsw-deployment-example` instance and modify the volumes of the `dsw-client` service in the `docker-compose.yml` in order to override the specific files inside the container:
    ```
    volumes:
        - /absolute_path_to_engine-frontend_repo/dist/engine-wizard/file_to_override:/usr/share/nginx/html/file_to_override
    ```
    This takes the file from the compiled build of the engine-frontend and copies it into the compiled build of engine-frontend that is inside the `dsw-client` container. You can test your changes as such:
    ```
    $ docker-compose down
    $ docker-compose up -d
    ```
    And then navigate to the client webpage.

    This method works well for assets, but it does not really work well for code.

2. **Overriding the entire compiled folder**

    Similarly to the previous method, this method takes the approach of overriding the whole compiled folder using a volume. This method is great for development as it is more general (encompasses multiple changes at once) and faster than creating a custom image.

    Similarly to before, build the application:
    ```
    $ npm run test #Optional
    $ npm run build
    ```
    Afterward, you can navigate to the running `dsw-deployment-example` instance and modify the volumes of the `dsw-client` service in the `docker-compose.yml` in order to override the whole compiled folder inside the container:
    ```
    volumes:
        - /absolute_path_to_engine-frontend_repo/dist/engine-wizard:/usr/share/nginx/html
    ```
    This overrides the entire application folder inside the container with the folder you built containing your changes. You can test your changes by running:
    ```
    $ docker-compose down
    $ docker-compose up -d
    ```
    And then navigate to the client webpage.