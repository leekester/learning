# Simple Web Apps
In this folder we have some simple static Nginx websites which can be used to illustrate build and deployment concepts.
To build the applications:
* Clone the repository
* If you don't already have it, install Docker
* Install the Azure CLI if you don't already have it
* Change to the webapps directory
* In order to build the puppies site for example, run:
```shell
D:\learning\webapps>docker build ./puppies -t containerapp:v1 -f ./puppies/dockerfile
```
* Docker images can be listed using the following command:
```shell
D:\learning\webapps>docker images
REPOSITORY                                  TAG       IMAGE ID       CREATED          SIZE
containerapp                                v1        5b3f52c8154d   55 minutes ago   24.9MB
```
* To push to an Azure Container Registry, first create an alias for your image that contains the fully qualified path to your ACR. In the above case for example, create an alias using:
```shell
D:\learning\webapps>docker tag containerapp:v1 acrdemo87533.azurecr.io/apps/containerapp:v1
```
* You should now see an additional image in your list:
```shell
D:\learning\webapps>docker images
REPOSITORY                                  TAG       IMAGE ID       CREATED          SIZE
containerapp                                v1        5b3f52c8154d   55 minutes ago   24.9MB
acrdemo87533.azurecr.io/apps/containerapp   v1        5b3f52c8154d   55 minutes ago   24.9MB
```
* Login to your ACR, replacing the name of your registry in the following command:
```shell
D:\learning\webapps>az acr login -n acrdemo87533.azurecr.io
```
* Push the image using:
```shell
D:\learning\webapps>docker push acrdemo87533.azurecr.io/apps/containerapp:v1
```
* We can now check the repository to view the image which was pushed:
```shell
D:\learning\webapps>az acr repository list --name acrdemo87533 -o tsv
apps/containerapp
D:\learning\learning\webapps>az acr repository show --name acrdemo87533 --image apps/containerapp:v1
{
  "changeableAttributes": {
    "deleteEnabled": true,
    "listEnabled": true,
    "readEnabled": true,
    "writeEnabled": true
  },
  "createdTime": "2022-06-05T18:59:10.9782206Z",
  "digest": "sha256:375808c3d51313656540dff1edb5b10a82e61607044e66021c1f11c7f0f13c16",
  "lastUpdateTime": "2022-06-05T18:59:10.9782206Z",
  "name": "v1",
  "signed": false
}
```
