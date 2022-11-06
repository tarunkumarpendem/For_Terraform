# Terraform template for creating Application Load Balancer

###
steps:
------
* First we need to create a vpc ( we can also use default VPC )
![preview](vpc.png)
* Then we need to create subnets ( we can use default subnets for this also)
![preview](subnets.png)
* Then we need to create an Internet Gateway which is for providing internet for the vpc ideally we have to attach internet gateway to vpc but we need not do that if we create it from terraform, because it will attach Internet Gate Way to VPC while creating internet gateway it self ( we can use default internet gateway for this also) 
![preview](igw.png)
* Then we need to create a Route Table and create a route to internet gateway so that the subnets which we associate with the routetable can access internet ( Dafault route table is already had a route to defalut internet gateway and associated with default subnets, we can use that also)
![preview](rtb.png)
* Then we need to create a security group for the vpc which we created earlier with some security group rules which are required, here i opened 'ssh' for logging into the EC2 instance and 'http' for apache2 server.
![preview](sg.png)
* Then we need to create an EC2 Instance
   * For creating EC2 instance we need
       * amiid:
            * The amiid is unique id for every O.S. which is given by 'AWS' itself and  it is not same across the 'AWS' regions even the O.S. is same. 
            * We run applications inside an O.S. and create an O.S. in 'AWS' we need an amiid, we can create an ami in 'AWS' and we can also use 'packer' tool for ami creation.
            * Here, i created an ami from an instance in which 'apache2' server is running in it using 'packer'
       * keypair:
            * We can create keypair from 'AWS' or we can also create our own keypair and add it to 'AWS' and then we can use that, here i used the keypair which i created
       * the above resources
![preview](ec2.png)   
* Then we need to create the Load Balancer to create load balancer we need a target group which is attached with the instance in which we want to attach.
![preview](tg.png)
* After that we need to create load balancer ( either Network Load Balancer [Layer-4] or Application Load Balancer [Layer-7]) here, i created 'Layer-7' load balancer.
![preview](alb.png)
* We need to create a listener also for load balancer, A listener is a process that checks for connection requests.
![preview](listener.png)

### Now if we search with the arn of the load balancer we can able to see our aplication running which is 'apache2' in our case.
![preview](output.png)

Note:
----
   * Layer-4( Network Load Balancer ) has the intelligence of 'tcp', 'udp' protocols  and where as Layer-7( Application Load Balancer ) has the intelligence of 'HTTP', 'url', 'HTTPS' and with the intelligence of Layer-4 load balancer.


     

