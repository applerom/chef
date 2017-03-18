# amazon-inspector

Install and manage Amazon Inspector agent.

## Usage

Add the recipe to the node or the role files where you want Amazon Inspector installed. If you want to remove amazon-inspector from a particular node, set inspector.enabled attribute to false in the node file and it will be removed.

    ```
    {
        "name": "amazon-inspector.test",
        "chef_environment": "testing",
        "run_list": [
            "recipe[amazon-inspector]"
        ],
        "normal": {
            "inspector": {
                "enabled": true
            }
        }
        ...
    }
    ```

## Supported Operating Systems

- Debian Jessie
- Ubuntu
- CentOS 7
- Amazon Linux

## Depends

- apt
- yum

## Contributions

## Quality Checks

Foodcritic:
- All foodcritic recommendations followed except that I use symbols rather than strings to access node attributes (FC001)

    ```
    $ sudo gem install foodcritic
    $ foodcritic <path_to_recipe>
    ```

Kitchen:
- Use Kitchen to test the cookbook against a real system. Preferably a vagrant machine with Ubuntu or CentOS.

    ```
    $ sudo gem install test-kitchen kitchen-vagrant
    $ kitchen init
    ```

TODO: Unit tests using RSpec and ChefSpec

## License

Licensed under MIT license. License text available in LICENSE.txt

While the cookbook itself is licensed under MIT, the Amazon Inspector installer script, the Amazon Inspector agent binary and files are licensed under other licenses which may be more restrictive than MIT including GPLv2, Apache, PCRE2 and BSD licenses. Please see the following file post installation for the license text pertaining to AWS artefacts.

    /opt/aws/awsagent/LICENSE
