% Calculate F ratio of global fitting versus separate fitting

% global fit 
combined = [Neg2.lt_freq_dist; Kif18B.lt_freq_dist];
tbl_temp= tabulate( combined );
tbl = tbl_temp( 4:2:60, : ); 
clear tbl_temp;
lt_bin = tbl(:,1);
lt_freq_dist = tbl(:,3);