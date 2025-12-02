source("dependencies.R")

library(tidyverse)
library(mice)
library(pROC)
library(glmnet)
library(xgboost)

df <- readxl::read_excel("D:\\Mosamatic\\NicoleHildebrand\\PORSCH\\PORSCH_complete.xlsx")

selected_vars <- c(
  "gender_castor_x", 
  "age_surgery_x",
  "lengte", 
  "gewicht", 
  "crp",
  "smra", 
  "muscle_area", 
  "vat_area", 
  "sat_area",
  "vat_ra", 
  "sat_ra",
  "datopn", 
  "datont_castor",
  "ovl",
  "datovl"
)

#------------------------------------------------------------------------------------
# Prepare dataset
#------------------------------------------------------------------------------------
x <- df |>
  select(any_of(selected_vars)) |>
  mutate(
    gender_castor_x = as.integer(gender_castor_x),
    age_surgery_x = as.integer(age_surgery_x),
    lengte = as.integer(lengte),
    gewicht = as.integer(gewicht),
    datopn = as.Date(datopn),
    datont_castor = as.Date(datont_castor),
    hospital_stay = as.integer(datont_castor - datopn),
    ovl = as.integer(ovl),
    datovl = as.Date(datovl),

    ovl_1y = if_else(
      ovl == 1L & !is.na(datovl) & datovl <= datopn + 365,
      1L, 0L, missing=NA_integer_
    )
  ) |>
  rename(
    gender = gender_castor_x,
    age_surgery = age_surgery_x,
    datont = datont_castor
  )

#------------------------------------------------------------------------------------
# Run MICE imputation on "length" and "crp"
#------------------------------------------------------------------------------------
meth <- make.method(x)
meth[c("lengte", "crp")] <- "pmm"
meth[setdiff(names(x), c("lengte", "crp"))] <- ""

pred <- make.predictorMatrix(x)
pred[,] <- 0
pred[c("lengte", "crp"), ] <- 1
pred[c("lengte", "crp"), c("lengte", "crp")] <- 0

imp <- mice(
  x,
  m = 5,
  method = meth,
  predictorMatrix = pred,
  seed = 123
)

x_imp <- complete(imp, 1)

#------------------------------------------------------------------------------------
# Run baseline logistic regression to predict "ovl_1y"
#------------------------------------------------------------------------------------
data_model <- x_imp |>
  select(-datovl, -ovl, -datopn, -datont) |>
  drop_na()

set.seed(123)
n <- nrow(data_model)
idx_train <- sample(seq_len(n), size = floor(0.8 * n))
train_df <- data_model[idx_train, ]
test_df <- data_model[-idx_train, ]

fit_logit <- glm(
  ovl_1y ~ .,
  data = train_df,
  family = binomial()
)

summary(fit_logit)

test_prob <- predict(fit_logit, newdata = test_df, type = "response")
test_pred <- ifelse(test_prob > 0.5, 1, 0)

table(
  truth = test_df$ovl_1y,
  pred  = test_pred
)

roc_obj <- roc(test_df$ovl_1y, test_prob)
auc(roc_obj)

#------------------------------------------------------------------------------------
# Run regularized logistic regression to predict "ovl_1y"
#------------------------------------------------------------------------------------
x_train <- model.matrix(ovl_1y ~ ., data = train_df)[, -1]
y_train <- train_df$ovl_1y
x_test  <- model.matrix(ovl_1y ~ ., data = test_df)[, -1]
y_test  <- test_df$ovl_1y

set.seed(123)
cvfit <- cv.glmnet(
  x_train, y_train,
  family = "binomial",
  alpha  = 1,       # 1 = lasso, 0 = ridge, in-between = elastic net
  nfolds = 10
)

cvfit$lambda.min      # lambda with min CV error
cvfit$lambda.1se

prob_test <- predict(cvfit, newx = x_test, s = "lambda.min", type = "response")

roc_obj <- roc(y_test, as.numeric(prob_test))
auc(roc_obj)

pred_class <- ifelse(prob_test > 0.5, 1, 0)

table(
  truth = y_test,
  pred  = pred_class
)

#------------------------------------------------------------------------------------
# Run XGBoost to predict "ovl_1y"
#------------------------------------------------------------------------------------
X_train <- train_df |>
  select(-ovl_1y) |>
  as.matrix()

y_train <- train_df$ovl_1y

X_test <- test_df |>
  select(-ovl_1y) |>
  as.matrix()

y_test <- test_df$ovl_1y

dtrain <- xgb.DMatrix(data = X_train, label = y_train)
dtest  <- xgb.DMatrix(data = X_test,  label = y_test)

params <- list(
  objective        = "binary:logistic",
  eval_metric      = "auc",
  max_depth        = 3,
  eta              = 0.1,
  subsample        = 0.8,
  colsample_bytree = 0.8
)

set.seed(123)
bst <- xgb.train(
  params  = params,
  data    = dtrain,
  nrounds = 500,
  watchlist = list(train = dtrain, test = dtest),
  early_stopping_rounds = 30,
  verbose = 1
)

pred_prob <- predict(bst, dtest)
roc_obj <- roc(y_test, pred_prob)
auc(roc_obj)

pred_class <- ifelse(pred_prob > 0.5, 1, 0)

table(
  truth = y_test,
  pred  = pred_class
)