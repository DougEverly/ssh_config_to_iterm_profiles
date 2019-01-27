# ssh_config_to_iterm_profiles

This script reads the ssh_confg for host definitions and generates a dynamic iTerm profiles.json.

Profiles are assigned the default profile by default so that profile settings are inherited. Custom parent profiles can be defined in iTerm and associated with hosts by changing the `profile_parents` hash with the approporate pattern.

## Installation

git clone this repo.

build

```
crystal build ssh_config_to_iterm_profiles.cr
```

## Usage

```
Usage: ssh_config_to_iterm_profiles [arguments]
    -c SSH_CONFIG, --ssh-config=SSH_CONFIG
                                     path to ssh config
    -p DYNAMIC_PROFILE_DIR, --profile-dir=DYNAMIC_PROFILE_DIR
                                     path to iTerm2 dynamic profiles dir
    -n PROFILE_NAME, --outnameput=PROFILE_NAME
                                     generated profile name
    -v, --verbose                    verbose
    -d, --defaults                   Show defaults
    -h, --help                       Show this help
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/foo/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Doug Everly](https://github.com/your-github-user) - creator and maintainer
