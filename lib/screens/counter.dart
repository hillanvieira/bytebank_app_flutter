import 'package:bytebank_app/components/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


//Exemple de aplicação do BLOC pattern
class CounterCubit extends Cubit<int> {
  CounterCubit(int initialState) : super(0);

  void increment() => emit(state + 1);

  void decrement() => emit(state - 1);
}

class CounterContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(0),
      child: CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = bytebankTheme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Our count"),
      ),
      body: Center(
        child: BlocBuilder<CounterCubit, int>(builder: (context, state) {
          return Text(
            '$state',
            style: TextStyle(fontSize: 40),
          );
        }),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
               context.read<CounterCubit>().increment();
              }),
          SizedBox(height: 8,width: 0,),
          FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                context.read<CounterCubit>().decrement();
              }),
        ],
      ),
    );
  }
}
