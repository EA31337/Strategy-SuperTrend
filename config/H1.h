/*
 * @file
 * Defines default strategy parameter values for the given timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct IndiSuperTrendParams_H1 : IndiSuperTrendParams {
  IndiSuperTrendParams_H1() : IndiSuperTrendParams(indi_supertrend_defaults, PERIOD_H1) { shift = 0; }
} indi_supertrend_h1;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_SuperTrend_Params_H1 : StgParams {
  // Struct constructor.
  Stg_SuperTrend_Params_H1() : StgParams(stg_supertrend_defaults) {}
} stg_supertrend_h1;
