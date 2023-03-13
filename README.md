# update-db-migration-script-versions

This action takes in a path to your SQL migration scripts (`.sql` files) and updates any of them that have versions outside of the sequential order. For example, if this folder structure was the one the action was processing

```txt
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
      - uses: actions/checkout@v3

      - name: Update the versions of migration scripts
        uses: im-open/update-db-migration-script-versions@v1.0.3
        with:
          migration-script-path: '.\Database\Migrations'
```

## Contributing

When creating new PRs please ensure:

1. For major or minor changes, at least one of the commit messages contains the appropriate `+semver:` keywords listed under [Incrementing the Version](#incrementing-the-version).
1. The action code does not contain sensitive information.

When a pull request is created and there are changes to code-specific files and folders, the `auto-update-readme` workflow will run.  The workflow will update the action-examples in the README.md if they have not been updated manually by the PR author. The following files and folders contain action code and will trigger the automatic updates:

- `action.yml`
- `src/**`

There may be some instances where the bot does not have permission to push changes back to the branch though so this step should be done manually for those branches. See [Incrementing the Version](#incrementing-the-version) for more details.

### Incrementing the Version

The `auto-update-readme` and PR merge workflows will use the strategies below to determine what the next version will be.  If the `auto-update-readme` workflow was not able to automatically update the README.md action-examples with the next version, the README.md should be updated manually as part of the PR using that calculated version.

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
