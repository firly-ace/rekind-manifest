# Kubernetes Cluster Service Restoration
## Google Cloud CLI and Kubectl
# Installing Google Cloud CLI, Kubectl, and Kubectl Auth Plugin

## Prerequisites
- Windows or Mac operating system

## Google Cloud CLI
1. Open a web browser and go to the [Google Cloud SDK Downloads](https://cloud.google.com/sdk/docs/install) page.
2. Download the installer for your operating system (Windows or Mac).
3. Run the installer and follow the on-screen instructions to complete the installation.
4. Open a new terminal or command prompt window and run the following command to verify the installation:
  ```
  gcloud version
  ```

## Kubectl
1. Open a web browser and go to the [Kubernetes Documentation](https://kubernetes.io/docs/tasks/tools/) page.
2. Follow the instructions to install Kubectl for your operating system (Windows or Mac).
3. Open a new terminal or command prompt window and run the following command to verify the installation:
  ```
  kubectl version --client
  ```

## Kubectl Auth Plugin
gcloud components install gke-gcloud-auth-plugin

## Conclusion
You have successfully installed Google Cloud CLI, Kubectl, and the Kubectl Auth Plugin on your Windows or Mac machine. You are now ready to interact with Google Cloud and manage your Kubernetes clusters.


## Cloud SQL
### Service Database Setup
1. Go to CloudSQL page in your GCP Projects
2. Click on Create Instances
3. Choose PostgreSQL
4. Insert details, instance name, password, types, and version (<14)
5. Choose Region and zonal availability to your preferences
6. Review all config before proceeding
7. Click on Create Instances

### Config Adjustment
Under manifest/config.yaml and manifest/secret.yaml, there's a env data that will need to be adjusted according to this newly created database config. Specifically for private type env, it will be stored under secret.yaml, otherwise it will stored under config.yaml. In this case, we need to change DB_PASSWORD and DB_USER under secret.yaml, and DB_HOST, DB_INSTANCE and DB_NAME under config.yaml

## Google Cloud Storage
### Creating Buckets


### Config Adjustment
After creating the buckets, we need the name of the buckets to be stored inside the manifest/config.yaml, look for env with GCS_* prefix and set the buckets url into that value. 

  ```GCS_BQ_EXPORT_URL: https://storage.googleapis.com/new-icons-jtb-static-file-prod/bq-service/```

## Installation / Application Step
``` kubectl apply -f manifest/config.yaml```

``` kubectl apply -f manifest/hpa.yaml```

``` kubectl apply -f manifest/deployment.yaml```

``` kubectl apply -f manifest/service.yaml```
