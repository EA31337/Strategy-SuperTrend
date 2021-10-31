/**
 * @file
 * Implements SuperTrend strategy based on the SuperTrend indicator.
 */

// Includes.
#include "Indi_SuperTrend.mqh"

// User input params.
INPUT_GROUP("SuperTrend strategy: strategy params");
INPUT float SuperTrend_LotSize = 0;                // Lot size
INPUT int SuperTrend_SignalOpenMethod = 0;         // Signal open method
INPUT float SuperTrend_SignalOpenLevel = 0;        // Signal open level
INPUT int SuperTrend_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int SuperTrend_SignalOpenFilterTime = 3;     // Signal open filter time (0-31)
INPUT int SuperTrend_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int SuperTrend_SignalCloseMethod = 0;        // Signal close method
INPUT int SuperTrend_SignalCloseFilter = 32;       // Signal close filter (-127-127)
INPUT float SuperTrend_SignalCloseLevel = 0;       // Signal close level
INPUT int SuperTrend_PriceStopMethod = 0;          // Price limit method
INPUT float SuperTrend_PriceStopLevel = 2;         // Price limit level
INPUT int SuperTrend_TickFilterMethod = 32;        // Tick filter method (0-255)
INPUT float SuperTrend_MaxSpread = 4.0;            // Max spread to trade (in pips)
INPUT short SuperTrend_Shift = 0;                  // Shift
INPUT float SuperTrend_OrderCloseLoss = 80;        // Order close loss
INPUT float SuperTrend_OrderCloseProfit = 80;      // Order close profit
INPUT int SuperTrend_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("SuperTrend strategy: SuperTrend indicator params");
INPUT uint SuperTrend_Indi_SuperTrend_InpPeriod = 14;                                  // Period
INPUT uint SuperTrend_Indi_SuperTrend_InpShift = 20;                                   // Shift
INPUT bool SuperTrend_Indi_SuperTrend_InpUseFilter = true;                             // Use filter
INPUT int SuperTrend_Indi_SuperTrend_Shift = 0;                                        // Shift
INPUT ENUM_IDATA_SOURCE_TYPE SuperTrend_Indi_SuperTrend_SourceType = IDATA_INDICATOR;  // Source type

// Structs.

// Defines struct with default user strategy values.
struct Stg_SuperTrend_Params_Defaults : StgParams {
  Stg_SuperTrend_Params_Defaults()
      : StgParams(::SuperTrend_SignalOpenMethod, ::SuperTrend_SignalOpenFilterMethod, ::SuperTrend_SignalOpenLevel,
                  ::SuperTrend_SignalOpenBoostMethod, ::SuperTrend_SignalCloseMethod, ::SuperTrend_SignalCloseFilter,
                  ::SuperTrend_SignalCloseLevel, ::SuperTrend_PriceStopMethod, ::SuperTrend_PriceStopLevel,
                  ::SuperTrend_TickFilterMethod, ::SuperTrend_MaxSpread, ::SuperTrend_Shift) {
    Set(STRAT_PARAM_LS, SuperTrend_LotSize);
    Set(STRAT_PARAM_OCL, SuperTrend_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, SuperTrend_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, SuperTrend_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, SuperTrend_SignalOpenFilterTime);
  }
};

#ifdef __config__
// Loads pair specific param values.
#include "config/H1.h"
#include "config/H4.h"
#include "config/H8.h"
#include "config/M1.h"
#include "config/M15.h"
#include "config/M30.h"
#include "config/M5.h"
#endif

class Stg_SuperTrend : public Strategy {
 public:
  Stg_SuperTrend(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_SuperTrend *Init(ENUM_TIMEFRAMES _tf = NULL) {
    // Initialize strategy initial values.
    Stg_SuperTrend_Params_Defaults stg_supertrend_defaults;
    StgParams _stg_params(stg_supertrend_defaults);
#ifdef __config__
    SetParamsByTf<StgParams>(_stg_params, _tf, stg_supertrend_m1, stg_supertrend_m5, stg_supertrend_m15,
                             stg_supertrend_m30, stg_supertrend_h1, stg_supertrend_h4, stg_supertrend_h8);
#endif
    // Initialize indicator.
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_SuperTrend(_stg_params, _tparams, _cparams, "SuperTrend");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    IndiSuperTrendParams _indi_params(::SuperTrend_Indi_SuperTrend_InpPeriod, ::SuperTrend_Indi_SuperTrend_InpShift,
                                      ::SuperTrend_Indi_SuperTrend_InpUseFilter, ::SuperTrend_Indi_SuperTrend_Shift,
                                      PERIOD_CURRENT, ::SuperTrend_Indi_SuperTrend_SourceType);
    _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
    SetIndicator(new Indi_SuperTrend(_indi_params));
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method, float _level = 0.0f, int _shift = 0) {
    Indi_SuperTrend *_indi = GetIndicator();
    bool _result =
        _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) && _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    IndicatorSignal _signals = _indi.GetSignals(4, _shift);
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Buy signal.
        _result &= _indi.IsIncreasing(1, 0, _shift);
        _result &= _indi.IsIncByPct(_level / 10, 0, _shift, 2);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
      case ORDER_TYPE_SELL:
        // Sell signal.
        _result &= _indi.IsDecreasing(1, 0, _shift);
        _result &= _indi.IsDecByPct(_level / 10, 0, _shift, 2);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
    }
    return _result;
  }
};
