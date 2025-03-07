---
syntax: markdown
---

## Plan/Apply only specific target
```
terraform plan/apply -target [module.<module name>.]<resource type>.<resource name>
```
Module part is required if the resource is defined inside module.  
Module name is defined in `tf` file where the module is used.  
The module name can also be found by running `terraform state list`.
