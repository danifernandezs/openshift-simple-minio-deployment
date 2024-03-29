# openshift-simple-minio-deployment
Repo to store the minimal required yaml files to deploy minio at an OCP cluster

# TL;DR;

````bash
bash bootstrap.sh
````

The admin user and password it's configured directly as environment variables at the deployment resource.<br>
username: admin<br>
password: RedHat1!

# Deployed resources

- MinIO namespace
- PVC
- Service
- WebUI route
- API route
- MinIO k8s deployment

# License

<img src="./img/by-sa.png">

This work is under [Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/).

Please read the LICENSE file for more details.
