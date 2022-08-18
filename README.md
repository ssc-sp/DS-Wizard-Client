# **Data Stewardship Wizard Engine Frontend**

- [**Data Stewardship Wizard Engine Frontend**](#data-stewardship-wizard-engine-frontend)
  - [**Introduction and context**](#introduction-and-context)
  - [**Setup**](#setup)
  - [**Workflow**](#workflow)
    - [**Development**](#development)
    - [**Implementation**](#implementation)
  - [**Debugging**](#debugging)
  - [**Deprecated**](#deprecated)

This repository is a fork of the [Data Stewardship Wizard Engine Frontend](https://github.com/ds-wizard/engine-frontend). It is used for evaluating, and making changes relating to the Government of Canada common look and feel.

## **Introduction and context**

The [current instance of DS Wizard run by Shared Services Canada](http://federaldatasteward.scienceprogram.cloud:8080/dashboard) is based on the [dsw-deployment-example](https://github.com/ds-wizard/dsw-deployment-example) repository by DS-Wizard: it's structure is composed of a `docker-compose.yml` file listing the 6 containers required to run the service as well as database backups. The 6 containers that are run are `dsw-server`, `dsw-client`, `docworker`, `mailer`, `postgres` and `minio`.

In order to apply the Government of Canada common look and feel, we must modify either the image used for the `dsw-client` container (i.e. creating a new custom image), or we can also modify the original container itself.

The `dsw-client` image is created by testing and building the node.js application. Building the application creates a `dist` folder, which contains a compiled distributable of the application. Building the image using the Dockerfile for the engine-wizard makes a copy of the engine-wizard located in the `dist` folder, into the container. This compilation/building step has implications that will later be talked about.

## **Setup**

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