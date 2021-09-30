/*
 * @file
 * Defines default strategy parameter values for the given timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct IndiSuperTrendParams_H8 : IndiSuperTrendParams {
  IndiSuperTrendParams_H8() : IndiSuperTrendParams(indi_supertrend_defaults, PERIOD_H8) { shift = 0; }
} indi_supertrend_h8;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_SuperTrend_Params_H8 : StgParams {
  // Struct constructor.
  Stg_SuperTrend_Params_H8() : StgParams(stg_supertrend_defaults) {}
} stg_supertrend_h8;
