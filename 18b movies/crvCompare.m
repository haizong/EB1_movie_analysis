%%  Compare K from exponential Fit using sum squared of error
tbl_temp= tabulate( [ Neg2_total_sta.lifetime.lt_total; Kif18B_total_sta.lifetime.lt_total] );
tbl = tbl_temp( 4:2:52, : );
clear tbl_temp;
Global_compare.lifetime.lt_bin = tbl(:,1);
Global_compare.lifetime.lt_freq_dist = tbl(:,3);
[Global_compare.lifetime.lt_fitresult, Global_compare.lifetime.lt_gof] = ...
    createExpFit( Global_compare.lifetime.lt_bin, Global_compare.lifetime.lt_freq_dist, 'Global' );

residual_Neg2 = []; 
for i = 1:length( Global_compare.lifetime.lt_bin  )
    residual_Neg2(i) = Global_compare.lifetime.lt_gof.Y0 * exp (-Global_compare.lifetime.lt_gof.K * Global_compare.lifetime.lt_bin(i))...
        - Neg2_total_sta.lifetime.lt_freq_dist(i);
    
    residual_Kif18B(i) = Global_compare.lifetime.lt_gof.Y0 * exp (-Global_compare.lifetime.lt_gof.K * Global_compare.lifetime.lt_bin(i))...
        - Kif18B_total_sta.lifetime.lt_freq_dist(i);
end 

ss_separate = Neg2_total_sta.lifetime.lt_gof.sse + Kif18B_total_sta.lifetime.lt_gof.sse; 
ss_global = sum (residual_Neg2.^2) + sum (residual_Kif18B.^2); 
df_separate = Neg2_total_sta.lifetime.lt_gof.dfe + Kif18B_total_sta.lifetime.lt_gof.dfe;
df_global = length( Neg2_total_sta.lifetime.lt_freq_dist ) + length( Kif18B_total_sta.lifetime.lt_freq_dist ) -2 -1; 


% close all;