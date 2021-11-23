// using GPiOMessaging
// main:
//   message / GPIOTriggerMessage := GPIOTriggerMessage "abc" 123
//   isValid := GPIOTriggerMessageValidator.IsObjectValid --input = message
//   print "Is this message valid? $isValid"
//   gpioTriggerSerializer := GPIOTriggerMessageSerializer

//   serialized := gpioTriggerSerializer.Serialize --input = message
//   print  "Serialized through custom serializer: $serialized"
//   binary := serialization.serialize serialized
//   print "Serialized custom map to binary: $binary"
//   deserializedBinary := serialization.deserialize binary 
//   print "Deserialized binary: $deserializedBinary"
//   deserialized := gpioTriggerSerializer.Deserialize --input= deserializedBinary
//   isValid = deserialized is GPIOTriggerMessage
//   print "Deserialized through custom serializer: Is correct type: $isValid"
//   isValid = GPIOTriggerMessageValidator.IsObjectValid --input = deserialized
//   print "Is deserialized valid: $isValid"
