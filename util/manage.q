// The purpose of the functions within this script is to 'manage' data that is intended for use
// within a machine learning application. The functionality in questions is a mixture of
// new functions and the wrapping of existing functions within the ml toolkit
// in particular the preprocessing functionality which is heavily pointed to and referenced here

\d .ml

// Check a users data for potential pitfalls that may exist when applying machine learning
// techniques to their dataset
/* t   = simple table containing the data being processed by the ML algorithm
/* tgt = target vector you are intending to use
/* typ = type of machine learning problem that is being approached (nlp/normal/fresh)
/* ptyp
/* p   = if applying this function to fresh/time-series further information may be required
/. r   > table highlighting if a particular aspect of the data is likely to be a problem

datacheck:{[t;tgt;typ;ptype;p]
  if[98h<>type t;'"This check is only valid for tabular training data"];
  schema:([]check:();pass:();msg:());
  tab:tab.null[t;schema];
  tab:tab.infinity[t;tab];
  tab:tab.schema[t;typ;p;tab];
  if[typ~`time;tab:tab.equispace[t;p;tab]];
  if[not tgt~(::);
    tab:tgt.len[t;tgt;typ;p;tab];
    tab:tgt.null[tgt;tab];
    tab:tgt.distinct[tgt;tab];
    tab:tgt.infinity[tgt;tab];
    tab:tgt.unique[tgt;ptype;tab];
    if[ptype~`class;tab:tgt.imbalance[tgt;tab]];
    ];
  tab
  }

// Ensure that the cadence of the 'time' column of a table is equispaced.
// This is a requirement for many of the models a user may want to apply time series specific
// algorithms to particularly noting Arima models
// **Note:** the dictionary p must contain a key `time_col which is a single column denoting the time
tab.equispace:{[t;p;schema]
  tcol:t p`time_col;
  if[1<>count p`time_col;'"Inappropriate number of time columns provided, 1 time column accepted"];
  chk:$[1<count distinct 1_deltas tcol;"Time column is not equispaced";"ok"];
  schema upsert enlist("Time spacing";chk~"ok";chk)
  }

// Flag to the user if the number of unique classes within the dataset is abnormally high/low
// this may indicate that the target variable isn't suitable for a classification problem or
// regression problem respectively
tgt.unique:{[tgt;ptype;schema]
  peruni:count[distinct tgt]%count tgt;
  chk:$[ptype~`class;
    $[peruni>0.5;">50% of the targets for your classification problem are unique";"ok"];
    $[peruni<0.5;"<50% of the targets for your regression problem are unique";"ok"]];
  schema upsert enlist("Unique classes";chk~"ok";chk)
  }

// Calculation of Shannon entropy to test data imbalance
tgt.imbalance:{[tgt;schema]
  log_k:log count group tgt;
  tgt_len:(count each group tgt)%count tgt;
  shannon:(neg[1]*sum tgt_len*log tgt_len)%log_k;
  chk:$[shannon<0.2;
        "Your target has a Shannon entropy < 0.2, indicating it may be imbalanced";
        "ok"];
  schema upsert enlist("Target Imbalance";chk~"ok";chk)
  }

// Test to check that columns contained in the dataset are typed correctly
tab.schema:{[t;typ;p;schema]
  // List type columns can't be handled
  lst_typ:upper .Q.t;
  // Add or remove additional column types as appropriate
  exc_lst:$[typ in `tseries`normal;
             lst_typ,"xgcs";
           typ=`fresh;
             lst_typ,"xgpmdznuvtcs";
           typ=`nlp;
             (lst_typ,"xgs")except "C";
           typ=`time;
             lst_typ,"xgcs";
           '"Input for typ must be a supported symbol"];
  if[typ=`fresh;t:flip p[`aggcols]_ flip t];
  bad_cols:i.fndcols[t;exc_lst];
  count_bad:count bad_cols;
  where_bad:$[0=count_bad;::;1=count_bad;string ::;", "sv string ::]bad_cols;
  chk:$[0<count bad_cols;
        "The following columns may not be suitable for your use case: ",/where_bad;
        "ok"];
  schema upsert enlist("Data Schema check";chk~"ok";chk)
  }

// Test to check if the target vector contains any infinities
tgt.infinity:{[tgt;schema]
  any_inf:(any/)(-0w;0w;-0W;0W)~'\:tgt;
  chk:$[any_inf;"The target vector contains infinities.";"ok"];
  schema upsert enlist("Target Infinities";chk~"ok";chk)
  }

// Test to check if there are any infinities in the table
tab.infinity:{[t;schema]
  any_inf:(any/)(-0w;0w;-0W;0W)~'/:\:value flip t;
  chk:$[any_inf;"The table contains infinities, these may not be handled by some ML models";"ok"];
  schema upsert enlist("Table Infinities";chk~"ok";chk)
  }

// Test to check if there are any null values in the table
tab.null:{[t;schema]
  where_null:where(any'/)null t;
  count_null:count where_null;
  null_cols:$[1=count_null;string ::;", "sv string ::]where_null;
  chk:$[0<count_null;
    "The following columns contain nulls: ",/null_cols;
    "ok"];
  schema upsert enlist("Table nulls";chk~"ok";chk)
  }

// Test to ensure that the number of target values coincides with the number of columns/fresh ids
tgt.len:{[t;tgt;typ;p;schema]
  chk:$[-11h=type typ;
    $[typ=`fresh;
        $[count[tgt]<>count distinct $[1=count p`aggcols;t[p`aggcols];(,'/)t p`aggcols];
          "Target count must equal count of unique agg values for fresh";"ok"];
      typ in`normal`nlp`time;
        $[count[tgt]<>count t;
          "The number of targets must equal the number of values in the table";"ok"];
       '"Input for typ must be a supported type"];
    '"Input for typ must be a supported symbol"];
  schema upsert enlist("Target Length";chk~"ok";chk)
  }

// Test to check if there are any null values within the target vector
tgt.null:{[tgt;schema]
  chk:$[any null tgt;"Target contains null data";"ok"];
  schema upsert enlist("Null targets";chk~"ok";chk)
  }

// Test to ensure that more than one target is being supplied, only one target provides no information
tgt.distinct:{[tgt;schema]
  chk:$[1=count distinct tgt;
        "Only one distinct target, nothing to learn";
        "ok"];
  schema upsert enlist("Distinct targets";chk~"ok";chk)
  }

