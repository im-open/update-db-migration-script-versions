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

As a final note, you will have to give your unversioned scripts temporary versions. The temporary version numbers need to have a difference between them and the latest valid version number greater than the `max-version-gap` paramater. It's best therefore to give the unversioned scripts a very big number like `9000000` so you don't run into problems.

    

## Inputs
| Parameter               | Is Required | Default | Description           |
| ----------------------- | ----------- | ------- | -------------- |
| `migration-script-path` | true        | N/A     | The path to the migration scripts. Searching for the scripts is done recursively so pointing at a base directory with sub directories is ok. |
| `max-version-gap`       | true        | 100     | The maximum difference between valid versions and ones to update. |

## Example

```yml
# TODO: Fill in the correct usage
jobs:
  update-migration-scripts:
    runs-on: [self-hosted]
    steps:
      - uses: actions/checkout@v2

      - name: Update the versions of migration scripts
        uses: im-open/update-db-migration-script-versions@v1.0.0
        with:
          migration-script-path: '.\Database\Migrations'
```


## Code of Conduct

This project has adopted the [im-open's Code of Conduct](https://github.com/im-open/.github/blob/master/CODE_OF_CONDUCT.md).

## License

Copyright &copy; 2021, Extend Health, LLC. Code released under the [MIT license](LICENSE).
