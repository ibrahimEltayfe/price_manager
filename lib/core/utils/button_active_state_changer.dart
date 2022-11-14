import 'dart:async';

class ButtonStateChanger{
  StreamController<bool> buttonStateController = StreamController<bool>.broadcast()..sink.add(false);

  void changeState(bool state){
    buttonStateController.sink.add(state);
  }

  void dispose(){
    buttonStateController.close();
  }

  Stream<bool> get output => buttonStateController.stream;
}