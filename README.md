# terraform-ecs
Create ECS infrastructure for AWS

## 手動で設定するもの
### Terraform実行前
- Route53でドメイン取得

### Terraform実行後
- ChatBotの登録
    - Alarm等の通知系SNSトピックを登録

## Usage
Set AWS Credentials
```
$ cp .env.sample .env
$ vi .env
```

### Run
1. Initialize terraform
```
$ docker-compose run --rm terraform init
$ docker-compose run --rm terraform get
```

2. Create SSH key
```
$ ssh-keygen -t rsa -b 4096 -C "username" (e.g. development)
Enter file in which to save the key (/Users/username/.ssh/id_rsa): {terraform_directory}/terraform/user_files/.ssh/dev_rsa
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
```

3. Select workspace
```
$ docker-compose run --rm terraform workspace select [dev/stg/prod]
```

4. Check plan
```
$ docker-compose run --rm terraform plan
```

5. Apply
```
$ docker-compose run --rm terraform apply
```

### Lint
```
$ docker-compose run --rm terraform fmt --recursive
```
