initial begin
    
    mcd = $fopen("results.txt") | 1;
    vi1 = 'h2;
    vi2 = 'h3;
    vb5 = 'h4;
    CTask(mcd, 1, vi1, vi2, vo3, vo4, vb5);
    $fdisplay(mcd, "%4d: vi1=%4x vi2=%4x vo3=%4x vo4=%4x vb5=%4x",
        $time, vi1, vi2, vo3, vo4, vb5); 
    #5;

    vi1 = vo3;
    vi2 = vo4;
    CTask(mcd, 1, vi1, vi2, vo3, vo4, vb5);
    $fdisplay(mcd, "%4d: vi1=%4x vi2=%4x vo3=%4x vo4=%4x vb5=%4x",
        $time, vi1, vi2, vo3, vo4, vb5); 
    #5;

    vi1 = vo3;
    vi2 = vo4;
    CTask(mcd, 1, vi1, vi2, vo3, vo4, vb5);
    $fdisplay(mcd, "%4d: vi1=%4x vi2=%4x vo3=%4x vo4=%4x vb5=%4x",
        $time, vi1, vi2, vo3, vo4, vb5); 
    #5;

    vi1 = vo3;
    vi2 = vo4;
    CTask(mcd, 1, vi1, vi2, vo3, vo4, vb5);
    $fdisplay(mcd, "%4d: vi1=%4x vi2=%4x vo3=%4x vo4=%4x vb5=%4x",
        $time, vi1, vi2, vo3, vo4, vb5); 
    #5;
    $fclose(mcd);
end
