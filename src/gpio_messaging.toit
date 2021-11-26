/* 
  Copyright 2021
  @Author Christopher Mølbeck Sørensen

  You may not use this file except in compliance with the License.
  Unless required by applicable law or agreed to in writing, software distributed under the License 
  is distrubuted on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*/

import serialization
import encoding.json
import gpio
/* 
  Small class containing properties regarding setting a specific value for a specific GPIO pin.
  If the property resetTime is set to anything else than null, the original value should be changed
  back after the reset time has been hit.
*/
class GpioTriggerMessage:
  pin /int // Which pin this should invoke.
  value /int  // What value the pin should have.
  wait_to_reset_timeout /int? // Time before the pin should be reset to originial value. Null if never.

  constructor .pin .value --.wait_to_reset_timeout/int?=null:

  constructor.from_map map/Map:
    if not is_map_valid map: throw "ARGUMENT ERROR"
    return GpioTriggerMessage map["pin"] map["value"] --wait_to_reset_timeout=(map.get "wait_to_reset_timeout")

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

    if message.wait_to_reset_timeout: 
      result["wait_to_reset_timeout"] = message.wait_to_reset_timeout

    return result

  /// Deserializes the given $map to a $GpioTriggerMessage.
  deserialize_map map/Map -> GpioTriggerMessage:
    return GpioTriggerMessage.from_map map

  deserialize_bytearray bytes/ByteArray -> GpioTriggerMessage:
    deserialized := json.decode bytes
    if deserialized is not Map: throw "ARGUMENT ERROR"
    if not GpioTriggerMessage.is_map_valid deserialized : throw "ARGUMENT ERROR"
    return GpioTriggerMessage.from_map deserialized
  
  deserialize_bytearray_obsolete bytearray /ByteArray -> GpioTriggerMessage:
    deserialized := serialization.deserialize bytearray
    if not deserialized is Map : throw "ARGUMENT ERROR"
    if not GpioTriggerMessage.is_map_valid deserialized : throw "ARGUMENT ERROR"
    return GpioTriggerMessage.from_map deserialized

class gpio_trigger_message_service:

  ///Handles the given GpioTriggerMessage by flipping the pin
  handle_gpio_message message/GpioTriggerMessage:
    pin := gpio.Pin message.pin --output
    original_value := pin.get //Get current value
    pin.set message.value //Set the new value
    print "Pin: $message.pin, value is changed from $original_value to $message.value"
    //If reset time is set, then change the value back to the original value after reset time has run out
    if message.wait_to_reset_timeout != null:
      print "Waiting for $message.wait_to_reset_timeout ms before resetting value"
      sleep --ms = message.wait_to_reset_timeout
      pin.set original_value
      print "Pin: $pin value is changed back from $message.value to $original_value again"
    else:
      print "Value will be rest immidiately, due to lack of \"hold mode\". Will hopefully change over time"

class gpio_message_validator:
  gpio_pins:= [2,4,5,12,13,14,15,16,17,18,19,21,22,23,25,26,27,32,33,34,35,36,39]

  /// Validate the given GpioTriggerMessage.
  is_valid input / GpioTriggerMessage -> bool:
    if input.value > 1:
      throw "Pin value is higher than 1 (high). Given value: $input.value"
    if input.value < 0:
      throw "Pin value is lower than 0 (low). Given value: $input.value"
    if not gpio_pins.contains input.pin:
      throw "The given pin is not a known GPIO. Given pin: $input.pin. Known GPIO's: $gpio_pins.to_string"
    if input.wait_to_reset_timeout != null and input.wait_to_reset_timeout < 0:
      throw "The given reset timeout has to be positive. Given value: $input.wait_to_reset_timeout"
    return true