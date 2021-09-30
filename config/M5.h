/*
 * @file
 * Defines default strategy parameter values for the given timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct IndiSuperTrendParams_M5 : IndiSuperTrendParams {
  IndiSuperTrendParams_M5() : IndiSuperTrendParams(indi_supertrend_defaults, PERIOD_M5) { shift = 0; }
} indi_supertrend_m5;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_SuperTrend_Params_M5 : StgParams {
  // Struct constructor.
  Stg_SuperTrend_Params_M5() : StgParams(stg_supertrend_defaults) {}
} stg_supertrend_m5;
