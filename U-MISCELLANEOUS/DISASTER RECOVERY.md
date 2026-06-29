A popular interview question candidates get wrong is, "How did you do Disaster Recovery (DR) for your AWS application?"  
  
A common but average answer - I will replicate it in another region.  
  
What the interviewer is looking for is how DR strategies are chosen and what the different strategies are. As an SA, you will be responsible for talking to the app team and coming up with an appropriate DR strategy.  
  
A great answer is There are different DR options to choose from depending on RTO (Recovery Time Objective) and RPO (Recovery Point Objective). The available DR strategies ordered by highest to lowest RTO/RPO (and lowest to highest cost) are the following:  
- Backup and Restore  
- Pilot Light  
- Warm Standby  
- Multi-site Active/Active  
  
Then explain one of the DR strategies in detail. Preferably Multisite Active/Active because it’s used in most critical production applications. Architecture attached.  
  
- The most critical part for DR is the database. In this case, we are utilizing a global table of DynamoDB for active-active mode. If you are using an SQL database like Aurora, keep in mind that Aurora Global Database is active-passive, but new Aurora DSQL is active-active.  
  
- The application stack is running on EC2 with an Auto Scaling Group. You run a minimum of two EC2s in each region to keep it highly available  
  
- Load Balancers are regional service; hence, we are using one load balancer in each region, distributing the traffic to that region  
  
- Route 53 sends traffic to one of the two Load Balancers based on geolocation and latency  
  
- RPO/RTO is minimal in this architecture because data is constantly being replicated, and EC2s are up and running with a minimum count of two in both regions. In some cases, applications make the desired count higher to keep higher number of EC2 running in the second region for lower RTO.  
  
[hashtag#systemdesign](https://www.linkedin.com/search/results/all/?keywords=%23systemdesign&origin=HASH_TAG_FROM_FEED) [hashtag#aws](https://www.linkedin.com/search/results/all/?keywords=%23aws&origin=HASH_TAG_FROM_FEED) [hashtag#cognativinc](https://www.linkedin.com/search/results/all/?keywords=%23cognativinc&origin=HASH_TAG_FROM_FEED) [hashtag#cognativ](https://www.linkedin.com/search/results/all/?keywords=%23cognativ&origin=HASH_TAG_FROM_FEED) [hashtag#cloudwithraj](https://www.linkedin.com/search/results/all/?keywords=%23cloudwithraj&origin=HASH_TAG_FROM_FEED)

Activate to view larger image,

![diagram](https://media.licdn.com/dms/image/v2/D5622AQFijZEe1A5DAg/feedshare-shrink_800/B56Z1XbACVKkAc-/0/1775288191513?e=1776902400&v=beta&t=ywRDS0z53As00jnpISLUwHyLmkbmke8MI3kjO4FNiXk)

Activate to view larger image,

