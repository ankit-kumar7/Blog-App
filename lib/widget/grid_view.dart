import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GridViewWidget extends StatefulWidget {

  GridViewWidget({
    @required this.userId,
    @required this.blogImage,
    @required this.date,
    @required this.time,
    @required this.description,
  });

  final String userId;
  final String blogImage;
  final String date;
  final String time;
  final String description;
  
  @override
  _GridViewWidgetState createState() => _GridViewWidgetState();
}

class _GridViewWidgetState extends State<GridViewWidget> {

  bool hideHeading = false;
  bool favourite = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // ignore: deprecated_member_use
      future: Firestore.instance.collection('users').doc(widget.userId).get(),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        return Column(
          children: [
            Expanded(
              child: GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    favourite = !favourite;
                  });
                },
                onTap: () {
                  setState(() {
                    hideHeading = !hideHeading;
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GridTile(
                    child: Image.network(widget.blogImage,
                      fit: BoxFit.cover,
                    ),
                    header: hideHeading ? null : GridTileBar(
                      backgroundColor: Colors.black87,
                      leading: Row(
                        children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(snapshot.data['userImage'])),

                          SizedBox(width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.05,),

                          Text(snapshot.data['userName'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),),

                          SizedBox(width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.25,),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(widget.date,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),),

                              Text(widget.time,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),),

                            ],),
                        ],),
                    ),
                    footer: hideHeading ? null : GridTileBar(
                      backgroundColor: Colors.black87,
                      leading: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                                favourite ? Icons.favorite_outlined : Icons
                                    .favorite_outline_outlined),
                            iconSize: 30,
                            color: Colors.red,
                            onPressed: () {
                              setState(() {
                                favourite = !favourite;
                              });
                            },
                          ),

                          SizedBox(width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.05,),

                          IconButton(
                            icon: Icon(Icons.comment),
                            iconSize: 30,
                            onPressed: () {},
                          ),

                          SizedBox(width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.05,),

                          IconButton(
                            icon: Icon(Icons.share_sharp),
                            iconSize: 30,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Text(widget.description,
              style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,),
          ],
        );
      },
    );
  }
}


