function yen = cost_LEO(data_LEO)
count_LEO = 0;


yen_data_LEO = data_LEO;


%% Evaluate LEO
for i = 42:62
    if yen_data_LEO(i,2)<-10
       count_LEO = count_LEO + 1; 
    end
end

yen = -count_LEO;

end
