sample go-task
===

## Requirements

- [go-task](https://taskfile.dev)
- MySQL
- Docker
- Go 1.17

### Environment value

| Varialble | description |
|:--|:--|
| DATASOURCE\_USER     | e.g. sample-go-task   |
| DATASOURCE\_PASSWORD | e.g. sample-go-task   |
| DATASOURCE\_DATABASE | e.g. sample\_go\_task |

## [WIP] Usage

print task list:

```shell
❯ task --list
```

### 1. Print variables

#### 1.1 Echo vars

```shell
❯ task echo:var
```

#### 1.2 How print environment variables in task

```shell
❯ task echo:env:how-print
## Command result
# task: [echo:env:how-print] echo "$ENV_VAR"
# globally environment variable
# task: [echo:env:how-print] echo globally environment variable
# globally environment variable
```

#### 1.3 Load environment variables order

```shell
❯ task echo:env:order
## Command result
# task: [echo:env:order] echo "$ENV_VAR"
# task environment variable
```

```shell
❯ ENV_VAR='shell environment variable' task echo:env:order
## Command result
# task: [echo:env:order] echo "$ENV_VAR"
# shell environment variable
```

#### 1.4 Echo external script

```shell
❯ ./scripts/echo-taskfile-env.sh
## Command result:
# ENV_VAR is not defined

❯ task echo:env:external
## Command result:
# task: [echo:env:external] ./scripts/echo-taskfile-env.sh
# globally environment variable
```

### 2. Build and run packages

```shell
❯ task run
## Command result
# task: [run] go build cmd/greet/main.go
# task: [run] ./main
# Hello, go-task!
```

### 3. Build and run package with watching files

```shell
❯ task run
## Command result
# task: Started watching for tasks: run
# task: [run] go build cmd/greet/main.go
# task: [run] ./main
# Hello, go-task!

## Modify `cmd/greet/main.go` in editor

# task: [run] go build cmd/greet/main.go
# task: [run] ./main
# Hello, go-task with watch option!
```

### 4. Call another task

```shell
❯ task deps
## Command result:
# task: [dep-task3] echo dependency task 3
# task: [dep-task1] echo dependency task 1
# dependency task 1
# dependency task 3
# task: [dep-task2] echo dependency task 2
# dependency task 2
# task: [deps] echo task
# task
```

### 5. Seed the database

```shell
❯ task application:database:setup
❯ task application:database:seed
```
