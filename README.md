# GitHub organization self-hosted runners in Azure Container Apps

This repository is a starter for hosting an organization's GitHub Actions runners in Azure Container Apps.  
It contains Bicep code to provision the resources, a simple Dockerfile and GitHub Actions workflow to automate everything and test the self-hosted runners.  
It was side-created with a series of blog posts in two parts: the [first one](https://blog.xmi.fr/posts/github-runner-container-app-part1) sets a single runner and the [second one](https://blog.xmi.fr/posts/github-runner-container-app-part2) adds auto-scaling.

## Getting started
The best way to use this is to fork this repository, and set-up your fork to connect with GitHub and your Azure subscription.  
You will need:
- A GitHub organization: this repo is not for runners associated to a personal account, so you need an organization. You can [create](https://github.com/account/organizations/new) on for free if you need.
- An Azure subscription

### Fork this repo
Let's start by [forking](https://github.com/xmi-cs/aca-gh-actions-runner/fork) this repo. In the _Owner_ dropdown, make sure to select your organization and not your personal account. You can leave the other settings as they are, and click on the _Create fork_ button.

### Create a GitHub App
Self-hosted runners interact with the GitHub REST API to register themselves and query queued jobs. The workflows in this repo also interact with the REST API to set variables.   
The recommended authentication method against the GitHub REST API in the context of an organization is to use a GitHub App, let's create one for the runners and the workflows.  

From your organization settings, click on _Developer Settings_, then _GitHub Apps_ and _New GitHub App_. Give it a name and a homepage URL (any URL will work), and disable the _Webhook_ feature.  
The important settings are the permissions, set them as follow:
- In _Repository permissions_:
  - Set `Actions` to `Read-only`
  - Set `Metadata` to `Read-only` (it should be selected by default)
  - Set `Variables` to `Read and write`.
- In _Organization permissions_:
  - Set `Administration` to `Read-only`
  - Set `Self-hosted runners` to `Read and write`

Keep the other settings as default and click on _Create GitHub App_. On the next page you are prompted to generate a private key: do this and your browser will download a `.pem` file. Note also the id of your app as you will need it in a few seconds.  

Then you need to _install_ your GitHub App to grant the permissions defined above in your organization. You can choose to give it the access to all your repos or just some of them. At least include your fork otherwise it won't work.

Lastly, in the settings of your fork, go to _Secrets and variables_, and _Actions_. Create a secret named `GH_APP_PRIVATE_KEY` with your GitHub App private key (the content of the `.pem` file) and a variable named `GH_APP_ID` with the GitHub App id as the value.

### Connect GitHub with Azure
To grant access to your Azure subscription to the GitHub Action runners, you need to create a service principal with the _owner_ role to your subscription (or _contributor_ and _user access administrator_ roles).  

> This use of privileged role(s) is necessary to create a role assignment in the Bicep code. If you have an Entra P1 or P2 license your can also create a custom role for finer-grained control  

To create your service principal, follow the instructions [here](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-cli%2Clinux#use-the-azure-login-action-with-openid-connect), until you have added federated credentials and create the following variables:
- `AZURE_TENANT_ID` with your tenant id
- `AZURE_CLIENT_ID` with your application (client) id
- `AZURE_SUBSCRIPTION_ID` with your subscription id
- `AZURE_LOCATION` with the Azure region you want to create the resources in (not related to the GitHub-Azure connection but better set it while already setting variables)

> Note that no client secret is required thanks to OpenID Connect and federated credentials

Now that everything is set-up, you can start to deploy some resources.

## Deploy the prerequisites
The first workflow to run is `Deploy prerequisites` from the Actions tab in your fork. It will create the following resources in your Azure subscription:
- A resource group named `rg-aca-gh-runners`
- A Container Apps environment
- A Container registry
- A Log Analytics workspace

It will also build a container image from the Dockerfile [here](/src/Dockerfile.from-base) which is based on the work from this great [repo](https://github.com/myoung34/docker-github-actions-runner) and push it to your registry with the tag `runners/github/linux:from-base`.  

Lastly it sets a few deployment outputs as variables so that the next workflow can re-use them.

## Deploy the runners
Next workflow to run is `Create and register self-hosted runners`. This one generates an access token as the GitHub App, and pass it as an input to a Bicep deployment. This deployment provisions the Container App inside the Container Apps Environment, using the container image built and pushed by the previous workflow.

> [!NOTE]
> The previous workflow also generates an access token but it's less noticeable, it's a short-lived token for setting the variables

When you launch the workflow, you can choose between deploying a Container App or a Container App Job. The job is used by default as it's a better fit for this scenario.

Once the workflow has finished you should see the Container App Job (or the App) in your resource group. Checking the result depends on type of deployed app.

<details>
<summary>Using Container Apps</summary>
In the _Revisions_ panel of the Container App, you should see an active revision and in the _Log Stream_ panel, a message indicating the successful connection to GitHub:

```
Runner reusage is disabled
Obtaining the token of the runner
Ephemeral option is enabled
Configuring
--------------------------------------------------------------------------------
|        ____ _ _   _   _       _          _        _   _                      |
|       / ___(_) |_| | | |_   _| |__      / \   ___| |_(_) ___  _ __  ___      |
|      | |  _| | __| |_| | | | | '_ \    / _ \ / __| __| |/ _ \| '_ \/ __|     |
|      | |_| | | |_|  _  | |_| | |_) |  / ___ \ (__| |_| | (_) | | | \__ \     |
|       \____|_|\__|_| |_|\__,_|_.__/  /_/   \_\___|\__|_|\___/|_| |_|___/     |
|                                                                              |
|                       Self-hosted runner registration                        |
|                                                                              |
--------------------------------------------------------------------------------
# Authentication
√ Connected to GitHub
# Runner Registration
√ Runner successfully added
√ Runner connection is good
# Runner settings
√ Settings Saved.
√ Connected to GitHub
Current runner version: '2.311.0'
2023-11-22 15:48:14Z: Listening for Jobs
```

You should also see the runner in the settings of your fork (in Settings > Actions > Runners):
![Idle runner in repo settings](/docs/img/github-idle-runner.png)  
You can also see it in the settings of your organization.
</details>

## Test the self-hosted runners
To test the runner, simply run the `Test self-hosted runners` workflow. This is a simple workflow that connects to Azure and run Azure CLI commands to output the account used and the list of resource groups in the subscription.

> The most important thing on this workflow is the use of the `runs-on: self-hosted` property of the single job. It means that the job has to run on a self-hosted runner, whereas the previous workflow run on runners managed by GitHub (using the `runs-on: ubuntu-latest` property).

Once the workflow manually triggered, you can check that the job is picked up by the self-hosted runner (either from the GitHub Actions UI or from the Container Apps log stream in the portal).
