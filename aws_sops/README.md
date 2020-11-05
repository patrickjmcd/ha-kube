# Creating a KMS Key for SOPS

From: https://medium.com/mercos-engineering/secrets-as-a-code-with-mozilla-sops-and-aws-kms-d069c45ae1b9

## 1. Create a cloudformation stack with a kms user

```Shell
aws cloudformation deploy \
--stack-name kms-example \
--template-file ./cloudformation.1.yaml \
--capabilities CAPABILITY_NAMED_IAM
```

## 2. Create the KMS Key

```Shell
aws cloudformation deploy \
--stack-name kms-example \
--template-file ./cloudformation.2.yaml \
--capabilities CAPABILITY_NAMED_IAM
```

## 3. Get the ARN for the Key

```Shell
aws cloudformation describe-stacks
```
