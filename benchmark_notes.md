# Notes on Benchmark Results
The following is from an informal analysis, see `benchmark_[category]_results.txt` for benchmark data.

## Reading data
See `benchmark_read_results.txt` for data.

| Method (note) | ancestry     | closure_tree |
|---------------|--------------|--------------|
| parent        | ~same        | ~same        |
| root          | 4x faster    | 4x slower    |
| depth*        | 6x faster    | 6x slower    |
| ancestors     | ~70% faster  | ~70% slower  |
| children      | ~same        | ~same        |
| siblings      | ~same        | ~same        |
_*This is without any depth caching for either gem_

I'm breaking out descendants to highlight some things. At great scale, ancestry performs faster, but at what might be considered reasonable counts, closure_tree is faster.

You can see the trend below. The fewer the descendants, the faster closure_tree is (often by 2 orders of magnitude). As you grow to a crazy amount of descendants, somewhere, ancestry becomes faster. Not sure what the magic number is, but it may not occur until you hit hundreds of thousands.

| Method (note)                  | ancestry           | closure_tree     |
|--------------------------------|--------------------|------------------|
| count: 300K+, depth: 0         |                    |                  |
| descendants.to_a (300K+)       | ~same              | ~same            |
| descendants.pluck(:id) (300K+) | ~2X faster         | ~2X slower       |
| descendants.size (300K+)       | ~3X faster         | ~3X slower       |
| descendants.count (300K+)      | ~3X faster         | ~3X slower       |
|--------------------------------|--------------------|------------------|
| count: 317, depth: 5           |                    |                  |
| descendants.to_a (317)         | ~50X slower        | ~50X faster      |
| descendants.pluck(:id) (317)   | ~94X slower        | ~94X faster      |
| descendants.size (317)         | ~87X slower        | ~87X faster      |
| descendants.count (317)        | ~110X slower       | ~110X faster     |
|--------------------------------|--------------------|------------------|
| count: 123, depth: 6           |                    |                  |
| descendants.to_a (123)         | ~74X slower        | ~74X faster      |
| descendants.pluck(:id) (123)   | ~85X slower        | ~85X faster      |
| descendants.size (123)         | ~103X slower       | ~103X faster     |
| descendants.count (123)        | ~110X slower       | ~110X faster     |
|--------------------------------|--------------------|------------------|
| count: 11, depth: 2            |                    |                  |
| descendants.to_a (11)          | ~135X slower       | ~135X faster     |
| descendants.pluck(:id) (11)    | ~135X slower       | ~135X faster     |
| descendants.size (11)          | ~160X slower       | ~160X faster     |
| descendants.count (11)         | ~175X slower       | ~175X faster     |
|--------------------------------|--------------------|------------------|
| count: 1, depth: 1             |                    |                  |
| descendants.to_a (1)           | ~175X slower       | ~175X faster     |
| descendants.pluck(:id) (1)     | ~175X slower       | ~175X faster     |
| descendants.size (1)           | ~180X slower       | ~180X faster     |
| descendants.count (1)          | ~150X slower       | ~150X faster     |
|--------------------------------|--------------------|------------------|
