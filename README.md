# Initial_infr

Спринт 1

ЗАДАЧА

```
Опишите инфраструктуру будущего проекта в виде кода с инструкциями по развертке, нужен кластер Kubernetes и служебный сервер (будем называть его srv):

1 Выбираем облачный провайдер и инфраструктуру.
В качестве облака подойдет и Яндекс.Облако, но можно использовать любое другое по желанию.
Нам нужно три сервера:
два сервера в одном кластере Kubernetes: 1 master и 1 app;
сервер srv для инструментов мониторинга, логгирования и сборок контейнеров.

2 Описываем инфраструктуру.
Описывать инфраструктуру мы будем, конечно, в Terraform.
Совет: лучше создать под наши конфигурации отдельную группу проектов в Git, например, devops.
Пишем в README.md инструкцию по развертке конфигураций в облаке. Никаких секретов в коде быть не должно.

3 Автоматизируем установку.
Надо реализовать возможность установки на сервер всех необходимых нам настроек и пакетов, будь то docker-compose, gitlab-runner или наши публичные ключи для доступа по SSH. Положите код автоматизации в Git-репозиторий.
Результат должен быть такой, чтобы после запуска подобной автоматизации на сервере устанавливалось почти всё, что нужно.

Совсем полностью исключать ручные действия не надо, но в таком случае их надо описать в том же README.md и положить в репозиторий.
```

Решение:
```
С помощью terraform запускаем создание инфраструктуры и устанавливаем нужное окружение и пакеты:
  - Запускается развертывание сервера srv под сервисные задачи, деплой и сборку:
  ```
  terraform apply
  ```
  - В процессе установки создаётся ВМ, сервисный аккаунт, сети, сервер srv подготавливается через provisioning-скрипт - ставятся необходимые утилиты (ansible, terraform, terragrunt, jq, docker, docker-compose, git, gitlab-runner, kubeadm, kubectl, helm), пакеты и сопутствующие зависимости.
  - Устанавливается окружение для будущего разворачивания k8s кластера, согласно requirements версии 2.9.
  - Автоматически клонируются на srv репозитории (kubernetes_setup и форком kubespray) с кодом развертывания кластера k8s с помощью kubesprayю Подкладываем ключи, даём разрешения.
  - Устанавливается автоматически с сервера srv кластер k8s или по желанию вручную запуском с сервисной ноды скрипта развёртывания. Второй путь предпочтительнее для прозрачности и облегчения поиска ошибок.
  В этом случае после развертывания srv ноды, нужно войти по ssh и запустить скрипт развертывания k8s кластера с этойт ноды:
  ```
  cd /opt/kubernetes_setup/ && ./cluster_install.sh
  ```
```

Результаты выполнения развёртываний инфраструктуры и кластера:
