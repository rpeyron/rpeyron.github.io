---
post_id: 4361
title: 'Static files publication on GitLab Pages'
date: '2020-05-21T20:52:01+02:00'
last_modified_at: '2020-05-21T21:05:32+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4361'
slug: static-files-publication-on-gitlab-pages
permalink: /2020/05/static-files-publication-on-gitlab-pages/
image: /files/2020/05/GitLab_Logo.svg.png
categories:
    - Informatique
tags:
    - CI/CD
    - GitLab
    - GitHub
    - TravisCI
lang: en
---

To use GitLab Pages, unlike GitHub Pages, there is a little work to have it up and running.

GitLab Pages will serve files under the specific folder “`public`“. But having this folder in your repository will not be enough to activate GiLlab Pages. It requires basically to use CI/CD to deploy your content to GitLab Pages servers. It is done with a specific job called “`pages` ” that will allow GitLab to activate GitLab Pages for your repository. You will see in GitLab documentation various examples to build, test and deploy your pages with various language and tools, but nothing for ready-to-deploy static files. It is kind of logical because of the intended way to use GitLab is to run a full CI/CD, not simply to host static files. But if for some reason you want that, you only have to create a CI/CD pipeline that will do nothing, but publish to GitLab Pages. Create at the root of your repository a file named “`.gitlab-ci.yml` ” with the contents:

```
image: node:latest

pages:
  stage: deploy
  script:
    - echo nothing to do
  artifacts:
    paths:
    - public

```

The first line tells to use the docker image “node:lastest” (but you can use the one you want because it does nothing…). The job “pages” contains the script section with the script to build your pages. As it is required to have at least one command, I use “echo nothing to do” to do… nothing… The artifacts path then tells where the artifacts are stored. You cannot specify another folder for GitLab Pages. If you specify another one, it won’t be taken into account and the content won’t be updated. The “`stage: deploy` ” tells the CI/CD this job corresponds to the deploy default stage. If you omit that, it will use the “test” stage, and the pipeline may complain about a missing deploy stage (but it also works).

When committing your changes, you will see a new job in the CI/CD / Jobs menu of your repository. It will instantiate on the mutualized pool of GitLab runners the docker image, echo “do nothing”, and deploy files to GitLab Pages. You will then be able to see the contents using `https://<username>.gitlab.io/<repository>` (or click in the URL given in the GitLab Pages settings page).

This script will be triggered each time you commit to this repository. If you commit other contents in your repository it is obviously useless to run it each time and waste resources. You can create a specific branch “pages” and restrict the script with adding “only: pages” in your “pages” job.

You may also want to create the contents as a regular CI/CD ; below a simple example with nodejs

```
image: node:latest

before_script:
    - npm install

stages:
    - test
    - deploy

cache:
    paths:
    - node_modules/

pages:
    stage: deploy
    script:
    - npm run release
    artifacts:
        paths:
        - public
    only:
    - master

testing_testing:
    stage: test
    script: npm test

```

It defines two jobs, first to test the application, and then, if success, to deploy it. It expects npm run release to create the files in the public folder, but if it not the case and you do not want to change it, you may just add a copy command `rm -Rf public/* ; cp -r docs/ public/` . The deployment will only take place for commits in the master branch.

So GitLab Pages need to use a little CI/CD, but it a good occasion to discover it. The GitLab CI/CD is simple to set up, and simple to use as it is fully integrated in GitLab and do not require switching environment as with GitHub / TravisCI.