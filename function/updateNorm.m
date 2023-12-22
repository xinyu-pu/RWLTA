function [ y ] = updateNorm( x, n, p1, p2 )
    switch(n)
        case '21'
            y = solveNorm21( x, p1 );
        case 'c1'
            y = solveNormCauthy1( x, p1, p2);
        case 't1'
            y = softthresholding(x, p1);
        case 'WNATNN'
            [ y, ~ ] = solveWNATNN( x, p1, p2);
    end
end

