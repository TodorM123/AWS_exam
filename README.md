1. Направете ВПС с 2 частни и 2 публични събнета, в 2 availability зони. Направете autoscaling group с launch template, която да започва с 2 инстанции, които да се деплойват само и единствено в частните събнети. Външният трафик на тези машини да минава през Нат гейтуей и да стига internet Gateway.
2. Направете Application Loadbalancer, който да може да приема целия публичен трафик и да го препраща към машините от аутоскейлинг групата.
3. Направете аларма, която да може вдига още инстанции от аутоскейлинг групата, когато някоя от инстанциите има повече от 80% CPU.
4. Направете ламбда функция (може и през портала), която да може да изключи autoscaling групата и всяка една от инстанциите вътре.
5. Използвайте best practices в писането на тераформ код, включително нейминг конвенции, променливи, data variables и така нататък. Не е нужно да пишете цикли.
6. Кодът ви да е написан в най-добрите практики за сигурност като минимални права на участниците, портовете да са отворени само към необходимите айпи адреси и тн.


# LAMBDA function :


import boto3

def lambda_handler(event, context):
    autoscaling_client = boto3.client('autoscaling')
    
    response = autoscaling_client.suspend_processes(
    AutoScalingGroupName='terraform-20230608102953053600000007',
    ScalingProcesses=['Launch','Terminate','AddToLoadBalancer','AlarmNotification','AZRebalance','HealthCheck','InstanceRefresh','ReplaceUnhealthy','ScheduledActions']
)
    
    ec2_resource = boto3.resource('ec2')


    instances = ec2_resource.instances.filter(Filters=[{'Name': 'instance-state-name', 'Values': ['running']}])

 
    for instance in instances:
        instance_id = instance.id
        print(f"Stopping instance {instance_id}")
        instance.stop()
    
    
    return "Autoscaling group and instances have been stopped"
