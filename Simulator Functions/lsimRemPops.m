function [populations,activity] = lsimRemPops(rMatrix)
%lsimRemPops REM simulator define populations and activity
%   [A, B] = lsimRemPops(X) returns all non-void trinary patterns of 
%   n_stim bits to A and activity in each population to B where n_stim is 
%   the number of columns in the r value matrix X

%Create Populations
n_stim = size(rMatrix, 2); %number of stimuli
n_pats=3^(n_stim-1); %number of populations within each stimulus representation
populations=zeros(n_pats,n_stim+1,n_stim); %extra column later used for sorting
popsize=zeros(n_pats,n_stim);
activity=zeros(n_pats,n_stim);

for x=1:n_stim %this might not be the most readable or elegant code, but it works
    count=0;
    for y=1:n_pats
        populations(y,x,x)=1;
    end
    for z=1:n_stim
        if (x~=z)
            count=count+1;
            for y=1:3^(count-1)
                for v=1:3
                    for w=1:3^((n_stim-1)-count)
                        populations(w+((v-1)*3^((n_stim-1)-count))+((y-1)*3*3^((n_stim-1)-count)),z,x)=(2-v);
                    end
                end
            end
        end
    end
end
for x=1:n_stim %calculate how many stimuli contribute to populations
    populations(:,n_stim+1,x)=sum(abs(populations(:,:,x)),2);
end
for x=1:n_stim %sort array, replicate tally column and then remove it from main array
    populations(:,:,x)=sortrows(populations(:, :, x),(n_stim+1));
    popsize(:,x)=populations(:, n_stim+1, x);
end
populations(:,n_stim+1,:)=[];

%Create activity matrix
comparison=ones(n_stim,n_stim);
for x=1:n_stim
    for y=1:n_stim
        if (x==y)
            comparison(x,y)=0;
        end
    end
end

for q=1:n_stim
    %find paiwise comparisons for each populations of elements
    for p=1:n_pats
        pattern=abs(populations(p,:,q));
        thiscomp=zeros(n_stim,n_stim);
        if (popsize(p,q)>1)
            for x=1:n_stim-1
                if (pattern(x)==1)
                    for z=x+1:n_stim
                        if (pattern(z)==1)
                            thiscomp(x,z)=1;
                        end
                    end
                end
            end
        end
        
        %and calculate activity based on these comparisons
        thiscomp=thiscomp+thiscomp.';
        diff=comparison-thiscomp;
        increment=1;
        for a=1:n_stim
            increment=increment*(rMatrix(a,q)^thiscomp(a,q))*((1-rMatrix(a,q))^diff(a,q));
        end
        activity(p,q)=increment;
    end
end                 