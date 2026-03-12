ECS
- orquestrador de containers da aws
- gestão de containers simplificada
- full lock-in
- controle plane transparente
- services, tasks definitions e tasks
- computing: ec2 & fargate
- tornar sua aplicação parte da aws
- arns

ECS - componentes
cluster -> services -> task definitions -> tasks

ECS - clusters
- componentes mais simples
- espinha dorsal da organização dos componentes
- grupo lógico de services e tasks
- control plane transparente
- diversos tipos de capacidade

ECS - services
- grupo de tasks
- escopo de aplicação
- manter o número desejado de tasks
- autoscaling
- updates & deployments
- load balancing* 

ECS - tasks definitions
- template de tasks
- especificações de capacidade, segurança e recursos extras
- "forminha" das nossas aplicações
- imutabilidade e versionamento
- json

ECS - tasks
- menor unidade de medida do ECS
- composto de um ou mais containers
- recursos alocados num cluster
- replicas de uma aplicação
- "uma task é uma task definition em movimento"
- de fato, a aplicação em execução no cluster de ECS

ECS - ARN´s
- diferencial do ECS
- tornar sua aplicação um recurso identificável na aws
- ARN´s
- identificar e ser identificado
    - security groups
    - auditorias
    - monitoramento
    - escalabilidade
    - cloudtrail

ECS - computing
- ecs + ec2*
- ecs + fargate*

ECS + ec2
- instâncias ec2 da aws
- controle granular de instâncias
- várias tasks em uma instância
- escolha da família de instâncias
- cpu, ram, I/O, network optimized
- limita a capacidade dos hosts
- capacity providers*

ECS + Fargate
- modelo de computação serveless
- firecracker
- especificação de CPU/RAM
- sem controle de nodes
- flexibilidade de autoscaling
- sem opção de customização de famílias

ECS - capacity providers
- provedores de capacidade
- escalabilidade
- associado services e clusters
- escalabilidade de nodes
- fraços de on-demand / spots
- ec2 e fargate
- otimização de custos
- simplificar a operação de infraestrutura

ECS - observabilidade
- observabilidade nativa da aws
- cloudwatch metricas
- cloudwatch logs
- cloudwatch alerts
- x-ray
- autoscaling

# ====
Construção terraform do cluster do ecs

PRIMERIO PASSO:
pegar os valores do cluster de VPC, precisamos criar um data.tf para pegar esses valores do parameter store na aws, valores esses que são id da vpc e id das subnetes públicas e privadas, data.tf

Criar também as variaveis que vão receber esses valores, estão no variables.tf e os valores estão no terraform.tfvars dentro de environment/dev

SEGUNDO PASSO:
criar o load balancer, primeiro criar os security group do load balancer depois criar a alb e por ultimo criar os listernes do alb, load_balancer.tf

criar o security group do nó do ecs, neste caso será para ec2, sg-ecs-node.tf
criar o ecs cluster com o recurso aws_ecs_cluster, ecs.tf

criar um script para inicialização dos nós, será usando posteriormente pelo launch_template, templates/user-data.tpl

criar o launch_template para a ec2, será como as ec2 irão subir, launch_template.tf

criar o auto scaling group e associar o launch_template nele, asg.tf
criar o recurso aws_ecs_capacity_provider, irá controlar o máximo de nó que irá subir e o mínimo de nó, asg.tf

associar o capacity_provider criado em asg.tf no cluster do ecs com recurso aws_ecs_cluster_capacity_providers, ecs.tf

criar o launch_template para spot a diferença para a ec2 é instance_market_options, launch_template_spots.tf

criar o auto scaling_spot e associar o launch_template_spot nele, asg_spots.tf
criar o recurso aws_ecs_capacity_provider, irá controlar o máximo de nó que irá subir e o mínimo de nó, asg_spots.tf

associar o capacity_provider criado em asg_spots.tf no cluster do ecs com o recurso aws_ecs_cluster_capacity_providers, ecs.tf


