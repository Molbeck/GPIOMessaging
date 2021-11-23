import gpio_messaging
import serialization

main:
  message / gpio_messaging.GpioTriggerMessage  := gpio_messaging.GpioTriggerMessage "abc" 123
  gpioTriggerSerializer := gpio_messaging.GpioTriggerMessageSerializer

  serialized := gpioTriggerSerializer.serialize message
  print  "Serialized through custom serializer: $serialized"
  binary := serialization.serialize serialized
  print "Serialized custom map to binary: $binary"
  deserializedBinary := serialization.deserialize binary 
  print "Deserialized binary: $deserializedBinary"
  deserialized := gpioTriggerSerializer.deserialize deserializedBinary
  isValid := deserialized is gpio_messaging.GpioTriggerMessage
  print "Deserialized through custom serializer: Is correct type: $isValid"
