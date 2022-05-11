function yen = mutate_yen(Pop,Mutrate,Selection)
pop_bien = Pop;
mutrate_bien = Mutrate;
selection_bien = Selection;
[popsize_bien,totalbit_bien] = size(pop_bien);
keep = ceil(popsize_bien*selection_bien);

% Number of mutation
nmut = ceil((popsize_bien-1)*totalbit_bien*mutrate_bien);

% Number of chromosome must be mutated
nmut_keep = keep - 1;

% Mutate the chromosome that was kept
mcol_keep = ceil(rand(1,nmut_keep)*totalbit_bien);
for ii = 1:nmut_keep
   pop_bien(ii+1,mcol_keep(ii)) = abs(pop_bien(ii+1,mcol_keep(ii))-1);
end
% Mutate the chromosomes that are generated 
nmut_remain = nmut - nmut_keep;
mrow_remain = ceil(rand(1,nmut_remain)*(popsize_bien-keep))+keep;
mcol_remain = ceil(rand(1,nmut_remain)*totalbit_bien);

for iii = 1:nmut_remain
    pop_bien(mrow_remain(iii),mcol_remain(iii)) = abs(pop_bien(mrow_remain(iii),mcol_remain(iii))-1);
end

yen = pop_bien;    
    
end