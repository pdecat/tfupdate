# tfupdate

Update version constraints in your Terraform configurations

# Why?

It is a best practice to break your Terraform configuration and state into smaller pieces based on the frequency of updates to minimize the impact of an accident.
It is also recommended that you lock versions of Terraform core and dependent providers and keep them up to date by updating them regularly.
However, it is a toil to update the version constraints scattered across multiple directories in Terraform configurations.

That is why I wrote a tool which parses Terraform configurations and updates all version constraints at once.

# Features

- Update version constraints of Terraform core and providers
- Update all your Terraform configurations recursively under a given directory

# Supported Terraform version

- Terraform v0.12+

# Install

```
$ go get github.com/minamijoyo/tfupdate
```

# Example

```
$ cat main.tf
terraform {
  required_version = "0.12.7"
}

provider "aws" {
  version = "2.27.0"
}
```

```
$ tfupdate terraform -v 0.12.8 -f main.tf

$ git diff
diff --git a/main.tf b/main.tf
index ce0ff1c..1dd7294 100644
--- a/main.tf
+++ b/main.tf
@@ -1,5 +1,5 @@
 terraform {
-  required_version = "0.12.7"
+  required_version = "0.12.8"
 }

 provider "aws" {

$ git add . && git commit -m "Bump terraform to v0.12.8"
[master dc46c06] Bump terraform to v0.12.8
 1 file changed, 1 insertion(+), 1 deletion(-)
```

```
$ tfupdate provider -v aws@2.28.0 -f ./

$ git diff
diff --git a/main.tf b/main.tf
index 1dd7294..241ac69 100644
--- a/main.tf
+++ b/main.tf
@@ -3,5 +3,5 @@ terraform {
 }

 provider "aws" {
-  version = "2.27.0"
+  version = "2.28.0"
 }

$ git add . && git commit -m "Bump terraform-provider-aws to v2.28.0"
[master 0e298ac] Bump terraform-provider-aws to v2.28.0
 1 file changed, 1 insertion(+), 1 deletion(-)
```

If you want to update all your Terraform configurations under the current directory recursively,
run a command like this:

```
$ tfupdate terraform -v 0.12.8 -f ./ -r
```

# Usage

```
$ tfupdate --help
Usage: tfupdate [--version] [--help] <command> [<args>]

Available commands are:
    provider     Update version constraints for provider
    terraform    Update version constraints for terraform

```

```
$ tfupdate terraform --help
Usage: tfupdate terraform [options]

Options:
  -v    A new version constraint
  -f    A path of file or directory to update (default: ./)
  -r    Check a directory recursively (default: false)
```

```
$ tfupdate provider --help
Usage: tfupdate provider [options]

Options:
  -v    A new version constraint.
        The valid format is <PROVIER_NAME>@<VERSION>
  -f    A path of file or directory to update (default: ./)
  -r    Check a directory recursively (default: false)
```

# License

MIT