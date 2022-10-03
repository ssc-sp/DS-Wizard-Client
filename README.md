# **Data Stewardship Wizard Engine Frontend**

- [**Data Stewardship Wizard Engine Frontend**](#data-stewardship-wizard-engine-frontend)
  - [**Introduction and context**](#introduction-and-context)
  - [**Development**](#development)
    - [**Setup**](#setup)
    - [**Workflow**](#workflow)
  - [**Deployment**](#deployment)
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
3. Have the following repo cloned anywhere on your computer:
   ```
   $ git clone https://github.com/ssc-sp/DS-Wizard-Client.git
   ```

Once you have met these requirements, access your Linux terminal, and run:
```
$ sudo su
```
Which will give you root access after entering your password. Afterwards, you will need to set everything up in your `$HOME` folder. This includes installing nodejs, npm and dos2unix:
```
$ cd $HOME
$ apt update
$ apt install npm dos2unix
$ curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
$ source ~/.bashrc
$ nvm install 18.7.0
```
Test that everything has been done correctly by running the following:
```
$ node -v
$ npm --help
```
Subsystem have access to the host's file system through the `/mnt` folder, and so, there is a unix path to the github repo you created earlier on your host machine (`/unix/path/to/repo`). Creating a symlink of the entire repository causes issue and so we circumvent this by doing the following:
```
$ cd $HOME
$ git clone https://github.com/ssc-sp/DS-Wizard-Client.git
$ cd DS-Wizard-Client
$ rm -r engine-wizard
$ rm -r dsw-deployment-example/assets
$ ln -s /unix/path/to/repo/DS-Wizard-Client/engine-wizard engine-wizard
$ ln -s /unix/path/to/repo/DS-Wizard-Client/dsw-deployment-example/assets dsw-deployment-example/assets
```
These commands create symlinks of the folders in which we will work. This way your local install on your subsystem has its own structure but uses certain files from the repository on your host machine. Afterwards we install the dependencies:
```
$ npm install
```
From there, you should be able to fully run your local instance:
```
$ bash scripts/buildimage.sh
```
`buildimage.sh` cleans the environment, tests the application, compiles it, creates the docker image from it and restarts your local instance of `dsw-deployment-example`. You can check that your instance is running by accessing [localhost:8080](localhost:8080).

### **Workflow**
 The `dsw-deployment-example` folder within the repo contains the architecture of the whole application. With docker, this architecture is a simple list of images and how they interact with each other. The whole architecture is comprised within `docker-compose.yml`. There are many images that make DS-Wizard, but our goal is to work on only one of them, the front-end. The `DS-Wizard-Client` repo is used to create the front-end image, "dsw-client-ssc".

The front-end is a NodeJs application: it uses elm to create the entirety of the front end, then compiles it into a javascript distributable, which is then packaged into a container. Elm is a programming language meant to combine HTML and Javascript together. All elm files for the client are located in `DS-Wizard-Client/engine-wizard/elm/` but the only one of interest is the following:
```
DS-Wizard-Client/engine-wizard/elm/Wizard/Common/View/Layout.elm
```
The object of interest is the `app` object, which contains the appview.

In addition, SCSS styling is applied afterward on the app. You can find all the css files in the assets folder:
```
DS-Wizard-Client/dsw-deployment-example/assets/extra.scss
DS-Wizard-Client/dsw-deployment-example/assets/overrides.scss
DS-Wizard-Client/dsw-deployment-example/assets/variables.scss
```
You can read more about the role of each of these files [here](https://docs.ds-wizard.org/en/latest/admin/configuration.html#Client).

Your work should be fully within these 4 files (or more if you have to extend to other .elm files). If you modify the elm file, you will need to rebuild the docker image:
```
$ bash scripts/buildimage.sh
```
If you only edited the scss files, you can simply restart the application:
```
$ cd dsw-deployment-example
$ docker-compose down
$ docker-compose up -d
```
You should be able to see your new changes on [localhost:8080](localhost:8080).

You may also accelerate the `buildimage.sh` script by commenting out the `npm run test` line.

Make sure to often commit and push your changes:
```
$ git add *
$ git commit -m "Commit message"
$ git push
```

## **Deployment**

In your deployment environment (either the devbox or the production environment), you can deploy your changes by first pulling changes (if this repo is already present):
```
$ cd $HOME/DS-Wizard-Client
$ git pull
```
Or by cloning the repository:
```
$ cd $HOME
$ git clone https://github.com/ssc-sp/DS-Wizard-Client.git
```
Afterwards, you will need to go through `dsw-deployment-example/docker-compose.yml` as well as `dsw-deployment-example/dsw.yml` in order to replace all port lines with the lines that indicate "Use this line for deployment". The port lines currently indicated to be for deployment use the devbox ports: if you are deploying to production you will need to modify these. Afterwards, if it is the first time running this application on this deployment environment, you will need to go through the Setup section above. Once that is done, running the following should have the app up and ready:
```
$ cd $HOME/DS-Wizard-Client
$ bash scripts/buildimage.sh
```
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