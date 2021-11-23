# update-db-migration-script-versions

This action takes in a path to your SQL migration scripts (`.sql` files) and updates any of them that have versions outside of the sequential order. For example, if this folder structure was the one the action was processing

```
Database
│
└───folder1
│   │   V0000001__FirstScript.sql
│   │   V0000002__SecondScript.sql
│   │   ...
│   
└───folder2
    │   V0000099__AnotherScript.sql
    │   V9000000__UnversionedScript.sql
```

it would update the `V9000000__UnversionedScript.sql` filename to `V0000100__UnversionedScript.sql`.

It's important to note that your filenames need to follow the pattern `V###__***.sql`, where `###` can be any number and `***` can be any other character. When this action renames files it will buffer the version number with zeros until there are seven numbers.

As a final note, you will have to give your unversioned scripts temporary versions. The temporary version numbers need to have a difference between them and the latest valid version number greater than the `max-version-gap` parameter. It's best therefore to give the unversioned scripts a very big number like `9000000` so you don't run into problems.

## Index

- [Inputs](#inputs)
- [Example](#example)
- [Contributing](#contributing)
  - [Incrementing the Version](#incrementing-the-version)
- [Code of Conduct](#code-of-conduct)
- [License](#license)    

## Inputs
| Parameter               | Is Required | Default | Description                                                                                                                                  |
| ----------------------- | ----------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| `migration-script-path` | true        | N/A     | The path to the migration scripts. Searching for the scripts is done recursively so pointing at a base directory with sub directories is ok. |
| `max-version-gap`       | true        | 100     | The maximum difference between valid versions and ones to update.                                                                            |

## Example

```yml
# TODO: Fill in the correct usage
jobs:
  update-migration-scripts:
    runs-on: [self-hosted]
    steps:
      - uses: actions/checkout@v2

      - name: Update the versions of migration scripts
        uses: im-open/update-db-migration-script-versions@v1.0.1
        with:
          migration-script-path: '.\Database\Migrations'
```


## Contributing

When creating new PRs please ensure:
1. For major or minor changes, at least one of the commit messages contains the appropriate `+semver:` keywords listed under [Incrementing the Version](#incrementing-the-version).
2. The `README.md` example has been updated with the new version.  See [Incrementing the Version](#incrementing-the-version).
3. The action code does not contain sensitive information.

### Incrementing the Version

This action uses [git-version-lite] to examine commit messages to determine whether to perform a major, minor or patch increment on merge.  The following table provides the fragment that should be included in a commit message to active different increment strategies.
| Increment Type | Commit Message Fragment                     |
| -------------- | ------------------------------------------- |
| major          | +semver:breaking                            |
| major          | +semver:major                               |
| minor          | +semver:feature                             |
| minor          | +semver:minor                               |
| patch          | *default increment type, no comment needed* |

## Code of Conduct

This project has adopted the [im-open's Code of Conduct](https://github.com/im-open/.github/blob/master/CODE_OF_CONDUCT.md).

## License

Copyright &copy; 2021, Extend Health, LLC. Code released under the [MIT license](LICENSE).

[git-version-lite]: https://github.com/im-open/git-version-lite
