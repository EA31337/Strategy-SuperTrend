/*
 * @file
 * Defines default strategy parameter values for the given timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct IndiSuperTrendParams_M15 : IndiSuperTrendParams {
  IndiSuperTrendParams_M15() : IndiSuperTrendParams(indi_supertrend_defaults, PERIOD_M15) { shift = 0; }
} indi_supertrend_m15;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_SuperTrend_Params_M15 : StgParams {
  // Struct constructor.
  Stg_SuperTrend_Params_M15() : StgParams(stg_supertrend_defaults) {}
} stg_supertrend_m15;
