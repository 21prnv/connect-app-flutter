import 'package:connect_app/widgets/FrostedGlassBox.dart';
import 'package:flutter/material.dart';

class PostCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: FrostedGlassBox(
        theWidth: double.infinity,
        theHeight: 500,
        theChild: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          width: 100, // Adjust the width as needed
                          height: 20,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 30, // Adjust the width as needed
                    height: 30,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30, // Adjust the width as needed
                        height: 30,
                        color: Colors.grey,
                      ),
                      Container(
                        width: 30, // Adjust the width as needed
                        height: 30,
                        color: Colors.grey,
                      ),
                      Container(
                        width: 30, // Adjust the width as needed
                        height: 30,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Container(
                    width: 30, // Adjust the width as needed
                    height: 30,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Container(
                width: 100, // Adjust the width as needed
                height: 14,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Row(
                children: [
                  Container(
                    width: 100, // Adjust the width as needed
                    height: 14,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 200, // Adjust the width as needed
                    height: 14,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 5),
                child: Container(
                  width: 120, // Adjust the width as needed
                  height: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 5),
              child: Container(
                width: 80, // Adjust the width as needed
                height: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
