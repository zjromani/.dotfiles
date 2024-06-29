#!/usr/bin/env python3

import subprocess
import requests
import os

ARGOCD_SERVER = 'https://your-argocd-server.com'
ARGOCD_TOKEN = 'your-token'

def get_current_directory_name():
    return os.path.basename(os.getcwd())

def get_git_log():
    repo_name = get_current_directory_name()
    git_log_command = f'''git log --oneline --decorate --graph --since="7 days ago" --date=relative --pretty=format:"%C(yellow)%h %C(cyan)(%ar) %C(green)%an %C(auto)%d %C(reset)%s %C(magenta)\e]8;;[https://github.com/HotelEngine/{repo_name}/commit/%H\\e\\\\Link\\e](https://github.com/HotelEngine/{repo_name}/commit/%25H%5C%5Ce%5C%5C%5C%5CLink%5C%5Ce)]8;;\e\\%C(reset)%n%b"'''
    result = subprocess.run(git_log_command, shell=True, capture_output=True, text=True)
    return result.stdout

def get_deployment_info():
    headers = {
        'Authorization': f'Bearer {ARGOCD_TOKEN}',
    }
    response = requests.get(f'{ARGOCD_SERVER}/api/v1/applications', headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Failed to retrieve deployment info: {response.status_code}")
        return None

def merge_info(git_log, deployment_info):
    deployments = []
    for app in deployment_info['items']:
        app_name = app['metadata']['name']
        deployed_at = app['status']['operationState']['finishedAt']
        source = app['spec']['source']['repoURL']
        revision = app['spec']['source']['targetRevision']
        deployments.append(f"{app_name} deployed at {deployed_at} from {source} at revision {revision}")
    
    return f"{git_log}\n\nArgoCD Deployments:\n" + "\n".join(deployments)

def generate_release_notes():
    git_log = get_git_log()
    deployment_info = get_deployment_info()
    if deployment_info:
        return merge_info(git_log, deployment_info)
    else:
        return "Failed to retrieve deployment information."

def main():
    release_notes = generate_release_notes()
    print(release_notes)

if __name__ == "__main__":
    main()
