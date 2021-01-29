function respect = respect_constraints(a, b, constraints)

    next = setdiff(b,a);
    
    % controllo i constraints x->valore
    if ismember(next,constraints(:,2))
        indexes = find(constraints(:,2) == next);
        counter = 0;
        for i = 1:length(indexes)
            previous = constraints(indexes(i),1);
            if ismember(previous,a)
                counter = counter +1;
            end
        end
        if(counter == length(indexes))
            respect = 1;
        else
            respect = 0;
        end
    else 
        respect = 1;
    end
    
    % controllo i constraints x->valore
    if respect == 1 && ismember(next,constraints(:,1))
        indexes = find(constraints(:,1) == next);
        counter = 0;
        for i = 1:length(indexes)
            next_next=constraints(indexes(i),2);
            if ~ismember(next_next,a)
                counter = counter +1;
            end
        end
        if(counter == length(indexes))
            respect = 1;
        else
            respect = 0;
        end
    else 
        respect = 1;
    end
    
end