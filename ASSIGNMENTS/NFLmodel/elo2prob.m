function prob = elo2prob (elo1, elo2) 
% this function takes in two elo values (ave 1500; divide elodiff by 25 for 
% pt spread) from competing NFL teams and returns the win probability for team1

elodiff = elo1 - elo2;
prob = 1/(10^(-elodiff/400)+1)

end