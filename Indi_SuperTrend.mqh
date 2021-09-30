//+------------------------------------------------------------------+
//|                                      Copyright 2016-2021, EA31337 Ltd |
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

// Structs.

// Defines struct to store indicator parameter values.
struct IndiSuperTrendParams : public IndicatorParams {
  // Indicator params.
  uint InpPeriod;     // Period
  uint InpShift;      // Shift
  bool InpUseFilter;  // Use filter
  // Struct constructors.
  IndiSuperTrendParams(uint _period = 14, uint _inp_shift = 20, bool _use_filter = 1, int _shift = 0)
      : InpPeriod(_period), InpShift(_inp_shift), InpUseFilter(_use_filter) {
    max_modes = FINAL_SUPERTREND_MODE_ENTRY;
#ifdef __resource__
    custom_indi_name = "::Indicators\\SuperTrend";
#else
    custom_indi_name = "SuperTrend";
#endif
    SetDataSourceType(IDATA_ICUSTOM);
    SetDataValueType(TYPE_DOUBLE);
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
class Indi_SuperTrend : public Indicator {
 public:
  // Structs.
  IndiSuperTrendParams params;

  /**
   * Class constructor.
   */
  Indi_SuperTrend(IndiSuperTrendParams &_p) : Indicator((IndicatorParams)_p) {}

  /**
   * Returns the indicator's value.
   *
   */
  double GetValue(ENUM_SUPERTREND_MODE _mode, int _shift = 0) {
    ResetLastError();
    double _value = EMPTY_VALUE;
    switch (params.idstype) {
      case IDATA_ICUSTOM:
        _value = iCustom(istate.handle, Get<string>(CHART_PARAM_SYMBOL), Get<ENUM_TIMEFRAMES>(CHART_PARAM_TF),
                         params.custom_indi_name, params.GetInpPeriod(), params.GetInpShift(), params.GetInpUseFilter(),
                         _mode, _shift);
        break;
      default:
        SetUserError(ERR_USER_NOT_SUPPORTED);
        _value = EMPTY_VALUE;
    }
    istate.is_changed = false;
    istate.is_ready = _LastError == ERR_NO_ERROR;
    return _value;
  }

  /**
   * Returns the indicator's struct value.
   */
  IndicatorDataEntry GetEntry(int _shift = 0) {
    long _bar_time = GetBarTime(_shift);
    unsigned int _position;
    IndicatorDataEntry _entry(params.max_modes);
    if (idata.KeyExists(_bar_time, _position)) {
      _entry = idata.GetByPos(_position);
    } else {
      _entry.timestamp = GetBarTime(_shift);
      for (ENUM_SUPERTREND_MODE _mode = 0; _mode < FINAL_SUPERTREND_MODE_ENTRY; _mode++) {
        _entry.values[_mode] = GetValue(_mode, _shift);
      }
      _entry.SetFlag(
          INDI_ENTRY_FLAG_IS_VALID,
          _entry.GetMin<double>() > 0 && _entry.values[SUPERTREND_UPPER].IsGt<double>(_entry[(int)SUPERTREND_LOWER]));
      if (_entry.IsValid()) {
        idata.Add(_entry, _bar_time);
      }
    }
    return _entry;
  }
};

#endif  // INDI_SUPERTREND_MQH
