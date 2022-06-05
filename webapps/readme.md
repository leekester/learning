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
* To push to an Azure Container Registry, first create an alias for your image that contains the fully qualified path to your ACR. In the above case for example, create an alias using:
```shell
D:\learning\webapps>docker tag containerapp:v1 acrdemo87533.azurecr.io/apps/containerapp:v1
```
* Login to your ACR, replacing the name of your registry in the following command:
```console
D:\learning\webapps>az acr login -n acrdemo87533.azurecr.io
```
* Push the image using:
```console
D:\learning\webapps>docker push acrdemo87533.azurecr.io/apps/containerapp:v1
