# Simple Web Apps
In this folder we have some simple static Nginx websites which can be used to illustrate build and deployment concepts.
To build the applications:
* Clone the repository
* If you don't already have it, install Docker
* Change to the webapps directory
* In order to build the puppies site for example, run <em>docker build ./puppies -t containerapp:v1 -f ./puppies/dockerfile</em>
* To push to an Azure Container Registry, create an alias for your image that contains the fully qualified path to your ACR. In the above case for example, create an alias using <em>docker tag containerapp:v1 acrdemo87533.azurecr.io/apps/containerapp:v1</em>
