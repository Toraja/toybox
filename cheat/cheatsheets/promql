---
syntax: markdown
---

NOTE: `httpie` is used to as it does not require escaping parameter like `curl`

# Labels

## List all the labels
```sh
http https://<host>/api/v1/labels
```

## List all labels the value of which matches the specified value
```sh
http https://<host>/api/v1/labels 'match[]=={<label>="<label value>"}'
```
e.g.
```sh
http https://<host>/api/v1/labels 'match[]=={job="some_job_name"}'
```

## List all values of the specific label
```sh
http https://<host>/api/v1/label/<label>/values
```

## List all the metric names
```sh
http https://<host>/api/v1/label/__name__/values
```

## List all metric names with the specific label
```sh
http https://<host>/api/v1/label/__name__/values 'match[]=={<label>="<label value>"}'
```
e.g.
```sh
http https://<host>/api/v1/label/__name__/values 'match[]=={job="some_job_name"}'
```
