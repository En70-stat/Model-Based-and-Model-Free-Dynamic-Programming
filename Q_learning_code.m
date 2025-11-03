clear all;
%[1,2,3,4] = [up, down, left, right]
%current state in a nxn matrix is indexed like this

% 1 4 7
% 2 5 8 
% 3 6 9

%threeGrid = [0 -100 0 ; 0 0 0;-100 -100 100];
rng(100)


%Gridworld =    [0 -100 0 0 0; 0 -100 0 -100 0;0 -100 0 -100 0 ;  0 0 0 -100 0; 0 0 0 0 100];

Gridworld = [0 -100 0 0 0; 0 0 0 -100 0; -100 0 -100 -100 0 ; 0 0 0 -100 0; 0 0 0 0 100];

[Q,Env,terminals] = initialize_QtableandEnv(4,Gridworld); 
Q = transpose(Q)
Env
terminals
[q_highexp,rewards_highexp] = Qlearning(Gridworld,0.9,0.9,500000,0.1);
[q_lowexp,rewards_lowexp] = Qlearning(Gridworld,0.25,0.9,500000,0.1);
[q_midexp,rewards_midexp] = Qlearning(Gridworld,0.6,0.9,500000,0.1);

transpose(q_highexp)

plot(rewards_lowexp,'blue')
hold on;
%figure;
plot(rewards_highexp,'red')
hold on;
plot(rewards_midexp,'green')
legend('low exploration 0.25','high exploration 0.9','medium exploration 0.6')
xlabel('episode number');
ylabel('sum of episode opimtal policy')

%q_midexp;
%q_lowexp;
%q_highexp;

%legend('low exploration', 'high exploration','medium exploration');


function[Q,episode_rewards] = Qlearning(Environment,exploration_rate,discount_rate,maximum_episodes,learning_rate)
    episode_rewards = zeros(1,maximum_episodes);
    [Q,Env,terminals] = initialize_QtableandEnv(4,Environment);
    for i=1:maximum_episodes
        terminal_check = false;
        currentstate = 1;
        while terminal_check == false
            stateaction = getAction(currentstate,Q,exploration_rate);
            newState = getNewState(stateaction,currentstate,Env);
            terminal_check = isTerminal(newState,terminals);
            Q = updateQtable(Q,stateaction,currentstate,newState,discount_rate,learning_rate,terminal_check);
            currentstate = newState;
        end
    v = linspace(1,size(Q,2),size(Q,2));
    current_episode_reward = sum(max(Q(:,v)));
    episode_rewards(i) = current_episode_reward;


    end



end


function [Qtable,Env,terminals]= initialize_QtableandEnv(actionspace ...
    ,Env)

statespace = size(Env,1);
Qtable = zeros(actionspace,statespace^2);
terminals = zeros(statespace);
    for i = 1:statespace^2
        if Env(i) ~= 0
            terminals(i) = 1;
        end   
    end
end


function [action,actionset] = getAction(currentstate, Qtable, epsilon)
   %this function needs to check the type of state (Edge of map,corner,center) 
   %we are in and randomly
   %select an admissible action.
   %according to an epsilon greedy policy
    
   statespace = sqrt(size(Qtable,2));
   action = 0;
    
  if mod(currentstate,statespace) == 1 %check if on first row

    if currentstate == 1
         actionset = [2 4];
    elseif currentstate ==  1 + statespace*(statespace - 1)
        actionset = [2 3];
    else
        actionset = [2 3 4];
    end
  
  elseif currentstate <= statespace %check if on left most column
      if currentstate == 1
         actionset = [2 4];
      elseif currentstate == statespace 
        actionset = [1 4];
      else
         actionset = [1 2 4];
      end
  elseif mod(currentstate,statespace) == 0 %check if on bottom row
      if currentstate == statespace 
        actionset = [1 4];
       elseif currentstate == statespace^2 
        actionset = [1 3];
      else
        actionset = [1 3 4];
      end
  elseif currentstate>= 1 + statespace*(statespace - 1) %check if on right col
      if currentstate == 1 + statespace*(statespace - 1) 
        actionset = [2 3];
      elseif currentstate == statespace^2
          actionset = [1 3];
      else 
          actionset = [1 2 3];
      end
  else
      actionset = [1 2 3 4];
  end

  r = rand(1);
  max_selection_set = zeros(1,4);
  if r < epsilon
      action = datasample(actionset,1);
  else
      for i =1:4
          if ismember(i,actionset)
             max_selection_set(i) = Qtable(i,currentstate); 
          else
              max_selection_set(i) = -inf;
            
          end
      end
      Y = find(max_selection_set == max(max_selection_set));
      action = datasample(Y,1);
    
  end
end


function[newState] = getNewState(action,currentState,Env)

    statespace = size(Env,1);
    if action == 1
        newState = currentState - 1; %down action
    elseif action == 2
        newState = currentState + 1; %up action
    elseif action == 3
        newState = currentState - statespace; %left action
    else
        newState = currentState + statespace; %right action
    end
end



function[terminal] = isTerminal(Nextstate,terminalstates)
    if terminalstates(Nextstate) == 1
        terminal = true;
    else
        terminal = false;
    end
end



function[Qtable] = updateQtable(Qtable,action,currentstate,nextstate,discount_rate,learning_rate,terminal_next)
    if terminal_next == true
        if nextstate == size(Qtable,2)
            R = 100;
        else
            R = -100;
        end
    else
       R = 0;
    end
    Qtable(action,currentstate) = Qtable(action,currentstate) + learning_rate*(R + discount_rate*max(Qtable(:,nextstate)) - Qtable(action,currentstate));
        
end




