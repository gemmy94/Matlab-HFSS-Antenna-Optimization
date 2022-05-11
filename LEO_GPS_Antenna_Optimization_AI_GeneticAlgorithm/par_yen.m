function yen = par_yen(Pop,Nvar,Nbit,Range)

pop_bien = Pop;
nvar_bien = Nvar;
nbit_bien = Nbit;
range_bien = Range;
yen_range = [0 cumsum(nbit_bien)];


for p = 1:nvar_bien
   par(:,p) = gadecode(pop_bien(:,yen_range(p)+1:yen_range(p+1)),range_bien(p,1),range_bien(p,2),nbit_bien(p)); 
end
yen = par;
end