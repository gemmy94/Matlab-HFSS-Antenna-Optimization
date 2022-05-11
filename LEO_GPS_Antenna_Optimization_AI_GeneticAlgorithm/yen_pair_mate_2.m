function yen = yen_pair_mate_2(Pop,Selection)

yen = Pop;
[popsize,totalbit] = size(yen);
selection = Selection;
keep = popsize * selection;

M = ceil((popsize - keep)/2); %the number of matings
for m1 = 1:M
   fa = m1;
   ma = m1 + ceil((keep-m1)*rand(1));
   xp = ceil(rand(1,2)*(totalbit - 1));
   xp = sort(xp);
   if xp(1) == xp(2)
      yen(keep+2*(m1-1)+1,:) = [yen(fa,1:xp) yen(ma,xp+1:totalbit)];
      yen(keep+2*(m1-1)+2,:) = [yen(ma,1:xp) yen(fa,xp+1:totalbit)];
    
   end
   yen(keep+2*(m1-1)+1,:) = [yen(fa,1:xp(1)) yen(ma,xp(1)+1:xp(2)) yen(fa,xp(2)+1:totalbit)];
   yen(keep+2*(m1-1)+1,:) = [yen(ma,1:xp(1)) yen(fa,xp(1)+1:xp(2)) yen(ma,xp(2)+1:totalbit)];
end
end