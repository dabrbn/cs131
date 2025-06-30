Task 1 sed:
(1) Collect lines with "2.0" as vendor i.d. in vendors.csv.
\
Output of `wc -l vendors.csv`: 4633794 vendors.csv

(2) Remove all colons (:), double quotes ("), and hyphens (-) from the original data file and save it in no-separators.csv.
\
Output of `head -10 no-separators.csv`:
vendorid,tpep_pickup_datetime,tpep_dropoff_datetime,passenger_count,trip_distance,ratecodeid,store_and_fwd_flag,pulocationid,dolocationid,payment_type,fare_amount,extra,mta_tax,tip_amount,tolls_amount,improvement_surcharge,total_amount,congestion_surcharge
1.0,20190401 000409.000000,20190401 000635.000000,1.0,0.5,1.0,N,239.0,239.0,1.0,4.0,3.0,0.5,1.0,0.0,0.3,8.8,2.5
1.0,20190401 002245.000000,20190401 002543.000000,1.0,0.7,1.0,N,230.0,100.0,2.0,4.5,3.0,0.5,0.0,0.0,0.3,8.3,2.5
1.0,20190401 003948.000000,20190401 011939.000000,1.0,10.9,1.0,N,68.0,127.0,1.0,36.0,3.0,0.5,7.95,0.0,0.3,47.75,2.5
1.0,20190401 003532.000000,20190401 003711.000000,1.0,0.2,1.0,N,68.0,68.0,2.0,3.5,3.0,0.5,0.0,0.0,0.3,7.3,2.5
1.0,20190401 004405.000000,20190401 005758.000000,1.0,4.8,1.0,N,50.0,42.0,1.0,15.5,3.0,0.5,3.85,0.0,0.3,23.15,2.5
1.0,20190401 002916.000000,20190401 003800.000000,1.0,1.7,1.0,N,95.0,196.0,2.0,8.5,0.5,0.5,0.0,0.0,0.3,9.8,0.0
1.0,20190401 000647.000000,20190401 000815.000000,1.0,0.0,1.0,N,211.0,211.0,3.0,3.0,3.0,0.5,0.0,0.0,0.3,6.8,2.5
1.0,20190401 005216.000000,20190401 005510.000000,1.0,0.2,1.0,N,237.0,162.0,1.0,4.0,3.0,0.5,0.0,0.0,0.3,7.8,2.5
2.0,20190401 005228.000000,20190401 011124.000000,1.0,4.15,1.0,N,148.0,37.0,2.0,16.5,0.5,0.5,0.0,0.0,0.3,20.3,2.5

(3) Remove all fractional parts from the no-separators.csv and save it as no-fractions.csv.
\
Output of `head -10 no-fractions.csv`:
vendorid,tpep_pickup_datetime,tpep_dropoff_datetime,passenger_count,trip_distance,ratecodeid,store_and_fwd_flag,pulocationid,dolocationid,payment_type,fare_amount,extra,mta_tax,tip_amount,tolls_amount,improvement_surcharge,total_amount,congestion_surcharge
1,20190401 000409,20190401 000635,1,0,1,N,239,239,1,4,3,0,1,0,0,8,2
1,20190401 002245,20190401 002543,1,0,1,N,230,100,2,4,3,0,0,0,0,8,2
1,20190401 003948,20190401 011939,1,10,1,N,68,127,1,36,3,0,7,0,0,47,2
1,20190401 003532,20190401 003711,1,0,1,N,68,68,2,3,3,0,0,0,0,7,2
1,20190401 004405,20190401 005758,1,4,1,N,50,42,1,15,3,0,3,0,0,23,2
1,20190401 002916,20190401 003800,1,1,1,N,95,196,2,8,0,0,0,0,0,9,0
1,20190401 000647,20190401 000815,1,0,1,N,211,211,3,3,3,0,0,0,0,6,2
1,20190401 005216,20190401 005510,1,0,1,N,237,162,1,4,3,0,0,0,0,7,2
2,20190401 005228,20190401 011124,1,4,1,N,148,37,2,16,0,0,0,0,0,20,2

Task 2 awk:
(1) 
