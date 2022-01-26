part of qiscus_chat_sdk.core;

MqttClient getMqttClient(Storage storage) {
  final clientId = getClientId(storage.appId);
  final connectionMessage = getConnectionMessage(clientId, storage?.userId);
  final brokerUrl = storage.brokerUrl;

  return MqttServerClient(brokerUrl, clientId)
        ..logging(on: false)
        ..port = 1885
        ..connectionMessage = connectionMessage
        ..websocketProtocols = ['mqtt']
        ..secure = true
        ..autoReconnect = true
        ..keepAlivePeriod = 5
        ..disconnectOnNoResponsePeriod = 1
      //
      ;
}

String getClientId(String appId, [int millis]) {
  var _millis = millis ?? DateTime.now().millisecondsSinceEpoch;
  return 'flutter-[$appId]-$_millis';
}

MqttConnectMessage getConnectionMessage(String clientId, String userId) {
  return MqttConnectMessage()
        ..withClientIdentifier(clientId)
        ..withWillTopic('u/$userId/s')
        ..withWillMessage('0')
        ..withWillRetain()
      //
      ;
}

abstract class MqttEventHandler<OutData> {
  const MqttEventHandler();
  String get topic;
  String publish();
  Stream<OutData> receive(Tuple2<String, String> message);
}
