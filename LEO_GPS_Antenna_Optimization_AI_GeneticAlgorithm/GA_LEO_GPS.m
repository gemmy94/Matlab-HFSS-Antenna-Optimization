function yen = GA_LEO_GPS(Problem,Popsize,Nvar,Range,Nbit,Maxit)
// Mutrate and Selection16
mutrate = 0.023;
selection = 0.5;

// readd parameter
ff = Problem;
popsize = Popsize;
nvar = Nvar;
range = Range;
nbit = Nbit;
maxit = Maxit;

totalbit = sum(nbit);

count = 1;

//
    pop = round(rand(popsize,totalbit));
    
for iga = 1:maxit
    if iga == 1
   // quantize the pop to par
    par = par_yen(pop,nvar,nbit,range);
    
   // evaluate fitness function and arrange them to prepare for pair mate
    cost = yen_LEO_test(par,count); 
    count = 1 + popsize;
    else
        
        par(2:popsize,:) = par_yen(pop(2:popsize,:),nvar,nbit,range);
        cost(2:popsize) = yen_LEO_test(par(2:popsize,:),count);
        count = count + popsize - 1;
    end
    
    [cost,ind] = sort(cost);
    
    pop = pop(ind,:);
    par = par(ind,:);
    // evaluate min and mean
    minc(iga)  = cost(1);
    meanc(iga) = mean(cost);
    
    if iga ~= maxit
     // pair and mate
    pop = yen_pair_mate_2(pop,selection);
     // mutation
    pop = mutate_yen(pop,mutrate,selection);
    end

    
    [iga cost(1)]
end
yen = par(1,:);
X =['Best value from evaluating function: ', num2str(cost(1))];
disp(X);
Y =['Best solution: ',num2str(yen(1,1)),' ',num2str(yen(1,2)),' ',num2str(yen(1,3)),' ',num2str(yen(1,4)),' ',num2str(yen(1,5)),' ',num2str(yen(1,6)),' ',num2str(yen(1,7))];
disp(Y);

//plot
figure(24)
iters = 0:length(minc)-1;
plot(iters,minc,'*',iters,meanc,'-');
xlabel('generation'); ylabel('cost');

end