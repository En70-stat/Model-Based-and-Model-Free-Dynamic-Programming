Please read this as Raw version. Thanks :)

Honours Project completed to fulfill the requirements of the degree B.math honours: statistics. 

Model-Based and Model Free Dynamic Programming

Please read this as Raw version. Thanks :)


HOW TO READ THE OUTPUT FILE


Here's some context for the matlab function named Q_learning_code.m

I am using a search method called Q-learning where a virtual agent finds the shortest path from its start to the reward denoted as the square with the number 100. 
The maze will always be and NxN discrete grid containing boxes called "states" that the virtual agent can reside in, and will be indexed from top to bottom then left to right.
For example, a 3x3 maze will be indexed like this:

|-----|-----|-----|
|  1  |  4  |  7  |
|-----|-----|-----|
|  2  |  5  |  8  |
|-----|-----|-----|
|  3  |  6  |  9  |
|-----|-----|-----|

In each state, the agent can either take actions: up,down,left,right. The agent traverses the grid taking random actions until it reaches a terminal state with a score. 
A terminal state with -100 provides negative score meaning that taking an action in the previous state leading to the terminal state receives a negative score. Similarly, taking an action in the previous state that leads 
to 100 provides positive score. 


The first grid of numbers called Q is the "Q-table". It is the blank table that use to score state-action pairs. Each row corresponds to a state number and each column corresponds to an action. The columns are ordered
to match {up,down,left,right}. A score of 100 in the 4th row 2nd column means that going down in the 4th state has a score of 100. 


Next we have the Env matrix 
Env =

     0  -100     0     0     0
     0     0     0  -100     0
  -100     0  -100  -100     0
     0     0     0  -100     0
     0     0     0     0   100

This is the representation of the maze grid with terminal states and their scores. For example, if the agent in the 24th state and goes left, a score of -100 will be recorded on the 24th row and the 3rd column of Q.

terminals =

     0     1     0     0     0
     0     0     0     1     0
     1     0     1     1     0
     0     0     0     1     0
     0     0     0     0     1

terminals just shows us where which states end the training run and sends the virtual agent back to the start. 

Finally, the completed Q-table is 

ans =

         0   47.8297         0 -100.0000
   43.0467 -100.0000         0   53.1441
         0         0         0         0
 -100.0000   65.6100         0   65.6100
   59.0490         0         0   72.9000
         0         0         0         0
 -100.0000   59.0490   47.8297   47.8297
   53.1441   65.6100 -100.0000 -100.0000
   59.0490   72.9000   59.0490   72.9000
   65.6100         0   65.6100   81.0000
         0   47.8297 -100.0000   59.0475
   53.1427 -100.0000   53.1441 -100.0000
         0         0         0         0
 -100.0000   81.0000   65.6100 -100.0000
   72.9000         0   72.9000   90.0000
         0 -100.0000   53.1426   65.6083
         0         0         0         0
         0         0         0         0
         0         0         0         0
 -100.0000         0   81.0000  100.0000
         0   72.8982   59.0474         0
   65.6079   80.9983 -100.0000         0
   72.8971   89.9985 -100.0000         0
   80.9663   99.9989  -99.9884         0
         0         0         0         0


To obtain the optimal path from start to finish we take the action with the highest score in each state



     
