/* 
  Copyright 2021
  @Author Christopher Mølbeck Sørensen

  You may not use this file except in compliance with the License.
  Unless required by applicable law or agreed to in writing, software distributed under the License 
  is distrubuted on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*/

import serialization

/* 
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

/*
  A custom serializer, serializing a GpioTriggerMessage into a Map, and the other way around.
  Useful as ubjson is not supporting serialization of custom objects (yet), but it supports Maps
*/
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
  deserialize_map map/Map -> GpioTriggerMessage:
    return GpioTriggerMessage.from_map map
  
  deserialize_bytearray bytearray /ByteArray -> GpioTriggerMessage:
    deserialized := serialization.deserialize bytearray
    if not deserialized is Map : throw "ARGUMENT ERROR"
    if not GpioTriggerMessage.is_map_valid deserialized : throw "ARGUMENT ERROR"
    return GpioTriggerMessage.from_map deserialized
