param num_matrices >= 1, integer; # Number of matrices in the data file to be read
param num_rows >= 1, integer;     # Number of rows
param num_cols >= 1, integer;     # Number of columns 

set MATS    := 1 .. num_matrices; # set of matrices
set ROWS    := 1 .. num_rows;	  # set of rows
set COLUMNS := 1 .. num_cols;	  # set of columns

# values for entries of each matrix
param target_value {MATS, ROWS, COLUMNS} >= 0; 
param tumor {ROWS,COLUMNS} >= 0;
param critical {ROWS,COLUMNS} >= 0;

set tumor_area := {m in ROWS, n in COLUMNS: tumor [m,n] > 0};
set critical_area := {m in ROWS, n in COLUMNS: critical [m,n] > 0};

#given lower limit for tumor dosage
param tumor_lower = 10; 

#given upper limit for critical dosage
param critical_upper = 2; 

# intensity multiplier of each beam
var X {i in MATS} >= 0;

#Minimize dosage till the limit
minimize dosage : sum {(m,n) in critical_area} sum {i in MATS} X[i] * target_value [i,m,n]- sum {(m,n) in tumor_area} sum {i in MATS} X[i] * target_value[i,m,n];

#Subject to the following contstraints
s.t. tumor_limit {(m,n) in tumor_area} : sum {i in MATS} X[i] * target_value[i,m,n] >= tumor_lower;
s.t. critical_limit {(m,n) in critical_area} : sum {i in MATS} X[i] * target_value[i,m,n] <= critical_upper;