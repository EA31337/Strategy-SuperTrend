//+------------------------------------------------------------------+
//|                                      Copyright 2016-2023, EA31337 Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/*
 * This file is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

// Prevents processing the same indicator file twice.
#ifndef INDI_SUPERTREND_MQH
#define INDI_SUPERTREND_MQH

// Defines
#define INDI_SUPERTREND_PATH "indicators-other\\Price"

// Structs.

// Defines struct to store indicator parameter values.
struct IndiSuperTrendParams : public IndicatorParams {
  // Indicator params.
  uint InpPeriod;     // Period
  uint InpShift;      // Shift
  bool InpUseFilter;  // Use filter
  // Struct constructors.
  IndiSuperTrendParams(uint _period = 14, uint _inp_shift = 20, bool _use_filter = 1, int _shift = 0,
                       ENUM_TIMEFRAMES _tf = PERIOD_CURRENT, ENUM_IDATA_SOURCE_TYPE _idstype = IDATA_BUILTIN)
      : InpPeriod(_period), InpShift(_inp_shift), InpUseFilter(_use_filter) {
#ifdef __resource__
    custom_indi_name = "::" + INDI_SUPERTREND_PATH + "\\SuperTrend";
#else
    custom_indi_name = "SuperTrend";
#endif
  };

  IndiSuperTrendParams(IndiSuperTrendParams &_params, ENUM_TIMEFRAMES _tf) {
    this = _params;
    tf = _tf;
  }
  // Getters.
  uint GetInpPeriod() { return InpPeriod; }
  uint GetInpShift() { return InpShift; }
  uint GetInpUseFilter() { return InpUseFilter; }
  // Setters.
  void SetInpPeriod(uint _period) { InpPeriod = _period; }
  void SetInpShift(uint _inp_shift) { InpShift = _inp_shift; }
  void SetInpUseFilter(uint _use_filter) { InpUseFilter = _use_filter; }
};

/**
 * Implements indicator class.
 */
class Indi_SuperTrend : public Indicator<IndiSuperTrendParams> {
 public:
  /**
   * Class constructor.
   */
  Indi_SuperTrend(IndiSuperTrendParams &_p, ENUM_IDATA_SOURCE_TYPE _idstype = IDATA_ICUSTOM,
                  IndicatorBase *_indi_src = NULL, int _indi_src_mode = 0)
      : Indicator<IndiSuperTrendParams>(
            _p, IndicatorDataParams::GetInstance(2, TYPE_DOUBLE, _idstype, IDATA_RANGE_MIXED, _indi_src_mode),
            _indi_src) {}
  Indi_SuperTrend(ENUM_TIMEFRAMES _tf = PERIOD_CURRENT) : Indicator(INDI_TMA_TRUE, _tf){};

  /**
   * Returns the indicator's value.
   */
  IndicatorDataEntryValue GetEntryValue(int _mode, int _shift = -1) {
    double _value = EMPTY_VALUE;
    int _ishift = _shift >= 0 ? _shift : iparams.GetShift();
    switch (Get<ENUM_IDATA_SOURCE_TYPE>(STRUCT_ENUM(IndicatorDataParams, IDATA_PARAM_IDSTYPE))) {
      case IDATA_ICUSTOM:
        _value = iCustom(istate.handle, GetSymbol(), GetTf(), iparams.custom_indi_name, iparams.GetInpPeriod(),
                         iparams.GetInpShift(), iparams.GetInpUseFilter(), _mode, _shift);
        break;
      default:
        SetUserError(ERR_USER_NOT_SUPPORTED);
        break;
    }
    return _value;
  }
};

#endif  // INDI_SUPERTREND_MQH
