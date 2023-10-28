import 'package:flutter/material.dart';

class BottomFloatingActionButton extends StatelessWidget {
  const BottomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0, -2),
                blurRadius: 3
            )
          ]
      ),
      child: FloatingActionButton.large(
        backgroundColor: Colors.white,
        elevation: 0,
        onPressed: () {},
        child: Image.asset('assets/image/main/핑키1.png', fit: BoxFit.contain, width: 85,),
      ),
    );
  }
}
