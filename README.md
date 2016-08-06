# hierarchy_tests
A sandbox app for testing performance of querying hierarchies in postgresql.

This is not meant to be a production app, just a way to benchmark the performance of different hierarchy/tree gems.

Current gems being tested:
* `ancestry`
* `closure_tree`

If you want to see any added, raise an issue, or even better add it and create a PR.

## Setting up
Currently, you DO NOT want to setup the db with `rake db:migrate` and `rake db:seed`. Some of the migrations were hacked together to get sample data loaded,
and if you run them in order right now, things will not come out right.

For now, you can setup the sample db with:
```bash
$ rake db:restore
```

## Running Benchmarks
The rake tasks for benchmarking are currently a work in progress.

For now, you can restore the db and manually test in the rails console.

## Notes
In the interest of making setup faster, and knowing this is not planned for
production, a few ugly things have been done so far. If you hate any of these
enough to fix them and create a PR, please do:
* Unnecessarily a full Rails app
  * Left it this way, in-case anyone wants to try to make benchmarking reports available over the web, but this really is a database/activerecord benchmarking app
* The `SELECT INTO` in a migration to create and seed table
  * This one is particularly bad, and I plan to fix it, so the creation remains in the migration, and the seeding happens in the seed file
  * You have to do hacky things right now
* The model names `Employee` and `Worker` are arbitrary and don't indicate the gem being used
  * Should be switched to `AncestryEmployee` and `ClosureTreeEmployee`
* A postgresql dump file is checked in
  * It took many hours (almost a day with restarts) to seed the db with ~300K records, if you want to test with that many records of fake data, but want to restore in seconds/minutes instead, you're welcome.
  * This probably belongs on S3 where many sample databases can be made available without blowing up this repo.
* Currently tied to postgres
  * I always use postgres, so I don't have plans to change this, but a PR to support other db's is welcome.
* The sample data is arbitrary, not based on a real company, too many levels, not enough levels, too many records, not enough records, not enough variety in paths, or otherwise garbage.
  * You can see the logic for creating the sample data in `db/seeds.rb`. Tony Stark has hundreds of thousands of descendants - there are 16 levels, the org is bottom heavy with ~186K "leaf" employees and one "root" employee.
  * I welcome any real data that can be made publicly available

## To Do
* Implement the benchmarking rake tasks
* Make the migrations and seeding more coherent (may cause a breaking change)
* Make the sample db available on S3 (or similar) instead of in the repo
