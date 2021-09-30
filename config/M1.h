/*
 * @file
 * Defines default strategy parameter values for the given timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct Indi_Demo_Params_M1 : DemoIndiParams {
  Indi_Demo_Params_M1() : DemoIndiParams(indi_demo_defaults, PERIOD_M1) { shift = 0; }
} indi_demo_m1;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_Demo_Params_M1 : StgParams {
  // Struct constructor.
  Stg_Demo_Params_M1() : StgParams(stg_demo_defaults) {}
} stg_demo_m1;
