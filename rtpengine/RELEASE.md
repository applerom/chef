# Releasing This Cookbook

Need to make some changes official? Time to release the next revision.

## Before you begin

I'm assuming you know the current cookbook `name` & `version`. This example uses the cookbook:
- name: `rtpengine`
- version: `0.1`

Finish changes to the cookbook:
- merge PRs
- update readme, api, reference docs
- update links to related sites
- make sure all tests are passing

Ensure your dev environment is set up with:

- [git](http://www.git-scm.com/)
- [ChefDK](https://downloads.chef.io/chef-dk/)
- [knife-supermarket](https://github.com/chef/knife-supermarket)

## How to do it

- Based on the changes since the last release, pick the next version number using [Semver](http://semver.org/).
- Update version in `metadata.rb` in new commit:


 %w(debian ubuntu arch redhat centos fedora scientific oracle amazon).each do |os|
   supports os
```

```sh
git commit -m "bump version to 0.1"
```

- Tag in git with name like `v0.1`:

```sh
git tag "v0.1"
```

- Push to GitHub:

```sh
git push --tags origin master
```

- Share onto Supermarket:

```sh
knife cookbook site share "rtpengine"
```

## What might go wrong?

- You might not have merge, commit access to `master` branch at Github
- You might not have collaborator access to the cookbook at Supermarket
