/*
 * @file
 * Defines default strategy parameter values for the given timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct IndiSuperTrendParams_M1 : IndiSuperTrendParams {
  IndiSuperTrendParams_M1() : IndiSuperTrendParams(indi_supertrend_defaults, PERIOD_M1) { shift = 0; }
} indi_supertrend_m1;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_SuperTrend_Params_M1 : StgParams {
  // Struct constructor.
  Stg_SuperTrend_Params_M1() : StgParams(stg_supertrend_defaults) {}
} stg_supertrend_m1;
