import 'package:blog_app/widget/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // ignore: deprecated_member_use
      stream: Firestore.instance.collection('blog').orderBy('createdAt',descending: true).snapshots(),
      builder: (context,snapshot){
        if(!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        final allBlog = snapshot.data.docs;
        return Column(
          children: [
            UserData(),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.03,
            ),
            Text("Your Images",
              style: TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              )),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.03,
            ),
            Expanded(
              child: GridView.builder(
                itemCount: allBlog.length,
                itemBuilder: (context,index)=>allBlog[index]['userId'] == FirebaseAuth.instance.currentUser.uid ?
                  Container(child: GridTile(child: Image.network(allBlog[index]['imageUrl'],
                  fit: BoxFit.cover,),),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.pink,
                    ),
                  ),) :
                    null,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2/2,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 10,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
