---
syntax: markdown
---

# Labels

## List all the labels
`https://<host>/api/v1/labels`

## List all labels the value of which matches the specified value (httpie)
`https://<host>/api/v1/labels 'match[]=={<label>="<label value>"}'`
e.g.
`https://<host>/api/v1/labels 'match[]=={job="some_job_name"}'`

## List all values of the specific label
`https://<host>/api/v1/label/<label>/values`

## List all the metric names
`https://<host>/api/v1/label/__name__/values`

## List all metric names with the specific label (httpie)
`https://<host>/api/v1/label/__name__/values 'match[]=={<label>="<label value>"}'`
e.g.
`https://<host>/api/v1/label/__name__/values 'match[]=={job="some_job_name"}'`
