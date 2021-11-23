import serialization

/**
Small class containing properties regarding setting a specific value for a specific GPIO pin.
If the property resetTime is set to anything else than null, the original value should be changed
  back after the reset time has been hit.
*/
class GpioTriggerMessage:
  pin /string // Which pin this should invoke.
  value /int  // What value the pin should have.
  reset_time /int? // Time before the pin should be reset to originial value. Null if never.

  constructor .pin .value --.reset_time/int?=null:

  constructor.from_map map/Map:
    if not is_map_valid map: throw "ARGUMENT ERROR"
    return GpioTriggerMessage map["pin"] map["value"] --reset_time=(map.get "resetTime")

  /// Whether the given $map contains the key-value pairs to construct a $GpioTriggerMessage.
  static is_map_valid map/Map -> bool:
    return map.contains "pin" and map.contains "value"

class GpioTriggerMessageSerializer:

  /// Serializes the given $message.
  serialize message/GpioTriggerMessage -> Map:
    result := {
      "pin": message.pin,
      "value": message.value,
    }

    if message.reset_time: result["resetTime"] = message.reset_time

    return result

  /// Deserializes the given $map to a $GpioTriggerMessage.
  deserialize map/Map -> GpioTriggerMessage:
    return GpioTriggerMessage.from_map map
