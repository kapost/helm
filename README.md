# Helm
This action creates a docker container with AWS CLI and Helm v3 available for AWS EKS deployments. The entrypoint.sh script assumes that the action is used in a repo where the helm chart structure is located in an `apps/<application>/` directory structure and that values files are named with an environment leading the `-values.yaml`. A value in the `<env>-values.yaml` file will need to use a placeholder for the deployment image with a value of `RELEASE_IMAGE`

For example
```bash
repo
| 
├── apps
│   ├── application1
│   │   ├── prod-values.yaml
|   |   ├── pre-prod-values.yaml
|   |   ├── dev-values.yaml 
|   |   ├── templates
|   |   |   ├── hpa.yaml
|   |   |   ├── deployment.yaml
|   |   |   ├── service.yaml
│   ├── application2
│   │   ├── prod-values.yaml
|   |   ├── pre-prod-values.yaml
|   |   ├── dev-values.yaml 
|   |   ├── templates
|   |   |   ├── hpa.yaml
|   |   |   ├── deployment.yaml
|   |   |   ├── service.yaml
│   ├── application3
│   │   ├── prod-values.yaml
|   |   ├── pre-prod-values.yaml
|   |   ├── dev-values.yaml 
|   |   ├── templates
|   |   |   ├── hpa.yaml
|   |   |   ├── deployment.yaml
|   |   |   ├── service.yaml
├── README.md
└── .gitignore
```

# Usage
see [example.yml](.github/workflows/example.yml)

```yaml
on: push
name: Deploy
jobs:
    deploy:
        name: Deploy with Helm
        runs-on: ubuntu-latest
        steps:
            - name: Cancel Previous Runs
              uses: styfle/cancel-workflow-action@0.4.1
              with:
                access_token: ${{ github.token }}
            
            - name: Checkout
              actions/checkout@v2
            
            - name: Configure AWS Credentials
              uses: aws-actions/configure-aws-credentials@v1
              with:
                aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
                aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
                aws-region: us-east-1
            
            - name: Login to AWS ECR
              id: login-ecr
              uses: aws-actions/amazon-ecr-login@v1
            
            - name: Deploy to EKS Cluster
              uses: kapost/helm
              env:
                ECR_REPOSITORY: kap-app
                ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
                RELEASE_IMAGE: ${{ github.sha }}
                ENVIRONMENT: ${{ secrets.ENVIRONMENT }}
                APPLICATION: ${{ secrets.APPLICATION }}
                KUBE_CONFIG: ${{ secrets.KUBE_CONFIG_DATA }} # <-- Required
```

# Secrets
`KUBE_CONFIG` - **IS required**: This is a base64 encoded kubeconfig file with credentials for Kubernetes cluster access. You need a kubeconfig file with the following format:

```txt
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data:
    LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCmFiY2RlZmdoaWprbG1ub3BxcnN0dXZ3eXh6YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJ==
    server: https://ABCD1234EFGH5678IJKL9012MNOP3456.gr7.us-east-2.eks.amazonaws.com
  name: arn:aws:eks:us-east-2:111222333444:cluster/super-awesome-kap-cluster
contexts:
- context:
    cluster: arn:aws:eks:us-east-2:111222333444:cluster/super-awesome-kap-cluster
    user: arn:aws:eks:us-east-2:111222333444:cluster/super-awesome-kap-cluster
  name: arn:aws:eks:us-east-2:111222333444:cluster/super-awesome-kap-cluster
current-context: arn:aws:eks:us-east-2:111222333444:cluster/super-awesome-kap-cluster
kind: Config
preferences: {}
users:
- name: arn:aws:eks:us-east-2:111222333444:cluster/super-awesome-kap-cluster
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - --region
      - us-east-2
      - eks
      - get-token
      - --cluster-name
      - super-awesome-kap-cluster
      command: aws
```
Run the following command to populate the secret: 
```bash
cat kubeconfig | base64
```

Make sure that the kubeconfig does not have `AWS_PROFILE`, i.e. remove the section before base64 encoding:
```yaml
env:
  - name: AWS_PROFILE
      value: kap
```
