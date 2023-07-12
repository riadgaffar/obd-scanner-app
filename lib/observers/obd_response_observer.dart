abstract class OBDResponseObserver {
  void onResponseReceived(String message);
}

class OBDResponse {
  final List<OBDResponseObserver> _observers = [];

  void registerObserver(OBDResponseObserver observer) {
    _observers.add(observer);
  }

  void removeObserver(OBDResponseObserver observer) {
    _observers.remove(observer);
  }

  void notifyObservers(String message) {
    for (var observer in _observers) {
      observer.onResponseReceived(message);
    }
  }
}
