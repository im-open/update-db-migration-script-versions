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

As a final note, you will have to give your un-versioned scripts temporary versions. The temporary version numbers need to have a difference between them and the latest valid version number greater than the `max-version-gap` parameter. It's best therefore to give the un-versioned scripts a very big number like `9000000` so you don't run into problems.

## Index <!-- omit in toc -->

- [update-db-migration-script-versions](#update-db-migration-script-versions)
  - [Inputs](#inputs)
  - [Usage Examples](#usage-examples)
  - [Contributing](#contributing)
    - [Incrementing the Version](#incrementing-the-version)
    - [Source Code Changes](#source-code-changes)
    - [Updating the README.md](#updating-the-readmemd)
  - [Code of Conduct](#code-of-conduct)
  - [License](#license)

## Inputs

| Parameter               | Is Required | Default | Description                                                                                                                                  |
|-------------------------|-------------|---------|----------------------------------------------------------------------------------------------------------------------------------------------|
| `migration-script-path` | true        | N/A     | The path to the migration scripts. Searching for the scripts is done recursively so pointing at a base directory with sub directories is ok. |
| `max-version-gap`       | true        | 100     | The maximum difference between valid versions and ones to update.                                                                            |

## Usage Examples

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

When creating PRs, please review the following guidelines:

- [ ] The action code does not contain sensitive information.
- [ ] At least one of the commit messages contains the appropriate `+semver:` keywords listed under [Incrementing the Version] for major and minor increments.
- [ ] The README.md has been updated with the latest version of the action.  See [Updating the README.md] for details.

### Incrementing the Version

This repo uses [git-version-lite] in its workflows to examine commit messages to determine whether to perform a major, minor or patch increment on merge if [source code] changes have been made.  The following table provides the fragment that should be included in a commit message to active different increment strategies.

| Increment Type | Commit Message Fragment                     |
|----------------|---------------------------------------------|
| major          | +semver:breaking                            |
| major          | +semver:major                               |
| minor          | +semver:feature                             |
| minor          | +semver:minor                               |
| patch          | *default increment type, no comment needed* |

### Source Code Changes

The files and directories that are considered source code are listed in the `files-with-code` and `dirs-with-code` arguments in both the [build-and-review-pr] and [increment-version-on-merge] workflows.  

If a PR contains source code changes, the README.md should be updated with the latest action version.  The [build-and-review-pr] workflow will ensure these steps are performed when they are required.  The workflow will provide instructions for completing these steps if the PR Author does not initially complete them.

If a PR consists solely of non-source code changes like changes to the `README.md` or workflows under `./.github/workflows`, version updates do not need to be performed.

### Updating the README.md

If changes are made to the action's [source code], the [usage examples] section of this file should be updated with the next version of the action.  Each instance of this action should be updated.  This helps users know what the latest tag is without having to navigate to the Tags page of the repository.  See [Incrementing the Version] for details on how to determine what the next version will be or consult the first workflow run for the PR which will also calculate the next version.

## Code of Conduct

This project has adopted the [im-open's Code of Conduct](https://github.com/im-open/.github/blob/main/CODE_OF_CONDUCT.md).

## License

Copyright &copy; 2023, Extend Health, LLC. Code released under the [MIT license](LICENSE).

<!-- Links -->
[Incrementing the Version]: #incrementing-the-version
[Updating the README.md]: #updating-the-readmemd
[source code]: #source-code-changes
[usage examples]: #usage-examples
[build-and-review-pr]: ./.github/workflows/build-and-review-pr.yml
[increment-version-on-merge]: ./.github/workflows/increment-version-on-merge.yml
[git-version-lite]: https://github.com/im-open/git-version-lite
