# swarm
Chef cookbook for configuring Docker Swarm nodes.

#### Recipes
##### default.rb
Pulls the swarm image

##### manager.rb
Runs a swarm manager container

##### worker.rb
Runs a swarm worker container

##### service.rb
Uses the Docker cookbook resource to ensure that Docker is installed and running
The recipe uses minimal configuration, it is expected that most cookbook users will set up
Docker directly

