# GitHub organization self-hosted runners in Azure Container Apps

This repository is a starter for hosting an organization's GitHub Actions runners in Azure Container Apps.  
It contains Bicep code to provision the resources, a simple Dockerfile and GitHub Actions workflow to automate everything and test the self-hosted runners.

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
  - Set `Self-hosted runners` to `Read and write`

Keep the other settings as default and click on _Create GitHub App_. On the next page you are prompted to generate a private key: do this and your browser will download a `.pem` file. Note also the id of your app as you will need it in a few seconds.  

Then you need to _install_ your GitHub App to grant the permissions defined above in your organization. You can choose to give it the access to all your repos or just some of them. At least include your fork otherwise it won't work.

Lastly, in the settings of your fork, go to _Secrets and variables_, and _Actions_. Create a secret named `GH_APP_PRIVATE_KEY` with your GitHub App private key (the content of the `.pem` file) and a variable named `GH_APP_ID` with the GitHub App id as the value.

### Connect GitHub with Azure

## Test the self-hosted runners