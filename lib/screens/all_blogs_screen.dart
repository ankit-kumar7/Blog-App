import 'package:blog_app/widget/grid_view.dart';
import'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllBlogScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        // ignore: deprecated_member_use
        stream: Firestore.instance.collection('blog').orderBy('createdAt',descending: true).snapshots(),
        builder: (context,snapShot){
          if(snapShot.connectionState == ConnectionState.waiting)
            return Center(
            child: CircularProgressIndicator(),
            );
          final allBlog = snapShot.data.docs;
          return GridView.builder(
            itemCount: allBlog.length,
            itemBuilder: (context,index)=>GridViewWidget(
                userId: allBlog[index]['userId'],
                blogImage: allBlog[index]['imageUrl'],
                date: allBlog[index]['date'],
                time: allBlog[index]['time'],
                description: allBlog[index]['description']),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 2/2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 40,
          ),
        );
        });
  }
}
