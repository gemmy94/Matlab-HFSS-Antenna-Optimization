function yen = cost_LEO_GPS(data_LEO,data_GPS)
count_LEO = 0;
count_GPS = 0;

yen_data_LEO = data_LEO;
yen_data_GPS = data_GPS;

%% Evaluate LEO
for i = 46:56
    if yen_data_LEO(i,2)<-10
       count_LEO = count_LEO + 1; 
    end
end
for i = 49:51
   if yen_data_LEO(i,2)<-15
       count_LEO = count_LEO + 2; 
   end 
    if yen_data_LEO(i,2)<-20
       count_LEO = count_LEO + 3; 
    end
end
%% Evaluate GPS
for i = 71:81
    if yen_data_GPS(i,2)<-10
       count_GPS = count_GPS + 1; 
    end
end
for i = 75:77
   if yen_data_GPS(i,2)<-15
       count_LEO = count_GPS + 2; 
   end 
    if yen_data_GPS(i,2)<-20
       count_GPS = count_GPS + 3; 
    end
end

yen = -(count_LEO + count_GPS);

end
