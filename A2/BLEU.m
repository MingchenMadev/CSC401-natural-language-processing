function score = BLEU(original, ref1, ref2, order)
    original = strsplit(' ', original );
    ref1 = strsplit(' ', ref1 );
    ref2 = strsplit(' ', ref2 );
    c = length(original);
    l1 = length(ref1);
    l2 = length(ref2);
    ref1abs = abs(c-l1);
    ref2abs = abs(l2-c);
    if (ref1abs < ref2abs)
        r = l1;
    else
        r = l2;
    end
    if (r < c)
        bpc = 1;
    else
        bpc = exp(1-double(r)/double(c));
    end
    pprod = 1;
    for o=1:order
        pd = c-o+1;
        pu = 0;
        for i=1:pd
           ml = {};
           for j=1:o
               ml = [ml, original{i+j-1}];
           end
           ret1 = findstr(cell2mat(ref1), cell2mat(ml));
           ret2 = findstr(cell2mat(ref2), cell2mat(ml));
           if (~isempty(ret1) || ~isempty(ret2))
               pu = pu + 1;
           end
        end
        p = double(pu) / double(pd);
        pprod = pprod * p;
    end
    score = bpc * pprod.^(1/double(order));
               
end