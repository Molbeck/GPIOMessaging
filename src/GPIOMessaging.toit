import serialization

///Small class containing properties regarding setting a specific value for a specific GPIO pin.
///If the property resetTime is set to anything else than null, the original value should be changed back after the reset time has been hit.
class GPIOTriggerMessage:
  constructor.initAll .pin .value .resetTime:
  constructor .pin .value:
  pin /string //Which pin this should invoke
  value /int //What value the pin should have
  resetTime /int? := null   //Time before the pin should be reset to originial value. Null if never

///Validator for GPIOInvokeMessage. Ensures that the received message can be processed 
class GPIOTriggerMessageValidator:

  //Validates the given GPIOTriggerMessage.
  //True if required properties are correct set, false otherwise
  static IsObjectValid --input /GPIOTriggerMessage ->bool:
    if input == null:
      print "Input is null"
      return false
    if input.pin == null:
      print "Pin is null"
      return false
    if input.value == null:
      print "Value is null"
      return false
    return true

  ///Validates if the given map contains the key-value pairs to construct a GPIOTriggerMessage.
  ///True if it has, false otherwise
  static IsMapValid --input /Map -> bool:
    if input == null:
      return false
    if input.is_empty:
      return false
    contains := input.contains "pin" 
    if contains == false:   
      return false
    contains = input.contains "pin" 
    if contains == false:   
      return false
    return true

class GPIOTriggerMessageSerializer:

  ///Serializes the given GPIOTriggerMessage to a Map
  Serialize --input / GPIOTriggerMessage -> Map?:
    test := input is GPIOTriggerMessage
    //Return null if the given input is invalid
    validation := GPIOTriggerMessageValidator.IsObjectValid --input = input
    if validation == false:
      return null
    map := {:}
    
    map["pin"] = input.pin  
    map["value"] = input.value  
    
    if input.resetTime != null:
      map["resetTime"] = input.resetTime  
    
    return map

  ///Deserializes the given Map to a GPIOTriggerMessage 
  Deserialize --input/Map -> GPIOTriggerMessage?:
    validation := GPIOTriggerMessageValidator.IsMapValid --input = input
    if validation == false:
      return null
    print "Deserializing Map to GPIOTriggerMessage"
    
    pin := input.get "pin"   
    val := input.get "value"  
    message := GPIOTriggerMessage pin val
    if input.contains "resetTime":
      message.resetTime = input.get "resetTime" 
    return message