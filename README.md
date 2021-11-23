# Gpio Messaging

Package to trigger GPIO pins through a message.

The usage for this would be for knowing that a publisher and a subscriber works on the same type of message - a kind of contract, you could say.

Library includes:
- GpioTriggerMessage: Container of a few properties regarding a single GPIO; pin, value and may include a reset time
- GpioTriggerMessageSerializer: Custom serializer, as "ubjson" is not able to serialize custom objects yet. So the given GpioTriggerMessage will be serialized to a Map, and the serializer is able to deserialize a Map back to a GpioTriggerMessage.

Use case:

We will be using it for communicate with our ESP32's remotely, triggering events on different GPIO's.
It will probably be extended, so it is possible to get GPIO status.
